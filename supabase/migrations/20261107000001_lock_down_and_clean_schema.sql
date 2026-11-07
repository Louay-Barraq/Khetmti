-- Lock down table access and remove columns the app now derives elsewhere.
-- Audit findings 1, 4, 7, 12, 15, S1.

-- 1. Clean data that would break the new constraints.
delete from friendships f
where not exists (select 1 from users u where u.doc_id = f.sender)
   or not exists (select 1 from users u where u.doc_id = f.receiver);

delete from friendships f
using friendships g
where least(f.sender, f.receiver) = least(g.sender, g.receiver)
  and greatest(f.sender, f.receiver) = greatest(g.sender, g.receiver)
  and (f."timestamp", f.doc_id) > (g."timestamp", g.doc_id);

delete from khatm_participants p
where not exists (select 1 from users u where u.doc_id = p.user_id);

-- 2. Constraints, defaults and foreign keys.
alter table friendships
  alter column doc_id set default gen_random_uuid()::text,
  alter column sender set not null,
  alter column receiver set not null,
  alter column status set default 'pending',
  add constraint friendships_not_self check (sender <> receiver),
  add constraint friendships_status_check check (status in ('pending', 'accepted')),
  add constraint friendships_sender_fkey foreign key (sender) references users (doc_id) on delete cascade,
  add constraint friendships_receiver_fkey foreign key (receiver) references users (doc_id) on delete cascade;
create unique index friendships_pair_key
  on friendships (least(sender, receiver), greatest(sender, receiver));

alter table khatms
  alter column doc_id set default gen_random_uuid()::text,
  alter column "createdAt" set default now(),
  add constraint khatms_max_participants_check check ("maxParticipantsNumber" >= 1);
create unique index khatms_code_key on khatms (code);

alter table khatm_participants
  add constraint khatm_participants_khatm_fkey foreign key (khatm_id) references khatms (doc_id) on delete cascade,
  add constraint khatm_participants_user_fkey foreign key (user_id) references users (doc_id) on delete cascade;

alter table xp_history
  add constraint xp_history_user_fkey foreign key (user_id) references users (doc_id) on delete cascade;

-- 3. Drop columns that duplicate other data.
--    email: auth.users holds it (and it must not be readable by other users).
--    friends: derived from accepted friendships.
--    khatmsJoined: derived from khatm_participants.
--    level: derived from totalXP in the app.
--    emailUpdated: only existed to sync email.
--    khatms.completionpercent: lowercase leftover of "completionPercent".
alter table users
  drop column email,
  drop column friends,
  drop column "khatmsJoined",
  drop column level,
  drop column "emailUpdated";
alter table khatms drop column completionpercent;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (doc_id, username, "photoUrl")
  values (
    new.id::text,
    coalesce(new.raw_user_meta_data ->> 'username', new.raw_user_meta_data ->> 'name'),
    new.raw_user_meta_data ->> 'photoUrl'
  )
  on conflict (doc_id) do update set
    username = excluded.username,
    "photoUrl" = excluded."photoUrl";
  return new;
end;
$$;

-- 4. Leftovers from an earlier schema.
drop view if exists public.rankings_v;
drop function if exists public.sync_khetma_progress();

-- 5. Row-level security: logged-in users only, each acting on their own rows.
drop policy "Migration Access" on users;
drop policy "Migration Access" on khatms;
drop policy "Migration Access" on khatm_participants;
drop policy "Migration Access" on friendships;
drop policy "Migration Access" on xp_history;

revoke all on users, khatms, khatm_participants, friendships, xp_history from anon, authenticated;

grant select on users, khatms, khatm_participants, friendships, xp_history to authenticated;
grant update (username, "lastSeen", "photoUrl") on users to authenticated;
grant insert (name, code, "splitType", "creatorId", "maxParticipantsNumber", parts, "totalParts"),
      delete on khatms to authenticated;
grant insert (sender, receiver), update (status), delete on friendships to authenticated;

create policy users_read on users
  for select to authenticated using (true);
create policy users_update_own on users
  for update to authenticated
  using (doc_id = auth.uid()::text) with check (doc_id = auth.uid()::text);

create policy khatms_read on khatms
  for select to authenticated using (true);
create policy khatms_insert_own on khatms
  for insert to authenticated with check ("creatorId" = auth.uid()::text);
create policy khatms_delete_own on khatms
  for delete to authenticated using ("creatorId" = auth.uid()::text);

create policy khatm_participants_read on khatm_participants
  for select to authenticated using (true);

create policy friendships_read_own on friendships
  for select to authenticated using (auth.uid()::text in (sender, receiver));
create policy friendships_request on friendships
  for insert to authenticated with check (sender = auth.uid()::text);
create policy friendships_accept on friendships
  for update to authenticated
  using (receiver = auth.uid()::text and status = 'pending')
  with check (status = 'accepted');
create policy friendships_delete_own on friendships
  for delete to authenticated using (auth.uid()::text in (sender, receiver));

create policy xp_history_read_own on xp_history
  for select to authenticated using (user_id = auth.uid()::text);

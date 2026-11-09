-- Lets a signed-in user delete their own account (required by the App Store
-- and Google Play). Runs in one transaction:
--   1. parts the user reserved but did not finish become available again;
--      finished parts keep the reader's name as history,
--   2. khatmas the user created pass to the member who joined next, or are
--      deleted when nobody else is in them,
--   3. the profile row is deleted (memberships, friendships and XP history
--      cascade), member counts are corrected, and the login is removed.
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid text := auth.uid()::text;
  v_joined text[];
begin
  if v_uid is null then raise exception 'not_authenticated'; end if;

  select coalesce(array_agg(khatm_id), '{}') into v_joined
  from khatm_participants where user_id = v_uid;

  update khatms k set
    parts = (
      select jsonb_object_agg(e.key, case
        when e.value ->> 'uid' = v_uid and e.value ->> 'status' = 'reserved'
          then jsonb_build_object('uid', null, 'status', 'available')
        else e.value end)
      from jsonb_each(k.parts) e
    ),
    "updatedAt" = now()
  where k.doc_id = any (v_joined)
    and exists (
      select 1 from jsonb_each(k.parts) e
      where e.value ->> 'uid' = v_uid and e.value ->> 'status' = 'reserved'
    );

  update khatms k set "creatorId" = (
    select p.user_id from khatm_participants p
    where p.khatm_id = k.doc_id and p.user_id <> v_uid
    order by p."joinedAt" limit 1
  )
  where k."creatorId" = v_uid
    and exists (
      select 1 from khatm_participants p
      where p.khatm_id = k.doc_id and p.user_id <> v_uid
    );

  delete from khatms where "creatorId" = v_uid;

  delete from users where doc_id = v_uid;

  update khatms k set "currentParticipantsNumber" = (
    select count(*) from khatm_participants p where p.khatm_id = k.doc_id
  )
  where k.doc_id = any (v_joined);

  delete from auth.users where id = v_uid::uuid;
end;
$$;

revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

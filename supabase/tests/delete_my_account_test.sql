-- Checks delete_my_account (migration 20261109000001).
-- Run as the postgres role. Everything is rolled back.
begin;

insert into auth.users (id, email, raw_user_meta_data) values
  ('00000000-0000-0000-0000-0000000000d1', 'd1@test.invalid', '{"username": "test_d1"}'),
  ('00000000-0000-0000-0000-0000000000d2', 'd2@test.invalid', '{"username": "test_d2"}');

-- D1 creates two khatmas: one shared with D2, one alone.
insert into khatms (doc_id, name, code, "creatorId", "splitType", "maxParticipantsNumber", parts, "totalParts") values
  ('test-shared', 'Shared', '00002', '00000000-0000-0000-0000-0000000000d1', 'sura', 5,
   '{"الفاتحة": {"status": "available"}, "البقرة": {"status": "available"}}', 2),
  ('test-alone', 'Alone', '00003', '00000000-0000-0000-0000-0000000000d1', 'sura', 5,
   '{"الفاتحة": {"status": "available"}}', 1);

set local request.jwt.claims = '{"sub": "00000000-0000-0000-0000-0000000000d2"}';
select join_khatm('test-shared');

set local request.jwt.claims = '{"sub": "00000000-0000-0000-0000-0000000000d1"}';
select update_part_status('test-shared', 'الفاتحة', 'reserved');
select update_part_status('test-shared', 'البقرة', 'reserved');
select update_part_status('test-shared', 'البقرة', 'finished');
insert into friendships (sender, receiver) values
  ('00000000-0000-0000-0000-0000000000d1', '00000000-0000-0000-0000-0000000000d2');

select delete_my_account();

do $$ begin
  assert not exists (select 1 from auth.users where id = '00000000-0000-0000-0000-0000000000d1'), 'login removed';
  assert not exists (select 1 from users where doc_id = '00000000-0000-0000-0000-0000000000d1'), 'profile removed';
  assert not exists (select 1 from friendships where sender = '00000000-0000-0000-0000-0000000000d1'), 'friendships removed';
  assert not exists (select 1 from khatms where doc_id = 'test-alone'), 'khatma with no one left is deleted';
  assert (select "creatorId" from khatms where doc_id = 'test-shared') = '00000000-0000-0000-0000-0000000000d2',
    'shared khatma passes to D2';
  assert (select "currentParticipantsNumber" from khatms where doc_id = 'test-shared') = 1, 'member count corrected';
  assert (select parts -> 'الفاتحة' ->> 'status' from khatms where doc_id = 'test-shared') = 'available',
    'reserved part released';
  assert (select parts -> 'البقرة' ->> 'status' from khatms where doc_id = 'test-shared') = 'finished',
    'finished part kept';
end $$;

-- Logged out: refused.
set local request.jwt.claims = '{}';
do $$ begin
  perform delete_my_account();
  raise exception 'expected not_authenticated';
exception when others then
  assert sqlerrm = 'not_authenticated', sqlerrm;
end $$;

rollback;

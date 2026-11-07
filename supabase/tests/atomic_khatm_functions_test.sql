-- Checks join_khatm and update_part_status (migration 20261107000002).
-- Run as the postgres role (SQL editor, psql or the Supabase MCP). Everything
-- is rolled back; a failed assert stops with the reason.
begin;

insert into users (doc_id, username) values
  ('00000000-0000-0000-0000-00000000000a', 'test_a'),
  ('00000000-0000-0000-0000-00000000000b', 'test_b'),
  ('00000000-0000-0000-0000-00000000000c', 'test_c');

insert into khatms (doc_id, name, code, "creatorId", "splitType", "maxParticipantsNumber", parts, "totalParts")
values ('test-khatm', 'Test', '00001', '00000000-0000-0000-0000-00000000000a', 'sura', 2,
  '{"الفاتحة": {"status": "available"}, "البقرة": {"status": "available"}}', 2);

do $$ begin
  assert (select count(*) from khatm_participants where khatm_id = 'test-khatm') = 1,
    'creator is added as a participant';
end $$;

-- A reserves Al-Fatiha: +10 XP.
set local request.jwt.claims = '{"sub": "00000000-0000-0000-0000-00000000000a"}';
select update_part_status('test-khatm', 'الفاتحة', 'reserved');
do $$ begin
  assert (select "totalXP" from users where username = 'test_a') = 10, 'reserve gives 10 XP';
  assert (select parts -> 'الفاتحة' ->> 'uid' from khatms where doc_id = 'test-khatm')
    = '00000000-0000-0000-0000-00000000000a', 'part belongs to A';
end $$;

-- B is not a member yet.
set local request.jwt.claims = '{"sub": "00000000-0000-0000-0000-00000000000b"}';
do $$ begin
  perform update_part_status('test-khatm', 'البقرة', 'reserved');
  raise exception 'expected not_a_participant';
exception when others then
  assert sqlerrm = 'not_a_participant', sqlerrm;
end $$;

-- B joins; joining twice fails; B cannot touch A's part.
select join_khatm('test-khatm');
do $$ begin
  assert (select "currentParticipantsNumber" from khatms where doc_id = 'test-khatm') = 2, 'count is 2';
  begin
    perform join_khatm('test-khatm');
    raise exception 'expected already_joined';
  exception when others then
    assert sqlerrm = 'already_joined', sqlerrm;
  end;
  begin
    perform update_part_status('test-khatm', 'الفاتحة', 'available');
    raise exception 'expected invalid_transition';
  exception when others then
    assert sqlerrm = 'invalid_transition', sqlerrm;
  end;
end $$;

-- C cannot join a full khatma (max 2).
set local request.jwt.claims = '{"sub": "00000000-0000-0000-0000-00000000000c"}';
do $$ begin
  perform join_khatm('test-khatm');
  raise exception 'expected khatm_full';
exception when others then
  assert sqlerrm = 'khatm_full', sqlerrm;
end $$;

-- A finishes Al-Fatiha (7 ayahs): +50 + 2*7 = +64 XP.
set local request.jwt.claims = '{"sub": "00000000-0000-0000-0000-00000000000a"}';
select update_part_status('test-khatm', 'الفاتحة', 'finished');
do $$ begin
  assert (select "totalXP" from users where username = 'test_a') = 74, 'finish gives 64 XP';
  assert (select ("readingStats" ->> 'الفاتحة')::int from users where username = 'test_a') = 1, 'reading stat +1';
  assert (select "finishedParts" from khatms where doc_id = 'test-khatm') = 1, 'one part finished';
  assert (select "completionPercent" from khatms where doc_id = 'test-khatm') = 0.5, 'half complete';
end $$;

-- A undoes, then releases: everything returns to zero.
select update_part_status('test-khatm', 'الفاتحة', 'reserved');
select update_part_status('test-khatm', 'الفاتحة', 'available');
do $$ begin
  assert (select "totalXP" from users where username = 'test_a') = 0, 'XP back to 0';
  assert (select ("readingStats" ->> 'الفاتحة')::int from users where username = 'test_a') = 0, 'reading stat back to 0';
  assert (select "finishedParts" from khatms where doc_id = 'test-khatm') = 0, 'no part finished';
  assert (select parts -> 'الفاتحة' ->> 'status' from khatms where doc_id = 'test-khatm') = 'available', 'part free';
  assert (select cardinality(logs) from khatms where doc_id = 'test-khatm') = 4, 'four log entries';
  assert (select count(*) from xp_history where user_id = '00000000-0000-0000-0000-00000000000a') = 4, 'four XP rows';
end $$;

rollback;

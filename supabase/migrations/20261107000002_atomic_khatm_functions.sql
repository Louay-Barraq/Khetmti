-- Atomic khatma writes: one transaction per action, row locked while it runs.
-- Audit findings 2, 6, 17, R1. Clients have no direct UPDATE on khatms,
-- khatm_participants, users XP columns or xp_history; these functions do it.

-- Ayah count per sura, used for sura XP (50 + 2 per ayah).
create or replace function public.sura_ayahs(p_sura text)
returns int
language sql
immutable
set search_path = public
as $$
  select ('{"الفاتحة": 7, "البقرة": 286, "آل عمران": 200, "النساء": 176, "المائدة": 120, "الأنعام": 165, "الأعراف": 206, "الأنفال": 75, "التوبة": 129, "يونس": 109, "هود": 123, "يوسف": 111, "الرعد": 43, "إبراهيم": 52, "الحجر": 99, "النحل": 128, "الإسراء": 111, "الكهف": 110, "مريم": 98, "طه": 135, "الأنبياء": 112, "الحج": 78, "المؤمنون": 118, "النور": 64, "الفرقان": 77, "الشعراء": 227, "النمل": 93, "القصص": 88, "العنكبوت": 69, "الروم": 60, "لقمان": 34, "السجدة": 30, "الأحزاب": 73, "سبأ": 54, "فاطر": 45, "يس": 83, "الصافات": 182, "ص": 88, "الزمر": 75, "غافر": 85, "فصلت": 54, "الشورى": 53, "الزخرف": 89, "الدخان": 59, "الجاثية": 37, "الأحقاف": 35, "محمد": 38, "الفتح": 29, "الحجرات": 18, "ق": 45, "الذاريات": 60, "الطور": 49, "النجم": 62, "القمر": 55, "الرحمن": 78, "الواقعة": 96, "الحديد": 29, "المجادلة": 22, "الحشر": 24, "الممتحنة": 13, "الصف": 14, "الجمعة": 11, "المنافقون": 11, "التغابن": 18, "الطلاق": 12, "التحريم": 12, "الملك": 30, "القلم": 52, "الحاقة": 52, "المعارج": 44, "نوح": 28, "الجن": 28, "المزمل": 20, "المدثر": 56, "القيامة": 40, "الإنسان": 31, "المرسلات": 50, "النبأ": 40, "النازعات": 46, "عبس": 42, "التكوير": 29, "الانفطار": 19, "المطففين": 36, "الإنشقاق": 25, "البروج": 22, "الطارق": 17, "الأعلى": 19, "الغاشية": 26, "الفجر": 30, "البلد": 20, "الشمس": 15, "الليل": 21, "الضحى": 11, "الشرح": 8, "التين": 8, "العلق": 19, "القدر": 5, "البينة": 8, "الزلزلة": 8, "العاديات": 11, "القارعة": 11, "التكاثر": 8, "العصر": 3, "الهمزة": 9, "الفيل": 5, "قريش": 4, "الماعون": 7, "الكوثر": 3, "الكافرون": 6, "النصر": 3, "المسد": 5, "الإخلاص": 4, "الفلق": 5, "الناس": 6}'::jsonb ->> p_sura)::int
$$;

-- The creator joins their own khatma as soon as it is created.
create or replace function public.add_creator_as_participant()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into khatm_participants (khatm_id, user_id) values (new.doc_id, new."creatorId");
  return new;
end;
$$;

create trigger khatms_add_creator
  after insert on khatms
  for each row execute function add_creator_as_participant();

-- Join a khatma. Errors: not_authenticated, khatm_not_found, already_joined, khatm_full.
create or replace function public.join_khatm(p_khatm_id text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid text := auth.uid()::text;
  v_max int;
  v_count int;
begin
  if v_uid is null then raise exception 'not_authenticated'; end if;

  select "maxParticipantsNumber" into v_max from khatms where doc_id = p_khatm_id for update;
  if not found then raise exception 'khatm_not_found'; end if;

  if exists (select 1 from khatm_participants where khatm_id = p_khatm_id and user_id = v_uid) then
    raise exception 'already_joined';
  end if;

  select count(*) into v_count from khatm_participants where khatm_id = p_khatm_id;
  if v_count >= v_max then raise exception 'khatm_full'; end if;

  insert into khatm_participants (khatm_id, user_id) values (p_khatm_id, v_uid);
  update khatms set "currentParticipantsNumber" = v_count + 1, "updatedAt" = now()
  where doc_id = p_khatm_id;
end;
$$;

-- Reserve, release, finish or un-finish one part, and give the matching XP.
-- Errors: not_authenticated, khatm_not_found, not_a_participant, unknown_part, invalid_transition.
create or replace function public.update_part_status(p_khatm_id text, p_part text, p_new_status text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid text := auth.uid()::text;
  v_k khatms%rowtype;
  v_old text;
  v_owner text;
  v_name text;
  v_base int;
  v_xp int;
  v_finished int;
  v_action text;
  v_logs jsonb[];
begin
  if v_uid is null then raise exception 'not_authenticated'; end if;

  select * into v_k from khatms where doc_id = p_khatm_id for update;
  if not found then raise exception 'khatm_not_found'; end if;

  if not exists (select 1 from khatm_participants where khatm_id = p_khatm_id and user_id = v_uid) then
    raise exception 'not_a_participant';
  end if;
  if not (v_k.parts ? p_part) then raise exception 'unknown_part'; end if;

  v_old := coalesce(v_k.parts -> p_part ->> 'status', 'available');
  v_owner := v_k.parts -> p_part ->> 'uid';

  if not (
    (v_old = 'available' and p_new_status = 'reserved')
    or (v_owner = v_uid and v_old = 'reserved' and p_new_status in ('available', 'finished'))
    or (v_owner = v_uid and v_old = 'finished' and p_new_status = 'reserved')
  ) then
    raise exception 'invalid_transition';
  end if;

  select coalesce(username, 'Unknown') into v_name from users where doc_id = v_uid;

  v_base := case when v_k."splitType" = 'sura' then 50 + 2 * coalesce(sura_ayahs(p_part), 0) else 500 end;
  v_xp := case
    when v_old = 'available' then 10
    when p_new_status = 'available' then -10
    when p_new_status = 'finished' then v_base
    else -v_base
  end;
  v_action := case
    when v_old = 'available' then 'حجز'
    when p_new_status = 'finished' then 'أتم القراءة'
    when p_new_status = 'available' then 'ألغى الحجز'
    else 'تراجع عن القراءة'
  end;
  v_finished := v_k."finishedParts"
    + case when p_new_status = 'finished' then 1 when v_old = 'finished' then -1 else 0 end;

  -- Keep only the latest 50 log entries.
  v_logs := coalesce(v_k.logs, '{}') || jsonb_build_object(
    'username', v_name, 'uid', v_uid, 'part', p_part, 'action', v_action, 'timestamp', now());
  v_logs := v_logs[greatest(1, cardinality(v_logs) - 49):];

  update khatms set
    parts = jsonb_set(parts, array[p_part], jsonb_build_object(
      'status', p_new_status,
      'uid', case when p_new_status = 'available' then null else v_uid end,
      'username', case when p_new_status = 'available' then null else v_name end)),
    "finishedParts" = v_finished,
    "completionPercent" = v_finished::float8 / greatest("totalParts", 1),
    logs = v_logs,
    "updatedAt" = now()
  where doc_id = p_khatm_id;

  update users set
    "totalXP" = greatest(0, coalesce("totalXP", 0) + v_xp),
    "readingStats" = case
      when p_new_status = 'finished' then jsonb_set(coalesce("readingStats", '{}'), array[p_part],
        to_jsonb(coalesce(("readingStats" ->> p_part)::int, 0) + 1))
      when v_old = 'finished' then jsonb_set(coalesce("readingStats", '{}'), array[p_part],
        to_jsonb(greatest(0, coalesce(("readingStats" ->> p_part)::int, 0) - 1)))
      else "readingStats"
    end
  where doc_id = v_uid;

  insert into xp_history (user_id, amount, reason) values (v_uid, v_xp, v_action || ' ' || p_part);
end;
$$;

revoke execute on function public.join_khatm(text), public.update_part_status(text, text, text),
  public.add_creator_as_participant() from public, anon;
grant execute on function public.join_khatm(text), public.update_part_status(text, text, text) to authenticated;

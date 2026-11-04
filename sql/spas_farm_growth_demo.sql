-- SPAS: class growth farm demo stages (ASCII-only SQL file)
-- PostgreSQL; safe to re-run (biz_key / student_id upsert)
-- Stages: seed 0-14 / seedling 15-49 / sapling 50-149 / tree 150+

do $$
declare
  v_dept_id   int8;
  v_week_start date := date_trunc('week', current_date)::date;
  r           record;
  i           int := 0;
  n           int;
  pts         int;
  lv          int;
  stage_pts   int[] := array[
    0, 8, 15, 28, 49, 50, 80, 120, 149, 150, 200, 280
  ];
begin
  select s.dept_id into v_dept_id
  from spas_student s
  where coalesce(s.del_flag, '0') = '0'
    and coalesce(s.status, '0') = '0'
    and s.dept_id is not null
  group by s.dept_id
  order by count(*) desc, s.dept_id
  limit 1;

  if v_dept_id is null then
    raise exception 'no class with students found in spas_student';
  end if;

  select count(*) into n
  from spas_student s
  where s.dept_id = v_dept_id
    and coalesce(s.del_flag, '0') = '0'
    and coalesce(s.status, '0') = '0';

  raise notice 'farm demo dept_id=% students=%', v_dept_id, n;

  for r in
    select s.student_id, s.student_name, s.student_no, s.dept_id
    from spas_student s
    where s.dept_id = v_dept_id
      and coalesce(s.del_flag, '0') = '0'
      and coalesce(s.status, '0') = '0'
    order by s.student_id
  loop
    pts := stage_pts[1 + (i % array_length(stage_pts, 1))];
    lv := 1 + floor((sqrt(1.0 + 8.0 * pts / 50.0) - 1.0) / 2.0)::int;

    insert into spas_student_point_account(
      student_id, total_points, level_no, day_streak, last_practice_date,
      week_points, week_start, update_time)
    values (
      r.student_id, pts, lv,
      case when pts >= 15 then 3 else 0 end,
      case when pts > 0 then current_date - ((i % 3)) else null end,
      least(pts, 40), v_week_start, now())
    on conflict (student_id) do update set
      total_points = excluded.total_points,
      level_no = excluded.level_no,
      day_streak = excluded.day_streak,
      last_practice_date = excluded.last_practice_date,
      week_points = excluded.week_points,
      week_start = excluded.week_start,
      update_time = now();

    if pts > 0 then
      insert into spas_student_point_ledger(
        student_id, dept_id, subject_id, points, reason_code,
        ref_type, ref_id, biz_key, remark, create_time)
      values (
        r.student_id, r.dept_id, null, pts, 'FARM_DEMO',
        'demo', 'farm_growth',
        'FARM_DEMO:' || r.student_id::text,
        'farm demo - ' ||
          case
            when pts < 15 then 'seed'
            when pts < 50 then 'seedling'
            when pts < 150 then 'sapling'
            else 'tree'
          end,
        now() - (i || ' hours')::interval)
      on conflict (biz_key) do update set
        points = excluded.points,
        remark = excluded.remark,
        create_time = excluded.create_time;
    end if;

    i := i + 1;
  end loop;

  raise notice 'done: wrote stage ladder for % students', n;
end $$;

select
  d.dept_name,
  s.student_name,
  a.total_points,
  a.level_no,
  case
    when coalesce(a.total_points, 0) < 15 then 'seed'
    when a.total_points < 50 then 'seedling'
    when a.total_points < 150 then 'sapling'
    else 'tree'
  end as farm_stage
from spas_student s
join sys_dept d on d.dept_id = s.dept_id
left join spas_student_point_account a on a.student_id = s.student_id
where s.dept_id = (
  select dept_id from spas_student
  where coalesce(del_flag,'0')='0' and coalesce(status,'0')='0' and dept_id is not null
  group by dept_id order by count(*) desc, dept_id limit 1
)
  and coalesce(s.del_flag, '0') = '0'
order by a.total_points nulls first, s.student_id;

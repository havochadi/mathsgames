-- Supabase setup for Alya's Weight Adventure cloud sync
-- Run this in Supabase SQL Editor once.

create table if not exists public.alya_progress (
  student_id text primary key,
  student_name text not null default 'Student',
  sessions jsonb not null default '[]'::jsonb,
  attempts jsonb not null default '[]'::jsonb,
  tutor_pin text not null default '1234',
  updated_at timestamptz not null default timezone('utc', now()),
  constraint alya_progress_pin_chk check (tutor_pin ~ '^[0-9]{4}$')
);

alter table public.alya_progress
  add column if not exists student_name text not null default 'Student';
alter table public.alya_progress
  add column if not exists sessions jsonb not null default '[]'::jsonb;
alter table public.alya_progress
  add column if not exists attempts jsonb not null default '[]'::jsonb;
alter table public.alya_progress
  add column if not exists tutor_pin text not null default '1234';
alter table public.alya_progress
  add column if not exists updated_at timestamptz not null default timezone('utc', now());

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'alya_progress_pin_chk'
      and conrelid = 'public.alya_progress'::regclass
  ) then
    alter table public.alya_progress
      add constraint alya_progress_pin_chk check (tutor_pin ~ '^[0-9]{4}$');
  end if;
end
$$;

update public.alya_progress
set student_name = initcap(replace(student_id, '-', ' '))
where coalesce(student_name, '') = '' or student_name = 'Student';

create or replace function public.alya_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists alya_progress_touch_updated_at on public.alya_progress;
create trigger alya_progress_touch_updated_at
before update on public.alya_progress
for each row
execute function public.alya_touch_updated_at();

alter table public.alya_progress enable row level security;

-- Simple policy set for static-site usage with anon key.
-- Anyone with your project URL + key can read/write this table.
-- Student identity is based on the name entered at login.
drop policy if exists "alya_progress_select_anon" on public.alya_progress;
create policy "alya_progress_select_anon"
on public.alya_progress
for select
to anon
using (true);

drop policy if exists "alya_progress_insert_anon" on public.alya_progress;
create policy "alya_progress_insert_anon"
on public.alya_progress
for insert
to anon
with check (true);

drop policy if exists "alya_progress_update_anon" on public.alya_progress;
create policy "alya_progress_update_anon"
on public.alya_progress
for update
to anon
using (true)
with check (true);

grant usage on schema public to anon;
grant select, insert, update on table public.alya_progress to anon;

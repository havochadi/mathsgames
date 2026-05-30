-- Supabase setup for Alya's Weight Adventure cloud sync
-- Run this in Supabase SQL Editor once.

create table if not exists public.alya_progress (
  student_id text primary key,
  sessions jsonb not null default '[]'::jsonb,
  attempts jsonb not null default '[]'::jsonb,
  tutor_pin text not null default '1234',
  updated_at timestamptz not null default timezone('utc', now()),
  constraint alya_progress_pin_chk check (tutor_pin ~ '^[0-9]{4}$')
);

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
-- Use long, hard-to-guess Sync IDs per student/class.
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

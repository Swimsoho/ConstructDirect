-- MaterialFaire MVP Tracker — Supabase schema
-- Run this once in Supabase → SQL Editor → New query → Run.

-- 1. Table -------------------------------------------------------------
create table if not exists public.tasks (
  id          text primary key,
  ws          text not null,
  phase       text not null default '',
  prio        text not null default 'P2',
  deps        text[] not null default '{}',
  title       text not null,
  descr       text not null default '',
  status      text not null default 'Not started',
  owner       text not null default '',
  due         date,
  note        text not null default '',
  sort_order  int  not null default 0,
  updated_by  text not null default '',
  updated_at  timestamptz not null default now()
);

-- 2. Auto-stamp updated_at on every write -------------------------------
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists tasks_touch_updated_at on public.tasks;
create trigger tasks_touch_updated_at
  before update on public.tasks
  for each row execute function public.touch_updated_at();

-- 3. Row Level Security --------------------------------------------------
-- NOTE: the anon key ships in the browser, so these policies mean
-- "anyone who has the site URL can read and edit the board."
-- That is the intended tradeoff for a small founder team with an
-- unadvertised URL. Delete is intentionally NOT granted.
alter table public.tasks enable row level security;

drop policy if exists tasks_anon_select on public.tasks;
create policy tasks_anon_select on public.tasks
  for select to anon using (true);

drop policy if exists tasks_anon_insert on public.tasks;
create policy tasks_anon_insert on public.tasks
  for insert to anon with check (true);

drop policy if exists tasks_anon_update on public.tasks;
create policy tasks_anon_update on public.tasks
  for update to anon using (true) with check (true);

-- 4. Realtime (optional, enables instant cross-user sync) -----------------
-- The app also polls every 20s, so this is a nice-to-have.
alter publication supabase_realtime add table public.tasks;

-- Done. Now open the site and click "Seed tasks" once to load the 15 rows.

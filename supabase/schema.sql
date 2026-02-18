-- Cartfest Supabase schema
-- Ejecutar en Supabase SQL Editor

create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  handle text unique,
  avatar_url text,
  bio text,
  country text,
  classification text default 'Iniciando',
  updated_at timestamptz default now()
);

create table if not exists public.follows (
  follower_id uuid not null references public.profiles(id) on delete cascade,
  followed_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (follower_id, followed_id),
  check (follower_id <> followed_id)
);

create table if not exists public.direct_messages (
  id text primary key,
  from_user_id uuid not null references public.profiles(id) on delete cascade,
  to_user_id uuid not null references public.profiles(id) on delete cascade,
  text text not null,
  created_at timestamptz default now()
);

create table if not exists public.event_chat (
  id text primary key,
  event_id text not null,
  author text not null,
  text text not null,
  created_at timestamptz default now()
);

create table if not exists public.event_registrations (
  id text primary key,
  event_id text not null,
  user_id uuid not null references public.profiles(id) on delete cascade,
  vehicle_name text not null,
  vehicle_brand text not null,
  vehicle_photo_url text,
  category text not null,
  origin text not null,
  classification text not null,
  sections text[] not null default '{}',
  modifications text[] not null default '{}',
  created_at timestamptz default now(),
  check (origin in ('Europeo', 'Asiatico', 'Americano')),
  check (classification in ('Pro', 'Master', 'Excelent', 'Medium', 'Amateur', 'Iniciando', 'Fanatico', 'Entusiasta'))
);

create table if not exists public.feed_posts (
  id text primary key,
  author_id uuid not null references public.profiles(id) on delete cascade,
  vehicle_id text not null,
  caption text,
  likes integer default 0,
  comments integer default 0,
  created_at timestamptz default now()
);

create table if not exists public.story_items (
  id text primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  image_url text not null,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.follows enable row level security;
alter table public.direct_messages enable row level security;
alter table public.event_chat enable row level security;
alter table public.event_registrations enable row level security;
alter table public.feed_posts enable row level security;
alter table public.story_items enable row level security;

-- profiles
create policy "profiles_select_all" on public.profiles for select to authenticated using (true);
create policy "profiles_insert_own" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update to authenticated using (auth.uid() = id);

-- follows
create policy "follows_select_all" on public.follows for select to authenticated using (true);
create policy "follows_insert_own" on public.follows for insert to authenticated with check (auth.uid() = follower_id);
create policy "follows_delete_own" on public.follows for delete to authenticated using (auth.uid() = follower_id);

-- direct messages
create policy "dm_select_participants" on public.direct_messages for select to authenticated using (auth.uid() = from_user_id or auth.uid() = to_user_id);
create policy "dm_insert_sender" on public.direct_messages for insert to authenticated with check (auth.uid() = from_user_id);

-- event chat
create policy "event_chat_select_all" on public.event_chat for select to authenticated using (true);
create policy "event_chat_insert_all" on public.event_chat for insert to authenticated with check (true);

-- event registrations
create policy "event_reg_select_own" on public.event_registrations for select to authenticated using (auth.uid() = user_id);
create policy "event_reg_insert_own" on public.event_registrations for insert to authenticated with check (auth.uid() = user_id);

-- feed posts
create policy "feed_posts_select_all" on public.feed_posts for select to authenticated using (true);
create policy "feed_posts_insert_own" on public.feed_posts for insert to authenticated with check (auth.uid() = author_id);
create policy "feed_posts_update_own" on public.feed_posts for update to authenticated using (auth.uid() = author_id);

-- stories
create policy "stories_select_all" on public.story_items for select to authenticated using (true);
create policy "stories_insert_own" on public.story_items for insert to authenticated with check (auth.uid() = user_id);
create policy "stories_delete_own" on public.story_items for delete to authenticated using (auth.uid() = user_id);

-- Pertemuan 9 - Authentication, Authorization & Push Notifications
-- 2415051065 I Kadek Very Andika
-- Jalankan di Supabase Dashboard > SQL Editor (project course-data-manager).

-- =========================================================
-- Praktik 3: tabel profiles + trigger pembuat profil otomatis
-- =========================================================
create table if not exists public.profiles (
  id    uuid primary key references auth.users(id) on delete cascade,
  email text,
  name  text,
  role  text not null default 'seeker'
        check (role in ('seeker', 'owner', 'admin'))
);

alter table public.profiles enable row level security;

-- user hanya boleh membaca profile miliknya sendiri.
-- Tidak ada policy UPDATE, sehingga user tidak dapat mengubah role sendiri.
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select to authenticated
  using (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', ''),
    case
      when new.raw_user_meta_data->>'role' in ('seeker', 'owner')
        then new.raw_user_meta_data->>'role'
      else 'seeker'
    end
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- =========================================================
-- Praktik 5: tabel kos dengan ownership + Row Level Security
-- =========================================================
create table if not exists public.kos (
  id         uuid primary key default gen_random_uuid(),
  owner_id   uuid not null default auth.uid()
             references auth.users(id) on delete cascade,
  name       text not null check (char_length(trim(name)) > 0),
  address    text,
  price      integer check (price is null or price >= 0),
  created_at timestamptz not null default now()
);

alter table public.kos enable row level security;

create or replace function public.is_admin()
returns boolean
language sql stable
security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

drop policy if exists "kos_select_authenticated" on public.kos;
drop policy if exists "kos_insert_owner" on public.kos;
drop policy if exists "kos_update_own" on public.kos;
drop policy if exists "kos_delete_own" on public.kos;
drop policy if exists "kos_admin_all" on public.kos;

-- 1. SELECT: semua user yang sudah login boleh membaca
create policy "kos_select_authenticated"
  on public.kos for select to authenticated
  using (true);

-- 2. INSERT: owner_id = user yang login, dan role owner / admin
create policy "kos_insert_owner"
  on public.kos for insert to authenticated
  with check (
    auth.uid() = owner_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'admin')
    )
  );

-- 3. UPDATE: hanya pemilik data
create policy "kos_update_own"
  on public.kos for update to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- 4. DELETE: hanya pemilik data
create policy "kos_delete_own"
  on public.kos for delete to authenticated
  using (auth.uid() = owner_id);

-- Opsional: admin boleh mengelola seluruh data
create policy "kos_admin_all"
  on public.kos for all to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- =========================================================
-- Praktik 9: device_tokens (registrasi perangkat untuk FCM)
-- =========================================================
create table if not exists public.device_tokens (
  token      text primary key,
  user_id    uuid not null default auth.uid()
             references auth.users(id) on delete cascade,
  platform   text,
  updated_at timestamptz not null default now()
);

alter table public.device_tokens enable row level security;

drop policy if exists "tokens_select_own" on public.device_tokens;
drop policy if exists "tokens_insert_own" on public.device_tokens;
drop policy if exists "tokens_update_own" on public.device_tokens;
drop policy if exists "tokens_delete_own" on public.device_tokens;

create policy "tokens_select_own" on public.device_tokens
  for select to authenticated using (auth.uid() = user_id);
create policy "tokens_insert_own" on public.device_tokens
  for insert to authenticated with check (auth.uid() = user_id);
create policy "tokens_update_own" on public.device_tokens
  for update to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "tokens_delete_own" on public.device_tokens
  for delete to authenticated using (auth.uid() = user_id);

-- =========================================================
-- Pemeriksaan
-- =========================================================
-- select tablename, policyname, cmd from pg_policies
--   where schemaname = 'public' and tablename in ('profiles','kos','device_tokens');
-- select relname, relrowsecurity from pg_class where relname in ('profiles','kos','device_tokens');

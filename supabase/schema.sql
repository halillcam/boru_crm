-- ============================================================
-- Börü CRM — Supabase Database Schema
-- Bu dosyayı Supabase projenizin SQL Editor'üne yapıştırıp
-- çalıştırarak tüm tabloları, RLS ayarlarını ve policy'leri
-- tek seferde oluşturabilirsiniz.
-- ============================================================

-- ------------------------------------------------------------
-- 1. TABLOLAR
-- ------------------------------------------------------------

-- Müşteriler tablosu
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null default auth.uid(),
  name text not null,
  phone text,
  email text,
  status text not null default 'pending', -- pending, paid, unpaid
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Müşteri notları tablosu
create table if not exists notes (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id) on delete cascade not null,
  user_id uuid references auth.users(id) not null default auth.uid(),
  content text not null,
  created_at timestamptz not null default now()
);

-- Ürünler tablosu
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null default auth.uid(),
  name text not null,
  price numeric not null default 0,
  created_at timestamptz not null default now()
);

-- Satın alma / ödeme tablosu
create table if not exists purchases (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null default auth.uid(),
  customer_id uuid references customers(id) on delete cascade not null,
  product_id uuid references products(id) on delete cascade not null,
  purchased_at timestamptz not null default now(),
  is_paid boolean not null default false,
  amount numeric not null,
  created_at timestamptz not null default now()
);

-- ------------------------------------------------------------
-- 2. updated_at OTOMATİK GÜNCELLEME (customers için)
-- ------------------------------------------------------------

create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_updated_at on customers;
create trigger set_updated_at
  before update on customers
  for each row
  execute function update_updated_at();

-- ------------------------------------------------------------
-- 3. ROW LEVEL SECURITY (RLS) AKTİF ETME
-- ------------------------------------------------------------

alter table customers enable row level security;
alter table notes enable row level security;
alter table products enable row level security;
alter table purchases enable row level security;

-- ------------------------------------------------------------
-- 4. POLICY'LER — her kullanıcı yalnızca kendi verisine erişebilir
-- ------------------------------------------------------------

-- customers
create policy "Users can view own customers"
  on customers for select
  using (auth.uid() = user_id);

create policy "Users can insert own customers"
  on customers for insert
  with check (auth.uid() = user_id);

create policy "Users can update own customers"
  on customers for update
  using (auth.uid() = user_id);

create policy "Users can delete own customers"
  on customers for delete
  using (auth.uid() = user_id);

-- notes
create policy "Users can view own notes"
  on notes for select
  using (auth.uid() = user_id);

create policy "Users can insert own notes"
  on notes for insert
  with check (auth.uid() = user_id);

create policy "Users can update own notes"
  on notes for update
  using (auth.uid() = user_id);

create policy "Users can delete own notes"
  on notes for delete
  using (auth.uid() = user_id);

-- products
create policy "Users can view own products"
  on products for select
  using (auth.uid() = user_id);

create policy "Users can insert own products"
  on products for insert
  with check (auth.uid() = user_id);

create policy "Users can update own products"
  on products for update
  using (auth.uid() = user_id);

create policy "Users can delete own products"
  on products for delete
  using (auth.uid() = user_id);

-- purchases
create policy "Users can view own purchases"
  on purchases for select
  using (auth.uid() = user_id);

create policy "Users can insert own purchases"
  on purchases for insert
  with check (auth.uid() = user_id);

create policy "Users can update own purchases"
  on purchases for update
  using (auth.uid() = user_id);

create policy "Users can delete own purchases"
  on purchases for delete
  using (auth.uid() = user_id);
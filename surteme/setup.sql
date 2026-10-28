-- Surteme: preparar la base de datos.
-- Copia TODO este texto, pégalo en Supabase > SQL Editor y pulsa "Run".

create table if not exists clientes (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  nombre text not null,
  rnc text,
  telefono text,
  correo text,
  direccion text,
  notas text
);

create table if not exists facturas (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  cliente_id uuid references clientes(id) on delete cascade,
  numero text,
  fecha date not null default current_date,
  monto numeric not null default 0,
  costo numeric,
  estado text not null default 'pendiente',
  notas text,
  archivo text
);

-- Solo las personas con usuario y contraseña pueden ver o cambiar datos.
alter table clientes enable row level security;
alter table facturas enable row level security;

drop policy if exists "usuarios_clientes" on clientes;
create policy "usuarios_clientes" on clientes
  for all to authenticated using (true) with check (true);

drop policy if exists "usuarios_facturas" on facturas;
create policy "usuarios_facturas" on facturas
  for all to authenticated using (true) with check (true);

-- Carpeta privada para los archivos de las facturas (PDF o fotos).
insert into storage.buckets (id, name, public)
values ('facturas', 'facturas', false)
on conflict (id) do nothing;

drop policy if exists "usuarios_archivos" on storage.objects;
create policy "usuarios_archivos" on storage.objects
  for all to authenticated
  using (bucket_id = 'facturas')
  with check (bucket_id = 'facturas');

-- ===== Suplidores y precios (agregado después) =====
create table if not exists proveedores (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  nombre text not null,
  incluye_itbis boolean not null default true,
  contacto text, telefono text, notas text
);
create table if not exists precios (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  actualizado timestamptz not null default now(),
  proveedor_id uuid not null references proveedores(id) on delete cascade,
  categoria text, producto text not null, referencia text, descripcion text,
  presentacion text, unidades numeric, precio numeric,
  asumida boolean not null default false, fuente text, notas text
);
alter table proveedores enable row level security;
alter table precios enable row level security;
drop policy if exists "usuarios_proveedores" on proveedores;
create policy "usuarios_proveedores" on proveedores for all to authenticated using (true) with check (true);
drop policy if exists "usuarios_precios" on precios;
create policy "usuarios_precios" on precios for all to authenticated using (true) with check (true);
grant select, insert, update, delete on proveedores, precios to authenticated;

-- ===== Gastos (agregado después) =====
create table if not exists gastos (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  fecha date not null default current_date,
  categoria text not null default 'Otros',
  descripcion text,
  monto numeric not null default 0,
  galones numeric, precio_galon numeric, km numeric, vehiculo text,
  archivo text, notas text
);
alter table gastos enable row level security;
drop policy if exists "usuarios_gastos" on gastos;
create policy "usuarios_gastos" on gastos for all to authenticated using (true) with check (true);
grant select, insert, update, delete on gastos to authenticated;

-- ===== Abonos (pagos parciales de facturas) =====
create table if not exists abonos (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  factura_id uuid not null references facturas(id) on delete cascade,
  fecha date not null default current_date,
  monto numeric not null default 0,
  metodo text,
  archivo text,
  notas text
);
alter table abonos enable row level security;
drop policy if exists "usuarios_abonos" on abonos;
create policy "usuarios_abonos" on abonos for all to authenticated using (true) with check (true);
grant select, insert, update, delete on abonos to authenticated;

-- ===== Cotizaciones y facturas con diseño + datos de la empresa =====
create table if not exists documentos (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  tipo text not null default 'cotizacion',
  numero text,
  fecha date not null default current_date,
  cliente_id uuid references clientes(id) on delete set null,
  cliente_nombre text, cliente_rnc text,
  condiciones text, validez text, ncf text,
  items jsonb not null default '[]',
  itbis boolean not null default false,
  subtotal numeric not null default 0,
  itbis_monto numeric not null default 0,
  total numeric not null default 0,
  costo numeric,
  notas text,
  estado text not null default 'pendiente',
  factura_id uuid references facturas(id) on delete set null,
  origen_id uuid references documentos(id) on delete set null
);
create table if not exists ajustes (
  clave text primary key,
  valor jsonb,
  actualizado timestamptz not null default now()
);
alter table documentos enable row level security;
alter table ajustes enable row level security;
drop policy if exists "usuarios_documentos" on documentos;
create policy "usuarios_documentos" on documentos for all to authenticated using (true) with check (true);
drop policy if exists "usuarios_ajustes" on ajustes;
create policy "usuarios_ajustes" on ajustes for all to authenticated using (true) with check (true);
grant select, insert, update, delete on documentos, ajustes to authenticated;

-- ===== Ventas del día =====
create table if not exists ventas (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  fecha date not null default current_date,
  monto numeric not null default 0,
  costo numeric,
  descripcion text,
  metodo text,
  cliente_id uuid references clientes(id) on delete set null,
  notas text
);
alter table ventas enable row level security;
drop policy if exists "usuarios_ventas" on ventas;
create policy "usuarios_ventas" on ventas for all to authenticated using (true) with check (true);
grant select, insert, update, delete on ventas to authenticated;

-- ===== Arreglos (octubre 2026) =====
-- Clientes archivados (en vez de borrarlos con todo su historial)
alter table clientes add column if not exists archivado boolean not null default false;
-- Que no se repita el número de una cotización o factura
create unique index if not exists documentos_tipo_numero_uq on documentos (tipo, numero) where numero is not null;
-- Índices para que siga rápida al crecer
create index if not exists abonos_factura_id_idx on abonos (factura_id);
create index if not exists facturas_cliente_id_idx on facturas (cliente_id);
create index if not exists precios_proveedor_id_idx on precios (proveedor_id);
create index if not exists documentos_cliente_id_idx on documentos (cliente_id);
create index if not exists documentos_factura_id_idx on documentos (factura_id);
create index if not exists documentos_origen_id_idx on documentos (origen_id);
create index if not exists ventas_cliente_id_idx on ventas (cliente_id);
create index if not exists ventas_fecha_idx on ventas (fecha);
create index if not exists gastos_fecha_idx on gastos (fecha);
-- Avisar al otro teléfono cuando algo cambia (tiempo real)
do $$
declare t text;
begin
  foreach t in array array['clientes','facturas','abonos','documentos','ventas','gastos','proveedores','precios','ajustes'] loop
    if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;

-- ===== Inventario =====
create table if not exists inventario (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  nombre text not null,
  unidad text,
  stock numeric not null default 0,
  minimo numeric not null default 0,
  costo numeric,
  precio numeric,
  notas text
);
create table if not exists inventario_mov (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  producto_id uuid not null references inventario(id) on delete cascade,
  cantidad numeric not null,
  motivo text not null default 'ajuste',
  ref_id uuid,
  nota text
);
create index if not exists inventario_mov_producto_idx on inventario_mov (producto_id);
create index if not exists inventario_mov_ref_idx on inventario_mov (ref_id);
create or replace function inventario_mov_stock() returns trigger
language plpgsql set search_path = public as $$
begin
  if tg_op = 'INSERT' then
    update inventario set stock = stock + new.cantidad where id = new.producto_id;
  elsif tg_op = 'DELETE' then
    update inventario set stock = stock - old.cantidad where id = old.producto_id;
  end if;
  return null;
end $$;
do $$ begin
  if not exists (select 1 from pg_trigger where tgname = 'inventario_mov_stock_tr') then
    create trigger inventario_mov_stock_tr after insert or delete on inventario_mov
      for each row execute function inventario_mov_stock();
  end if;
end $$;
alter table inventario enable row level security;
alter table inventario_mov enable row level security;
do $$ begin
  if not exists (select 1 from pg_policies where policyname = 'usuarios_inventario') then
    create policy "usuarios_inventario" on inventario for all to authenticated using (true) with check (true);
  end if;
  if not exists (select 1 from pg_policies where policyname = 'usuarios_inventario_mov') then
    create policy "usuarios_inventario_mov" on inventario_mov for all to authenticated using (true) with check (true);
  end if;
end $$;
grant select, insert, update, delete on inventario, inventario_mov to authenticated;

-- ===== Empaques del inventario y compras =====
alter table inventario add column if not exists empaque text;
alter table inventario add column if not exists paquetes numeric;
alter table inventario add column if not exists unidades numeric;
alter table inventario add column if not exists precio_paquete numeric;
alter table inventario add column if not exists precio_unidad numeric;
alter table inventario add column if not exists ganancia numeric;
create table if not exists compras (
  id uuid primary key default gen_random_uuid(),
  creado timestamptz not null default now(),
  fecha date not null default current_date,
  proveedor_id uuid references proveedores(id) on delete set null,
  proveedor_nombre text,
  numero text,
  items jsonb not null default '[]',
  total numeric not null default 0,
  pagada boolean not null default false,
  archivo text,
  notas text
);
create index if not exists compras_fecha_idx on compras (fecha);
create index if not exists compras_proveedor_idx on compras (proveedor_id);
alter table compras enable row level security;
do $$ begin
  if not exists (select 1 from pg_policies where policyname = 'usuarios_compras') then
    create policy "usuarios_compras" on compras for all to authenticated using (true) with check (true);
  end if;
end $$;
grant select, insert, update, delete on compras to authenticated;

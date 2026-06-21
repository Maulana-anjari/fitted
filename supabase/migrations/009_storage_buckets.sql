-- 009_storage_buckets.sql
-- Define storage buckets and their RLS policies as code.
-- Previously these existed only as documentation comments in 008_rls_policies.sql
-- and had to be created manually in the dashboard. This makes provisioning
-- reproducible and idempotent.

-- ---------------------------------------------------------------------------
-- Buckets (all private + user-scoped)
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values
  ('avatars', 'avatars', false),
  ('wardrobe-originals', 'wardrobe-originals', false),
  ('wardrobe-processed', 'wardrobe-processed', false),
  ('fit-thumbnails', 'fit-thumbnails', false),
  ('fit-preview', 'fit-preview', false)
on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- Helper: a user "owns" a storage object when the first path segment
-- (the folder name) equals their auth.uid(). Convention: objects are stored
-- as `<user_id>/<item_id>/<filename>`.
-- ---------------------------------------------------------------------------

-- avatars
create policy "avatars: users insert own"
  on storage.objects for insert
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "avatars: users read own"
  on storage.objects for select
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "avatars: users update own"
  on storage.objects for update
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "avatars: users delete own"
  on storage.objects for delete
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

-- wardrobe-originals
create policy "wardrobe-originals: users insert own"
  on storage.objects for insert
  with check (bucket_id = 'wardrobe-originals' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "wardrobe-originals: users read own"
  on storage.objects for select
  using (bucket_id = 'wardrobe-originals' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "wardrobe-originals: users update own"
  on storage.objects for update
  using (bucket_id = 'wardrobe-originals' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'wardrobe-originals' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "wardrobe-originals: users delete own"
  on storage.objects for delete
  using (bucket_id = 'wardrobe-originals' and (storage.foldername(name))[1] = auth.uid()::text);

-- wardrobe-processed
create policy "wardrobe-processed: users insert own"
  on storage.objects for insert
  with check (bucket_id = 'wardrobe-processed' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "wardrobe-processed: users read own"
  on storage.objects for select
  using (bucket_id = 'wardrobe-processed' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "wardrobe-processed: users update own"
  on storage.objects for update
  using (bucket_id = 'wardrobe-processed' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'wardrobe-processed' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "wardrobe-processed: users delete own"
  on storage.objects for delete
  using (bucket_id = 'wardrobe-processed' and (storage.foldername(name))[1] = auth.uid()::text);

-- fit-thumbnails
create policy "fit-thumbnails: users insert own"
  on storage.objects for insert
  with check (bucket_id = 'fit-thumbnails' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fit-thumbnails: users read own"
  on storage.objects for select
  using (bucket_id = 'fit-thumbnails' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fit-thumbnails: users delete own"
  on storage.objects for delete
  using (bucket_id = 'fit-thumbnails' and (storage.foldername(name))[1] = auth.uid()::text);

-- fit-preview
create policy "fit-preview: users insert own"
  on storage.objects for insert
  with check (bucket_id = 'fit-preview' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fit-preview: users read own"
  on storage.objects for select
  using (bucket_id = 'fit-preview' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "fit-preview: users delete own"
  on storage.objects for delete
  using (bucket_id = 'fit-preview' and (storage.foldername(name))[1] = auth.uid()::text);

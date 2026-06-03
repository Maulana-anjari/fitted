-- 008_rls_policies.sql
-- RLS rollup and additional policies for all tables
-- Each migration already includes basic RLS; this adds cross-table and storage policies.

-- Storage RLS policies
-- Note: These are typically configured via Supabase dashboard
-- Included here as documentation of the expected policies.

-- Buckets:
-- avatars          — private, user-scoped
-- wardrobe-originals  — private, user-scoped
-- wardrobe-processed  — private, user-scoped
-- fit-thumbnails  — private, user-scoped
-- fit-preview     — private, user-scoped

-- Storage policy pattern (apply to each bucket):
-- CREATE POLICY "Users can upload own <bucket>"
--   ON storage.objects FOR INSERT
--   WITH CHECK (bucket_id = '<bucket>' AND (storage.foldername(name))[1] = auth.uid()::text);
--
-- CREATE POLICY "Users can read own <bucket>"
--   ON storage.objects FOR SELECT
--   USING (bucket_id = '<bucket>' AND (storage.foldername(name))[1] = auth.uid()::text);
--
-- CREATE POLICY "Users can delete own <bucket>"
--   ON storage.objects FOR DELETE
--   USING (bucket_id = '<bucket>' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Wear tracking function: increment wear_count when a wear event is inserted
CREATE OR REPLACE FUNCTION public.increment_wear_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.wardrobe_items
  SET wear_count = wear_count + 1,
      last_worn_at = NEW.worn_at,
      updated_at = now()
  WHERE id = NEW.wardrobe_item_id AND user_id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_wear_history_insert
  AFTER INSERT ON public.wear_history
  FOR EACH ROW EXECUTE FUNCTION public.increment_wear_count();

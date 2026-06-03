-- 003_fits.sql
-- Stores saved Fits (outfits)

CREATE TABLE IF NOT EXISTS public.fits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  name TEXT,
  thumbnail_url TEXT,
  occasion TEXT,
  season TEXT,
  is_favorite BOOLEAN NOT NULL DEFAULT false,
  is_archived BOOLEAN NOT NULL DEFAULT false,
  ai_recommendation_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_fits_user_id ON public.fits(user_id);

ALTER TABLE public.fits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own fits"
  ON public.fits FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own fits"
  ON public.fits FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own fits"
  ON public.fits FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own fits"
  ON public.fits FOR DELETE USING (auth.uid() = user_id);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.fits
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

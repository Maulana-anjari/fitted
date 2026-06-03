-- 005_planned_fits.sql
-- Calendar scheduling for Fits

CREATE TABLE IF NOT EXISTS public.planned_fits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  fit_id UUID REFERENCES public.fits(id) ON DELETE SET NULL,
  planned_date DATE NOT NULL,
  occasion TEXT,
  notes TEXT,
  weather_temp REAL,
  weather_condition TEXT,
  is_worn BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_planned_fits_user_date ON public.planned_fits(user_id, planned_date);

ALTER TABLE public.planned_fits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own planned fits"
  ON public.planned_fits FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own planned fits"
  ON public.planned_fits FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own planned fits"
  ON public.planned_fits FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own planned fits"
  ON public.planned_fits FOR DELETE USING (auth.uid() = user_id);

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.planned_fits
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

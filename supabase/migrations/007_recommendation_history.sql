-- 007_recommendation_history.sql
-- Tracks AI recommendations for learning user preferences

CREATE TABLE IF NOT EXISTS public.recommendation_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  fit_id UUID REFERENCES public.fits(id) ON DELETE SET NULL,
  recommendation_type TEXT NOT NULL DEFAULT 'daily',
  model_provider TEXT,
  model_version TEXT,
  confidence_score REAL,
  is_accepted BOOLEAN,
  is_rejected BOOLEAN,
  context JSONB,
  response JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_recommendation_user ON public.recommendation_history(user_id, created_at DESC);

ALTER TABLE public.recommendation_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own recommendations"
  ON public.recommendation_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own recommendations"
  ON public.recommendation_history FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own recommendations"
  ON public.recommendation_history FOR UPDATE USING (auth.uid() = user_id);

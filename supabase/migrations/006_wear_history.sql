-- 006_wear_history.sql
-- Tracks actual wear events for analytics and recommendations

CREATE TABLE IF NOT EXISTS public.wear_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  wardrobe_item_id UUID NOT NULL REFERENCES public.wardrobe_items(id) ON DELETE CASCADE,
  fit_id UUID REFERENCES public.fits(id) ON DELETE SET NULL,
  worn_at DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_wear_history_user_worn ON public.wear_history(user_id, worn_at);
CREATE INDEX idx_wear_history_item ON public.wear_history(wardrobe_item_id);

ALTER TABLE public.wear_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own wear history"
  ON public.wear_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own wear history"
  ON public.wear_history FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own wear history"
  ON public.wear_history FOR DELETE USING (auth.uid() = user_id);

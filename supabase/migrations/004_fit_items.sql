-- 004_fit_items.sql
-- Junction table: Fit <-> Wardrobe Item with layer ordering

CREATE TABLE IF NOT EXISTS public.fit_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fit_id UUID NOT NULL REFERENCES public.fits(id) ON DELETE CASCADE,
  wardrobe_item_id UUID NOT NULL REFERENCES public.wardrobe_items(id) ON DELETE CASCADE,
  layer_order INTEGER NOT NULL DEFAULT 0,
  position_x DOUBLE PRECISION,
  position_y DOUBLE PRECISION,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_fit_items_fit_id ON public.fit_items(fit_id);
CREATE INDEX idx_fit_items_wardrobe_item_id ON public.fit_items(wardrobe_item_id);

ALTER TABLE public.fit_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own fit items"
  ON public.fit_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fits
      WHERE fits.id = fit_items.fit_id AND fits.user_id = auth.uid()
    )
  );
CREATE POLICY "Users can insert own fit items"
  ON public.fit_items FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.fits
      WHERE fits.id = fit_items.fit_id AND fits.user_id = auth.uid()
    )
  );
CREATE POLICY "Users can update own fit items"
  ON public.fit_items FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.fits
      WHERE fits.id = fit_items.fit_id AND fits.user_id = auth.uid()
    )
  );
CREATE POLICY "Users can delete own fit items"
  ON public.fit_items FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.fits
      WHERE fits.id = fit_items.fit_id AND fits.user_id = auth.uid()
    )
  );

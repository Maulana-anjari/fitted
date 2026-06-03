-- 002_wardrobe_items.sql
-- Stores digitized wardrobe items with AI metadata

CREATE TABLE IF NOT EXISTS public.wardrobe_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  original_image_url TEXT,
  processed_image_url TEXT,
  category TEXT NOT NULL DEFAULT 'top',
  color TEXT,
  material TEXT,
  season TEXT[],
  formality TEXT,
  style_tags TEXT[] DEFAULT '{}',
  wear_count INTEGER NOT NULL DEFAULT 0,
  last_worn_at TIMESTAMPTZ,
  is_favorite BOOLEAN NOT NULL DEFAULT false,
  is_archived BOOLEAN NOT NULL DEFAULT false,
  ai_metadata JSONB,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX idx_wardrobe_items_user_id ON public.wardrobe_items(user_id);
CREATE INDEX idx_wardrobe_items_category ON public.wardrobe_items(user_id, category);
CREATE INDEX idx_wardrobe_items_archived ON public.wardrobe_items(user_id, is_archived);
CREATE INDEX idx_wardrobe_items_ai_metadata ON public.wardrobe_items USING GIN (ai_metadata);

-- Enable RLS
ALTER TABLE public.wardrobe_items ENABLE ROW LEVEL SECURITY;

-- Users can read their own items
CREATE POLICY "Users can view own wardrobe items"
  ON public.wardrobe_items FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own items
CREATE POLICY "Users can insert own wardrobe items"
  ON public.wardrobe_items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own items
CREATE POLICY "Users can update own wardrobe items"
  ON public.wardrobe_items FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own items
CREATE POLICY "Users can delete own wardrobe items"
  ON public.wardrobe_items FOR DELETE
  USING (auth.uid() = user_id);

-- Auto-update updated_at
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.wardrobe_items
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

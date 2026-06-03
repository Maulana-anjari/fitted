// Edge Function: smart-fit
// Generates AI-powered Fit recommendations based on wardrobe, weather, and preferences.
// Phase 3

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;

serve(async (req: Request) => {
  try {
    const { wardrobeItems, weather, preferences, occasion, limit = 3 } = await req.json();

    if (!wardrobeItems || !Array.isArray(wardrobeItems)) {
      return new Response(
        JSON.stringify({ error: 'wardrobeItems is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: `You are a personal AI stylist. Given a wardrobe, generate Fit recommendations.
Each recommendation must include:
- fit_name: a short name for the Fit
- items: array of wardrobe item IDs to combine
- reason: natural explanation of WHY this combination works
- occasion: what this Fit is suitable for
- confidence: 0-1 score

Rules:
- Never recommend a top without a bottom (or dress replacing both)
- Consider weather if provided
- Consider user preferences if provided
- Explain every recommendation in helpful, human language
- Never just output scores without explanation`,
          },
          {
            role: 'user',
            content: JSON.stringify({
              wardrobe: wardrobeItems.map((i: any) => ({
                id: i.id,
                category: i.category,
                color: i.color,
                season: i.season,
                formality: i.formality,
                style_tags: i.styleTags || i.style_tags,
              })),
              weather,
              preferences,
              occasion,
              count: limit,
            }),
          },
        ],
        max_tokens: 2000,
        temperature: 0.7,
        response_format: { type: 'json_object' },
      }),
    });

    const data = await response.json();
    const content = data.choices?.[0]?.message?.content;
    if (!content) throw new Error('No response from OpenAI');

    return new Response(
      JSON.stringify(JSON.parse(content)),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('smart-fit error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

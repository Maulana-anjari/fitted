// Edge Function: analyze-clothing
// Triggered after wardrobe image upload. Uses GPT-4o Vision to categorize clothing.

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!;

serve(async (req: Request) => {
  try {
    const { imageUrl, userId } = await req.json();

    if (!imageUrl || !userId) {
      return new Response(
        JSON.stringify({ error: 'imageUrl and userId are required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Try GPT-4o Vision first, fall back to Gemini
    let result;
    try {
      result = await analyzeWithOpenAI(imageUrl);
    } catch (openAiError) {
      console.error('OpenAI failed, falling back to Gemini:', openAiError);
      result = await analyzeWithGemini(imageUrl);
    }

    return new Response(
      JSON.stringify(result),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('analyze-clothing error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

async function analyzeWithOpenAI(imageUrl: string) {
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
          content: `You are a fashion AI that analyzes clothing items. Return JSON with:
- category: "top" | "bottom" | "outerwear" | "footwear" | "accessory" | "dress" | "bag"
- color: primary color name
- material: fabric/material
- season: ["summer", "winter", "spring", "fall", "all-season"]
- formality: "casual" | "smart-casual" | "business" | "formal"
- style_tags: array of style descriptors (e.g., ["minimal", "vintage", "streetwear"])
- confidence: 0-1 score`,
        },
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: 'Analyze this clothing item and return the structured data.',
            },
            {
              type: 'image_url',
              image_url: { url: imageUrl },
            },
          ],
        },
      ],
      max_tokens: 500,
      temperature: 0.2,
      response_format: { type: 'json_object' },
    }),
  });

  const data = await response.json();
  const content = data.choices?.[0]?.message?.content;
  if (!content) throw new Error('No response from OpenAI');

  return JSON.parse(content);
}

async function analyzeWithGemini(imageUrl: string) {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              {
                text: `Analyze this clothing item. Return JSON:
{
  "category": "top" | "bottom" | "outerwear" | "footwear" | "accessory" | "dress" | "bag",
  "color": "primary color name",
  "material": "fabric",
  "season": ["summer", "winter", "spring", "fall"],
  "formality": "casual" | "smart-casual" | "business" | "formal",
  "style_tags": ["tag1", "tag2"],
  "confidence": 0.8
}`,
              },
              { inlineData: { mimeType: 'image/jpeg', dataUri: imageUrl } },
            ],
          },
        ],
      }),
    }
  );

  const data = await response.json();
  const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) throw new Error('No response from Gemini');

  // Extract JSON from text (Gemini sometimes wraps in markdown)
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (!jsonMatch) throw new Error('No JSON in Gemini response');
  return JSON.parse(jsonMatch[0]);
}

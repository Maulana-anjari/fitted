// Edge Function: remove-background
// Uses RMBG API to remove background from clothing photos.

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const RMBG_API_KEY = Deno.env.get('RMBG_API_KEY')!;

serve(async (req: Request) => {
  try {
    const { imageUrl } = await req.json();

    if (!imageUrl) {
      return new Response(
        JSON.stringify({ error: 'imageUrl is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Download the original image
    const imageResponse = await fetch(imageUrl);
    const imageBlob = await imageResponse.blob();

    // Call RMBG API
    const formData = new FormData();
    formData.append('image_file', imageBlob, 'clothing.jpg');

    const rmbgResponse = await fetch('https://api.remove.bg/v1.0/removebg', {
      method: 'POST',
      headers: {
        'X-Api-Key': RMBG_API_KEY,
      },
      body: formData,
    });

    if (!rmbgResponse.ok) {
      const errorData = await rmbgResponse.json();
      throw new Error(errorData.errors?.[0]?.title || 'RMBG API failed');
    }

    // Get the processed image as ArrayBuffer and convert to base64
    const processedBuffer = await rmbgResponse.arrayBuffer();
    const uint8Array = new Uint8Array(processedBuffer);
    const base64 = btoa(String.fromCharCode(...uint8Array));

    return new Response(
      JSON.stringify({
        processedImageBase64: `data:image/png;base64,${base64}`,
      }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('remove-background error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

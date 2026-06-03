// Edge Function: fit-check
// Conversational AI style assistant with wardrobe context.
// Phase 3

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;

serve(async (req: Request) => {
  try {
    const { messages, wardrobeContext, userPreferences } = await req.json();

    if (!messages || !Array.isArray(messages)) {
      return new Response(
        JSON.stringify({ error: 'messages array is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const systemMessage = {
      role: 'system',
      content: `You are Fit Check, the AI style assistant for Fitted — a wardrobe intelligence app.
You help users decide what to wear, give style advice, and answer fashion questions.

${wardrobeContext ? `USER'S WARDROBE CONTEXT:\n${JSON.stringify(wardrobeContext)}\n` : ''}
${userPreferences ? `USER PREFERENCES:\n${JSON.stringify(userPreferences)}\n` : ''}

Guidelines:
- Be helpful, conversational, and human — never robotic
- If recommending specific items, reference them by name/category
- Explain your reasoning — never just say "this looks good"
- If the user's wardrobe has gaps, suggest what they might add
- Keep responses concise but informative
- Never use terms like "confidence score" or "algorithm" — use natural language`,
    };

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'gpt-4o',
        messages: [systemMessage, ...messages],
        max_tokens: 1000,
        temperature: 0.8,
      }),
    });

    const data = await response.json();
    const content = data.choices?.[0]?.message?.content;
    if (!content) throw new Error('No response from OpenAI');

    return new Response(
      JSON.stringify({ reply: content }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('fit-check error:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

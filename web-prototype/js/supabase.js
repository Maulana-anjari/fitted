// Supabase client initialization
const SUPABASE_URL = 'https://tltzaslwhualoctbkdgw.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_y16tEeN0n9-lnyAkvagdrw_2UxShzD6';

const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export { supabase };

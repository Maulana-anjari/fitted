// Supabase client initialization
const SUPABASE_URL = 'https://tltzaslwhualoctbkdgw.supabase.co';
const SUPABASE_ANON_KEY = 'REMOVED';

const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export { supabase };

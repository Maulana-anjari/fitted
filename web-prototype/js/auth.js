import { supabase } from './supabase.js';

const DEMO_USER = {
  id: 'demo-user-0000-0000-0000-000000000001',
  email: 'alex@fitted.app',
  name: 'Alex',
  avatar_url: null,
  created_at: '2025-01-01T00:00:00Z',
};

let currentUser = null;

// Check existing session on load
export async function initAuth() {
  const { data } = await supabase.auth.getSession();
  if (data.session) {
    currentUser = data.session.user;
  }
  return currentUser;
}

export function getCurrentUser() {
  return currentUser || (isDemoMode() ? DEMO_USER : null);
}

export function isDemoMode() {
  return localStorage.getItem('demo_mode') === 'true';
}

export function isLoggedIn() {
  return !!getCurrentUser();
}

export async function signInAsDemo() {
  localStorage.setItem('demo_mode', 'true');
  currentUser = DEMO_USER;
  return DEMO_USER;
}

export async function signInWithEmail(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw error;
  currentUser = data.user;
  return data.user;
}

export async function signUpWithEmail(email, password, name) {
  const { data, error } = await supabase.auth.signUp({
    email, password,
    options: { data: { name } }
  });
  if (error) throw error;
  currentUser = data.user;
  return data.user;
}

export async function signInWithGoogle() {
  const { error } = await supabase.auth.signInWithOAuth({ provider: 'google' });
  if (error) throw error;
}

export async function signOut() {
  localStorage.removeItem('demo_mode');
  if (!isDemoMode()) {
    await supabase.auth.signOut();
  }
  currentUser = null;
}

export { DEMO_USER };

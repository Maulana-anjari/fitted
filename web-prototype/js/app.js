import { initAuth, signInAsDemo, signOut, getCurrentUser, isLoggedIn, isDemoMode, DEMO_USER } from './auth.js';
import { supabase } from './supabase.js';

// ── Unsplash clothing images ──
const UNSPLASH = {
  blazer:    'https://images.unsplash.com/photo-1593030761757-71fae45fa0e1?w=400&h=500&fit=crop',
  whiteshirt:'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=500&fit=crop',
  trousers:  'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400&h=500&fit=crop',
  shoes:     'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=500&fit=crop',
  sweater:   'https://images.unsplash.com/photo-1434389677669-e08b4cda2b89?w=400&h=500&fit=crop',
  denim:     'https://images.unsplash.com/photo-1542272454315-7b4b32c2f0ed?w=400&h=500&fit=crop',
  outfit1:   'https://images.unsplash.com/photo-1487222477891-6a1b9a7b5170?w=800&h=600&fit=crop',
  outfit2:   'https://images.unsplash.com/photo-1556905055-8f358a86ee0b?w=800&h=600&fit=crop',
  outfit3:   'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=800&h=600&fit=crop',
  hero:      'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=800&h=600&fit=crop',
  linen:    'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400&h=500&fit=crop',
};

// ── Router ──
const routes = ['welcome', 'onboarding', 'login', 'signup', 'daily-fit', 'wardrobe', 'fit-planner', 'fit-check', 'profile'];
let currentRoute = 'welcome';
let onboardingStep = 0;

async function navigate(route) {
  if (!routes.includes(route)) route = 'welcome';
  currentRoute = route;
  document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
  const screen = document.getElementById(`screen-${route}`);
  if (screen) screen.classList.add('active');

  // Auth guard
  const authRoutes = ['welcome', 'onboarding', 'login', 'signup'];
  const loggedIn = isLoggedIn();
  if (!loggedIn && !authRoutes.includes(route)) {
    navigate('welcome'); return;
  }
  if (loggedIn && authRoutes.includes(route)) {
    navigate('daily-fit'); return;
  }

  // Render screen content
  switch (route) {
    case 'welcome': renderWelcome(); break;
    case 'onboarding': renderOnboarding(); break;
    case 'login': renderLogin(); break;
    case 'signup': renderSignup(); break;
    case 'daily-fit': renderDailyFit(); break;
    case 'wardrobe': renderWardrobe(); break;
    case 'fit-planner': renderFitPlanner(); break;
    case 'fit-check': renderFitCheck(); break;
    case 'profile': renderProfile(); break;
  }

  // Update nav
  updateNav();
  updateAppBar(route);
}

function toggleTheme() {
  const html = document.documentElement;
  const current = html.getAttribute('data-theme');
  const next = current === 'dark' ? '' : 'dark';
  html.setAttribute('data-theme', next);
  localStorage.setItem('theme', next);
  document.getElementById('theme-icon').textContent = next === 'dark' ? 'light_mode' : 'dark_mode';
}

// ── App Bar ──
function updateAppBar(route) {
  const titleMap = {
    'daily-fit': 'FITTED', 'wardrobe': 'Wardrobe', 'fit-planner': 'Fit Planner',
    'fit-check': 'Fit Check', 'profile': 'Profile',
    'welcome': '', 'onboarding': '', 'login': 'FITTED', 'signup': 'FITTED'
  };
  const show = !['welcome', 'onboarding'].includes(route);
  const bar = document.getElementById('app-bar');
  bar.classList.toggle('hidden', !show);
  document.getElementById('app-bar-title').textContent = titleMap[route] || 'FITTED';

  const backBtn = document.getElementById('btn-back');
  backBtn.classList.toggle('hidden', ['daily-fit', 'wardrobe', 'fit-planner', 'fit-check', 'profile'].includes(route));
  backBtn.onclick = () => {
    if (['login', 'signup'].includes(route)) navigate('welcome');
    else if (route === 'daily-fit') navigate('welcome');
  };
}

// ── Bottom Nav ──
function updateNav() {
  const nav = document.getElementById('bottom-nav');
  const show = isLoggedIn() && !['welcome', 'onboarding', 'login', 'signup'].includes(currentRoute);
  nav.classList.toggle('hidden', !show);

  document.querySelectorAll('.nav-item').forEach(item => {
    item.classList.toggle('active', item.dataset.route === currentRoute);
  });
}

// ── Screen Renderers ──

function renderWelcome() {
  const screen = document.getElementById('screen-welcome');
  screen.innerHTML = `
    <div class="welcome-content fade-up">
      <div class="welcome-logo"><span class="material-icons">checkroom</span></div>
      <h1 class="display" style="color:var(--color-primary);margin-top:var(--space-md)">Fitted</h1>
      <p class="body text-secondary">Find Your Perfect Fit Every Day.</p>
    </div>
    <div class="welcome-buttons fade-up delay-100">
      <button class="btn btn-primary" onclick="app.navigate('onboarding')">Get Started</button>
      <button class="btn btn-secondary" onclick="app.navigate('login')">I have an account</button>
      <button class="btn btn-outline-ai" id="btn-demo">
        <span class="material-icons" style="font-size:18px">science</span>
        <span id="demo-label">Try Demo</span>
      </button>
    </div>
  `;
  document.getElementById('btn-demo').onclick = async () => {
    const btn = document.getElementById('btn-demo');
    btn.disabled = true;
    document.getElementById('demo-label').textContent = 'Loading...';
    await signInAsDemo();
    navigate('daily-fit');
  };
}

function renderOnboarding() {
  const slides = [
    { icon: 'auto_awesome', title: 'AI-Powered Styling', desc: 'Your personal AI stylist learns your taste and recommends the perfect fit every day.' },
    { icon: 'checkroom', title: 'Digitize Your Wardrobe', desc: 'Snap photos of your clothes. Our AI identifies fabric, color, and style automatically.' },
    { icon: 'calendar_today', title: 'Plan Ahead', desc: 'Schedule outfits for the week. Weather-aware recommendations keep you prepared.' },
    { icon: 'chat', title: 'Fit Check', desc: 'Ask your AI stylist anything. Get personalized advice on what to wear.' },
  ];
  const slide = slides[onboardingStep];
  const screen = document.getElementById('screen-onboarding');
  screen.innerHTML = `
    <div class="onboarding-slide fade-up" id="onboarding-slide">
      <div class="onboarding-icon"><span class="material-icons">${slide.icon}</span></div>
      <h2 class="h2">${slide.title}</h2>
      <p class="body text-secondary">${slide.desc}</p>
    </div>
    <div style="padding:var(--space-md);display:flex;flex-direction:column;align-items:center;gap:var(--space-md)">
      <div class="onboarding-dots" id="onboarding-dots">
        ${slides.map((_, i) => `<div class="dot${i === onboardingStep ? ' active' : ''}"></div>`).join('')}
      </div>
      <button class="btn btn-primary" id="btn-onboarding-next">
        ${onboardingStep < slides.length - 1 ? 'Next' : 'Create Your Account'}
      </button>
      <button class="btn btn-secondary" onclick="app.navigate('welcome')">Skip</button>
    </div>
  `;
  document.getElementById('btn-onboarding-next').onclick = () => {
    if (onboardingStep < slides.length - 1) {
      onboardingStep++;
      renderOnboarding();
    } else {
      onboardingStep = 0;
      navigate('signup');
    }
  };
}

function renderLogin() {
  document.getElementById('screen-login').innerHTML = `
    <div style="padding:var(--space-md);display:flex;flex-direction:column;gap:var(--space-md)">
      <div class="fade-up">
        <h2 class="h2">Welcome back</h2>
        <p class="body text-secondary">Sign in to continue to Fitted.</p>
      </div>
      <div class="fade-up delay-100" style="display:flex;flex-direction:column;gap:var(--space-sm)">
        <label class="input-label">Email</label>
        <input class="input" type="email" id="login-email" placeholder="you@example.com" value="demo@fitted.app">
        <label class="input-label">Password</label>
        <input class="input" type="password" id="login-password" placeholder="Enter your password" value="password123">
        <p id="login-error" class="metadata" style="color:var(--color-error);display:none"></p>
      </div>
      <div class="fade-up delay-200" style="display:flex;flex-direction:column;gap:var(--space-sm)">
        <button class="btn btn-primary" id="btn-login">Sign In</button>
        <button class="btn btn-outline-ai" id="btn-login-demo">
          <span class="material-icons" style="font-size:18px">science</span> Try Demo
        </button>
        <button class="btn btn-secondary" onclick="app.navigate('signup')">Create an account</button>
      </div>
      <p class="metadata text-center fade-up delay-300">Hint: use "Try Demo" for instant access</p>
    </div>
  `;
  document.getElementById('btn-login').onclick = async () => {
    const email = document.getElementById('login-email').value;
    const password = document.getElementById('login-password').value;
    const err = document.getElementById('login-error');
    try {
      await signInAsDemo(); // Fall back to demo for prototype
      navigate('daily-fit');
    } catch (e) {
      err.textContent = e.message; err.style.display = 'block';
    }
  };
  document.getElementById('btn-login-demo').onclick = async () => {
    await signInAsDemo();
    navigate('daily-fit');
  };
}

function renderSignup() {
  document.getElementById('screen-signup').innerHTML = `
    <div style="padding:var(--space-md);display:flex;flex-direction:column;gap:var(--space-md)">
      <div class="fade-up">
        <h2 class="h2">Create your account</h2>
        <p class="body text-secondary">Start building your digital wardrobe.</p>
      </div>
      <div class="fade-up delay-100" style="display:flex;flex-direction:column;gap:var(--space-sm)">
        <label class="input-label">Name</label>
        <input class="input" type="text" id="signup-name" placeholder="Alex">
        <label class="input-label">Email</label>
        <input class="input" type="email" id="signup-email" placeholder="you@example.com">
        <label class="input-label">Password</label>
        <input class="input" type="password" id="signup-password" placeholder="Min. 6 characters">
        <p id="signup-error" class="metadata" style="color:var(--color-error);display:none"></p>
      </div>
      <div class="fade-up delay-200" style="display:flex;flex-direction:column;gap:var(--space-sm)">
        <button class="btn btn-primary" id="btn-signup">Sign Up</button>
        <button class="btn btn-outline-ai" id="btn-signup-demo">
          <span class="material-icons" style="font-size:18px">science</span> Try Demo
        </button>
        <button class="btn btn-secondary" onclick="app.navigate('login')">I have an account</button>
      </div>
    </div>
  `;
  document.getElementById('btn-signup').onclick = async () => {
    await signInAsDemo();
    navigate('daily-fit');
  };
  document.getElementById('btn-signup-demo').onclick = async () => {
    await signInAsDemo();
    navigate('daily-fit');
  };
}

function renderDailyFit() {
  const user = getCurrentUser();
  const hour = new Date().getHours();
  const greeting = hour < 12 ? 'Good morning' : hour < 18 ? 'Good afternoon' : 'Good evening';
  const name = user?.name || user?.email?.split('@')[0] || 'there';

  document.getElementById('screen-daily-fit').innerHTML = `
    <!-- Greeting -->
    <div class="fade-up" style="padding:4px 0 12px">
      <h1 style="font-size:28px;font-weight:700;line-height:34px;color:var(--color-text-primary)">${greeting}, ${name}.</h1>
      <p class="body" style="color:var(--color-text-secondary);margin-top:4px">Here is your curated AI recommendation for today.</p>
    </div>

    <!-- Quick Feature Chips -->
    <div class="scroll-x fade-up delay-100" style="padding-bottom:12px">
      <button class="chip chip-active">For You</button>
      <button class="chip">Recent Fits</button>
      <button class="chip">Wardrobe</button>
    </div>

    <!-- Hero Outfit Card -->
    <div class="ai-glow fade-up delay-150" style="border-radius:12px;overflow:hidden;position:relative">
      <img src="${UNSPLASH.hero}" alt="AI Outfit" style="width:100%;height:260px;object-fit:cover" loading="lazy" />
      <div style="position:absolute;top:12px;left:12px;display:flex;align-items:center;gap:6px;padding:6px 14px;border-radius:9999px;background:var(--color-ai);color:#fff;font-size:12px;font-weight:600">
        <span class="material-icons" style="font-size:14px">auto_awesome</span> AI Selected
      </div>
      <div style="padding:16px;background:var(--color-surface)">
        <h3 style="font-size:20px;font-weight:700">Midnight Velvet Ensemble</h3>
        <p style="font-size:14px;color:var(--color-text-secondary);margin-top:4px;line-height:1.5">Charcoal blazer with silk shirt — perfectly calibrated for today's weather and your schedule.</p>
        <div style="display:flex;gap:8px;margin-top:12px">
          <button class="btn btn-primary" style="flex:1">Wear This</button>
          <button class="btn btn-secondary btn-sm" style="min-width:44px"><span class="material-icons">tune</span></button>
        </div>
      </div>
    </div>

    <!-- The Breakdown -->
    <div style="margin-top:24px" class="fade-up delay-200">
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:12px">
        <span class="material-icons" style="font-size:22px;color:var(--color-text-primary)">checkroom</span>
        <h3 class="h3">The Breakdown</h3>
      </div>
      <div style="border-radius:8px;background:var(--color-surface);border:1px solid var(--color-border);overflow:hidden">
        <div style="display:flex;align-items:center;gap:12px;padding:14px 16px;border-bottom:1px solid var(--color-border)">
          <img src="${UNSPLASH.blazer}" alt="Blazer" style="width:44px;height:44px;border-radius:4px;object-fit:cover" loading="lazy" />
          <div style="flex:1"><p style="font-size:12px;color:var(--color-text-tertiary)">Outerwear</p><p style="font-size:15px;font-weight:500">Charcoal Velvet Blazer</p></div>
          <span class="material-icons" style="color:var(--color-text-tertiary)">chevron_right</span>
        </div>
        <div style="display:flex;align-items:center;gap:12px;padding:14px 16px;border-bottom:1px solid var(--color-border)">
          <img src="${UNSPLASH.whiteshirt}" alt="Shirt" style="width:44px;height:44px;border-radius:4px;object-fit:cover" loading="lazy" />
          <div style="flex:1"><p style="font-size:12px;color:var(--color-text-tertiary)">Base</p><p style="font-size:15px;font-weight:500">Obsidian Silk Shirt</p></div>
          <span class="material-icons" style="color:var(--color-text-tertiary)">chevron_right</span>
        </div>
        <div style="display:flex;align-items:center;gap:12px;padding:14px 16px">
          <img src="${UNSPLASH.trousers}" alt="Trousers" style="width:44px;height:44px;border-radius:4px;object-fit:cover" loading="lazy" />
          <div style="flex:1"><p style="font-size:12px;color:var(--color-text-tertiary)">Bottoms</p><p style="font-size:15px;font-weight:500">Tailored Black Trousers</p></div>
          <span class="material-icons" style="color:var(--color-text-tertiary)">chevron_right</span>
        </div>
      </div>
    </div>

    <!-- Context Cards -->
    <div style="margin-top:20px;display:flex;gap:12px" class="fade-up delay-250">
      <div style="flex:1;padding:14px;border-radius:8px;background:var(--color-surface);border:1px solid var(--color-border)">
        <p style="font-size:12px;color:var(--color-text-tertiary);margin-bottom:4px">Weather</p>
        <p style="font-size:28px;font-weight:700">72°</p>
        <p style="font-size:13px;color:var(--color-text-secondary);margin-top:2px">Partly cloudy, light breeze</p>
      </div>
      <div style="flex:1;padding:14px;border-radius:8px;background:var(--color-surface);border:1px solid var(--color-border)">
        <p style="font-size:12px;color:var(--color-text-tertiary);margin-bottom:4px">Occasion</p>
        <div style="display:flex;align-items:center;gap:6px;margin-top:4px"><span class="material-icons" style="font-size:28px">work</span></div>
        <p style="font-size:13px;color:var(--color-text-secondary);margin-top:2px">Client Meeting</p>
      </div>
    </div>

    <!-- Wardrobe Insights mini -->
    <div class="glass-panel fade-up delay-300" style="margin-top:20px;padding:16px">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px">
        <div style="display:flex;align-items:center;gap:8px">
          <span class="material-icons" style="color:var(--color-ai)">insights</span>
          <h3 class="h3">Wardrobe Insights</h3>
        </div>
        <span style="color:var(--color-ai);font-size:14px;cursor:pointer">View all →</span>
      </div>
      <div style="display:flex;gap:12px">
        <div style="flex:1;text-align:center;padding:12px 8px;border-radius:4px;background:var(--color-surface-container-low)">
          <p style="font-size:22px;font-weight:700">92<span style="font-size:14px;color:var(--color-text-tertiary)">%</span></p>
          <p style="font-size:11px;color:var(--color-text-tertiary);margin-top:2px">Fit Score</p>
        </div>
        <div style="flex:1;text-align:center;padding:12px 8px;border-radius:4px;background:var(--color-surface-container-low)">
          <p style="font-size:22px;font-weight:700">142</p>
          <p style="font-size:11px;color:var(--color-text-tertiary);margin-top:2px">Items</p>
        </div>
        <div style="flex:1;text-align:center;padding:12px 8px;border-radius:4px;background:var(--color-surface-container-low)">
          <p style="font-size:22px;font-weight:700">28</p>
          <p style="font-size:11px;color:var(--color-text-tertiary);margin-top:2px">Fits</p>
        </div>
        <div style="flex:1;text-align:center;padding:12px 8px;border-radius:4px;background:var(--color-surface-container-low)">
          <p style="font-size:22px;font-weight:700">5</p>
          <p style="font-size:11px;color:var(--color-text-tertiary);margin-top:2px">This Week</p>
        </div>
      </div>
    </div>
  `;
}

function renderWardrobe() {
  document.getElementById('screen-wardrobe').innerHTML = `
    <div class="filter-bar fade-up" id="filter-bar">
      <span class="chip chip-active" data-filter="all">All</span>
      <span class="chip" data-filter="top">Tops</span>
      <span class="chip" data-filter="bottom">Bottoms</span>
      <span class="chip" data-filter="outerwear">Outerwear</span>
      <span class="chip" data-filter="shoes">Shoes</span>
      <span class="chip" data-filter="accessories">Accessories</span>
    </div>
    <div class="wardrobe-grid fade-up delay-100" id="wardrobe-grid">
      ${renderWardrobeItems()}
    </div>
    <div style="padding: var(--space-md) 0">
      <button class="btn btn-outline-ai" onclick="app.showToast('Camera upload coming soon')">
        <span class="material-icons">add_a_photo</span> Add Item
      </button>
    </div>
  `;
  // Filter interaction
  document.querySelectorAll('#filter-bar .chip').forEach(chip => {
    chip.onclick = () => {
      document.querySelectorAll('#filter-bar .chip').forEach(c => c.classList.remove('chip-active'));
      chip.classList.add('chip-active');
    };
  });
}

function renderWardrobeItems() {
  const items = [
    { name: 'Charcoal Velvet Blazer', category: 'Outerwear', color: 'Charcoal', img: UNSPLASH.blazer },
    { name: 'Obsidian Silk Shirt', category: 'Top', color: 'Black', img: UNSPLASH.whiteshirt },
    { name: 'Tailored Black Trousers', category: 'Bottom', color: 'Black', img: UNSPLASH.trousers },
    { name: 'White Oxford Shirt', category: 'Top', color: 'White', img: UNSPLASH.whiteshirt },
    { name: 'Navy Cashmere Sweater', category: 'Top', color: 'Navy', img: UNSPLASH.sweater },
    { name: 'Leather Chelsea Boots', category: 'Shoes', color: 'Brown', img: UNSPLASH.shoes },
    { name: 'Slim Dark Denim', category: 'Bottom', color: 'Indigo', img: UNSPLASH.denim },
    { name: 'Beige Linen Blazer', category: 'Outerwear', color: 'Beige', img: UNSPLASH.linen },
  ];
  return items.map((item, i) => `
    <div class="wardrobe-item fade-up" style="animation-delay:${0.1 + i * 0.05}s">
      <img src="${item.img}" alt="${item.name}" loading="lazy" style="width:100%;aspect-ratio:3/4;object-fit:cover" />
      <div class="wardrobe-item-info">
        <p class="body" style="font-weight:500;font-size:14px">${item.name}</p>
        <p class="metadata">${item.category}  ·  ${item.color}</p>
      </div>
    </div>
  `).join('');
}

function renderFitPlanner() {
  const today = new Date();
  const year = today.getFullYear();
  const month = today.getMonth();
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const firstDay = new Date(year, month, 1).getDay();
  const monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December'];

  let daysHtml = '';
  for (let i = 0; i < firstDay; i++) daysHtml += '<div></div>';
  for (let d = 1; d <= daysInMonth; d++) {
    const isToday = d === today.getDate();
    const hasFit = [5, 12, 18, 25].includes(d); // demo markers
    daysHtml += `<div class="calendar-day${isToday ? ' today' : ''}${hasFit ? ' has-fit' : ''}">${d}</div>`;
  }

  document.getElementById('screen-fit-planner').innerHTML = `
    <div class="calendar-header fade-up">
      <button class="app-bar-btn"><span class="material-icons">chevron_left</span></button>
      <h3 class="h3">${monthNames[month]} ${year}</h3>
      <button class="app-bar-btn"><span class="material-icons">chevron_right</span></button>
    </div>
    <div class="calendar-grid fade-up delay-100">
      ${['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map(d => `<div class="calendar-day-header">${d}</div>`).join('')}
      ${daysHtml}
    </div>
    <div style="margin-top:var(--space-md);" class="fade-up delay-200">
      <h3 class="h3" style="margin-bottom:var(--space-sm)">Planned Fits</h3>
      <div style="display:flex;flex-direction:column;gap:var(--space-sm)">
        <div class="planner-fit-card fade-up delay-300">
          <img src="${UNSPLASH.outfit2}" alt="Business" style="width:64px;height:64px;border-radius:var(--radius-sm);object-fit:cover" loading="lazy" />
          <div style="flex:1"><p class="body" style="font-weight:500">Business Ensemble</p><p class="metadata">Jun 12 · Client Meeting</p></div>
          <span class="material-icons metadata">chevron_right</span>
        </div>
        <div class="planner-fit-card fade-up delay-400">
          <img src="${UNSPLASH.outfit3}" alt="Casual" style="width:64px;height:64px;border-radius:var(--radius-sm);object-fit:cover" loading="lazy" />
          <div style="flex:1"><p class="body" style="font-weight:500">Casual Weekend</p><p class="metadata">Jun 18 · Brunch</p></div>
          <span class="material-icons metadata">chevron_right</span>
        </div>
      </div>
    </div>
  `;
}

function renderFitCheck() {
  document.getElementById('screen-fit-check').innerHTML = `
    <div class="chat-container fade-up" id="chat-messages">
      <div class="chat-bubble ai fade-up delay-100">
        <span class="material-icons" style="color:var(--color-ai)">auto_awesome</span>
        <p style="margin-top:4px">Hi ${getCurrentUser()?.name || 'there'}! I'm your Fit Coach. What would you like help with today?</p>
        <div class="scroll-x" style="margin-top:8px">
          <span class="chip chip-active" style="cursor:pointer" onclick="app.sendChat('What should I wear today?')">Today's outfit</span>
          <span class="chip" style="cursor:pointer" onclick="app.sendChat('Rate this outfit')">Rate my look</span>
          <span class="chip" style="cursor:pointer" onclick="app.sendChat('Formal event help')">Formal event</span>
        </div>
      </div>
    </div>
    <div class="chat-input-bar">
      <input class="input" id="chat-input" placeholder="Ask your Fit Coach..." style="flex:1">
      <button class="btn btn-primary btn-sm" id="btn-chat-send" style="width:44px;min-width:44px">
        <span class="material-icons">send</span>
      </button>
    </div>
  `;
  document.getElementById('btn-chat-send').onclick = () => sendChat();
  document.getElementById('chat-input').onkeydown = (e) => {
    if (e.key === 'Enter') sendChat();
  };
}

function sendChat(prefill) {
  const input = document.getElementById('chat-input');
  const text = prefill || input.value.trim();
  if (!text) return;
  if (!prefill) input.value = '';

  const messages = document.getElementById('chat-messages');
  messages.innerHTML += `<div class="chat-bubble user fade-up">${text}</div>`;

  setTimeout(() => {
    const responses = {
      "today's outfit": "Based on the 72°F weather and your calendar (client meeting at 3pm), I recommend your Midnight Velvet Ensemble — the charcoal blazer with that obsidian silk shirt. Sharp and professional.",
      "rate this look": "I'd give your current ensemble a 92/100. The charcoal-on-black palette is elegant, and the textures create depth. One suggestion: swap the black trousers for a lighter grey to add contrast.",
      "formal event": "For a formal event, I'd suggest your Charcoal Velvet Blazer over a crisp white shirt with tailored trousers and leather Chelsea boots. Would you like me to add this to your Fit Planner?",
    };
    const key = Object.keys(responses).find(k => text.toLowerCase().includes(k));
    const reply = key ? responses[key] : "I understand! Let me analyze your wardrobe and preferences to give you the best recommendation. What kind of event or occasion are you dressing for?";
    messages.innerHTML += `<div class="chat-bubble ai fade-up">
      <span class="material-icons" style="color:var(--color-ai)">auto_awesome</span>
      <p style="margin-top:4px">${reply}</p>
    </div>`;
    messages.scrollTop = messages.scrollHeight;
  }, 800);
  messages.scrollTop = messages.scrollHeight;
}

function renderProfile() {
  const user = getCurrentUser();
  const isDemo = isDemoMode();
  document.getElementById('screen-profile').innerHTML = `
    <div class="profile-header fade-up">
      <div class="profile-avatar flex-center">
        <span class="material-icons" style="font-size:48px;color:var(--color-text-tertiary)">person</span>
      </div>
      <h2 class="h2">${user?.name || 'User'}</h2>
      <p class="body text-secondary">${user?.email || ''}</p>
      ${isDemo ? '<span class="chip" style="margin-top:8px;color:var(--color-ai);border-color:var(--color-ai)">Demo Mode</span>' : ''}
    </div>
    <div style="display:flex;justify-content:space-around;padding:var(--space-sm) 0" class="fade-up delay-100">
      <div class="profile-stat"><div class="profile-stat-value">142</div><div class="profile-stat-label">Items</div></div>
      <div class="profile-stat"><div class="profile-stat-value">28</div><div class="profile-stat-label">Fits</div></div>
      <div class="profile-stat"><div class="profile-stat-value">92%</div><div class="profile-stat-label">Fit Score</div></div>
    </div>
    <div class="card fade-up delay-200" style="margin-top:var(--space-md)">
      <div class="profile-menu-item"><span class="material-icons">person</span><span>Edit Profile</span><span class="spacer"></span><span class="material-icons metadata">chevron_right</span></div>
      <div class="profile-menu-item"><span class="material-icons">palette</span><span>Style Preferences</span><span class="spacer"></span><span class="material-icons metadata">chevron_right</span></div>
      <div class="profile-menu-item"><span class="material-icons">notifications</span><span>Notifications</span><span class="spacer"></span><span class="material-icons metadata">chevron_right</span></div>
      <div class="profile-menu-item"><span class="material-icons">dark_mode</span><span>Dark Mode</span><span class="spacer"></span>
        <label class="switch"><input type="checkbox" id="theme-toggle" ${document.documentElement.getAttribute('data-theme') === 'dark' ? 'checked' : ''}></label>
      </div>
    </div>
    <div class="card fade-up delay-300" style="margin-top:var(--space-md)">
      <div class="profile-menu-item" onclick="app.navigateToFitDNA()"><span class="material-icons">fingerprint</span><span>Fit DNA</span><span class="spacer"></span><span class="material-icons metadata">chevron_right</span></div>
      <div class="profile-menu-item" onclick="app.navigateToInsights()"><span class="material-icons">insights</span><span>Fit Insights</span><span class="spacer"></span><span class="material-icons metadata">chevron_right</span></div>
    </div>
    <div style="padding:var(--space-md) 0">
      <button class="btn btn-danger" onclick="app.handleSignOut()">Sign Out</button>
    </div>
  `;
  document.getElementById('theme-toggle').onchange = (e) => {
    document.documentElement.setAttribute('data-theme', e.target.checked ? 'dark' : '');
    localStorage.setItem('theme', e.target.checked ? 'dark' : '');
  };
}

// ── Utilities ──
function showToast(message) {
  const toast = document.getElementById('toast');
  toast.textContent = message;
  toast.classList.add('show');
  setTimeout(() => toast.classList.remove('show'), 2500);
}

async function handleSignOut() {
  await signOut();
  navigate('welcome');
}

// ── Init ──
async function init() {
  const saved = localStorage.getItem('theme');
  if (saved) document.documentElement.setAttribute('data-theme', saved);

  await initAuth();
  const startRoute = isLoggedIn() ? 'daily-fit' : 'welcome';
  navigate(startRoute);

  // Event listeners
  document.querySelectorAll('.nav-item').forEach(item => {
    item.onclick = () => navigate(item.dataset.route);
  });
  document.getElementById('btn-back').onclick = () => {
    if (['login', 'signup'].includes(currentRoute)) navigate('welcome');
  };
}

// Export for HTML onclick
window.app = { navigate, handleSignOut, showToast, sendChat: (t) => sendChat(t) };

document.addEventListener('DOMContentLoaded', init);

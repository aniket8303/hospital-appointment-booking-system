<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MediBook — Hospital Appointment Booking</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg: #f5f0eb;
      --bg2: #eae3da;
      --ink: #1a1208;
      --ink2: #4a3f2f;
      --accent: #c8402a;
      --accent2: #e8956d;
      --white: #fffdf9;
      --card: #fffdf9;
      --border: #d6c9b8;
      --green: #2d6a4f;
      --green2: #52b788;
    }

    html { scroll-behavior: smooth; }

    body {
      font-family: 'DM Sans', sans-serif;
      background: var(--bg);
      color: var(--ink);
      overflow-x: hidden;
    }

    /* ── NAV ── */
    nav {
      position: fixed; top: 0; left: 0; right: 0; z-index: 100;
      display: flex; align-items: center; justify-content: space-between;
      padding: 1.2rem 5%;
      background: rgba(245,240,235,0.88);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid var(--border);
    }
    .logo {
      font-family: 'Playfair Display', serif;
      font-size: 1.55rem; font-weight: 900;
      color: var(--ink); text-decoration: none;
      letter-spacing: -0.5px;
    }
    .logo span { color: var(--accent); }
    .nav-links { display: flex; gap: 2.2rem; list-style: none; }
    .nav-links a {
      text-decoration: none; color: var(--ink2);
      font-size: 0.9rem; font-weight: 500; letter-spacing: 0.3px;
      transition: color 0.2s;
    }
    .nav-links a:hover { color: var(--accent); }
    .nav-cta {
      background: var(--accent); color: var(--white) !important;
      padding: 0.55rem 1.3rem; border-radius: 50px;
      transition: background 0.2s, transform 0.15s !important;
    }
    .nav-cta:hover { background: #a8321f !important; transform: translateY(-1px); }
    .hamburger { display: none; flex-direction: column; gap: 5px; cursor: pointer; }
    .hamburger span { width: 24px; height: 2px; background: var(--ink); border-radius: 2px; transition: 0.3s; }
    .mobile-menu {
      display: none; position: fixed; top: 65px; left: 0; right: 0;
      background: var(--bg); border-bottom: 1px solid var(--border);
      padding: 1.5rem 5%; flex-direction: column; gap: 1.2rem; z-index: 99;
    }
    .mobile-menu.open { display: flex; }
    .mobile-menu a { text-decoration: none; color: var(--ink2); font-size: 1rem; font-weight: 500; }

    /* ── HERO ── */
    .hero {
      min-height: 100vh;
      padding: 7rem 5% 4rem;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 3rem;
      align-items: center;
      position: relative;
      overflow: hidden;
    }
    .hero::before {
      content: '';
      position: absolute; top: -120px; right: -120px;
      width: 600px; height: 600px;
      background: radial-gradient(circle, rgba(200,64,42,0.12) 0%, transparent 70%);
      border-radius: 50%;
      pointer-events: none;
    }
    .hero::after {
      content: '';
      position: absolute; bottom: -80px; left: -80px;
      width: 400px; height: 400px;
      background: radial-gradient(circle, rgba(45,106,79,0.1) 0%, transparent 70%);
      border-radius: 50%;
      pointer-events: none;
    }

    .hero-text { position: relative; z-index: 1; }
    .hero-badge {
      display: inline-flex; align-items: center; gap: 0.5rem;
      background: var(--white); border: 1px solid var(--border);
      border-radius: 50px; padding: 0.4rem 1rem;
      font-size: 0.8rem; font-weight: 500; color: var(--green);
      margin-bottom: 1.8rem;
      animation: fadeUp 0.6s ease both;
    }
    .hero-badge::before {
      content: ''; width: 8px; height: 8px;
      background: var(--green2); border-radius: 50%;
      animation: pulse 2s infinite;
    }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.4} }

    h1 {
      font-family: 'Playfair Display', serif;
      font-size: clamp(2.8rem, 5vw, 4.5rem);
      font-weight: 900; line-height: 1.08;
      color: var(--ink); letter-spacing: -1.5px;
      animation: fadeUp 0.6s 0.1s ease both;
    }
    h1 em { font-style: italic; color: var(--accent); }

    .hero-sub {
      margin-top: 1.4rem;
      font-size: 1.05rem; color: var(--ink2);
      line-height: 1.7; max-width: 480px;
      animation: fadeUp 0.6s 0.2s ease both;
    }
    .hero-actions {
      margin-top: 2.5rem;
      display: flex; gap: 1rem; flex-wrap: wrap;
      animation: fadeUp 0.6s 0.3s ease both;
    }
    .btn-primary {
      background: var(--accent); color: var(--white);
      padding: 0.9rem 2rem; border-radius: 50px;
      text-decoration: none; font-weight: 600; font-size: 0.95rem;
      transition: transform 0.2s, box-shadow 0.2s, background 0.2s;
      box-shadow: 0 4px 20px rgba(200,64,42,0.3);
    }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(200,64,42,0.4); background: #a8321f; }
    .btn-secondary {
      border: 1.5px solid var(--border); color: var(--ink2);
      padding: 0.9rem 2rem; border-radius: 50px;
      text-decoration: none; font-weight: 500; font-size: 0.95rem;
      background: var(--white);
      transition: border-color 0.2s, color 0.2s, transform 0.2s;
    }
    .btn-secondary:hover { border-color: var(--accent); color: var(--accent); transform: translateY(-2px); }

    .hero-stats {
      display: flex; gap: 2.5rem; margin-top: 3rem;
      animation: fadeUp 0.6s 0.4s ease both;
    }
    .stat-num {
      font-family: 'Playfair Display', serif;
      font-size: 2rem; font-weight: 900; color: var(--ink); line-height: 1;
    }
    .stat-label { font-size: 0.78rem; color: var(--ink2); margin-top: 0.25rem; }

    .hero-visual {
      position: relative; z-index: 1;
      animation: fadeUp 0.7s 0.2s ease both;
    }
    .card-stack { position: relative; height: 480px; }
    .appt-card {
      position: absolute;
      background: var(--card);
      border-radius: 20px;
      padding: 1.6rem;
      box-shadow: 0 8px 40px rgba(26,18,8,0.12);
      border: 1px solid var(--border);
    }
    .card-main { width: 100%; top: 0; left: 0; animation: float 4s ease-in-out infinite; }
    .card-mini { width: 220px; bottom: 20px; right: -10px; animation: float 4s 1s ease-in-out infinite; padding: 1.2rem; }
    .card-tiny { width: 180px; top: 60px; right: 10px; animation: float 4s 2s ease-in-out infinite; padding: 1rem; }
    @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }

    .card-header { display: flex; align-items: center; gap: 0.8rem; margin-bottom: 1.2rem; }
    .doc-avatar {
      width: 48px; height: 48px; border-radius: 50%;
      background: linear-gradient(135deg, var(--accent2), var(--accent));
      display: flex; align-items: center; justify-content: center;
      font-size: 1.3rem; font-weight: 700; color: white;
      font-family: 'Playfair Display', serif;
    }
    .doc-info h4 { font-size: 0.95rem; font-weight: 600; }
    .doc-info p { font-size: 0.78rem; color: var(--ink2); }
    .card-row { display: flex; justify-content: space-between; margin-bottom: 0.8rem; }
    .card-label { font-size: 0.72rem; color: var(--ink2); margin-bottom: 0.2rem; }
    .card-val { font-size: 0.9rem; font-weight: 600; }
    .status-badge { display: inline-block; padding: 0.25rem 0.8rem; border-radius: 50px; font-size: 0.72rem; font-weight: 600; }
    .confirmed { background: #d8f3dc; color: var(--green); }
    .mini-title { font-size: 0.8rem; font-weight: 600; margin-bottom: 0.8rem; color: var(--ink2); }
    .dept-list { display: flex; flex-direction: column; gap: 0.5rem; }
    .dept-item { display: flex; align-items: center; gap: 0.6rem; font-size: 0.82rem; }
    .dept-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
    .tiny-label { font-size: 0.72rem; color: var(--ink2); margin-bottom: 0.4rem; }
    .tiny-num { font-family: 'Playfair Display', serif; font-size: 1.5rem; font-weight: 900; color: var(--accent); }

    /* ── SECTIONS ── */
    section { padding: 6rem 5%; }
    .section-tag {
      display: inline-block;
      font-size: 0.72rem; font-weight: 600; letter-spacing: 2px;
      text-transform: uppercase; color: var(--accent); margin-bottom: 1rem;
    }
    h2 {
      font-family: 'Playfair Display', serif;
      font-size: clamp(2rem, 4vw, 3rem);
      font-weight: 900; line-height: 1.15;
      letter-spacing: -1px; color: var(--ink);
    }
    .section-sub { color: var(--ink2); line-height: 1.7; max-width: 520px; margin-top: 0.8rem; }

    /* ── FEATURES ── */
    .features { background: var(--white); }
    .features-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem; margin-top: 3.5rem;
    }
    .feature-card {
      background: var(--bg); border: 1px solid var(--border);
      border-radius: 18px; padding: 2rem;
      transition: transform 0.25s, box-shadow 0.25s;
      position: relative; overflow: hidden;
    }
    .feature-card::before {
      content: ''; position: absolute; top: 0; left: 0; right: 0;
      height: 3px; background: linear-gradient(90deg, var(--accent), var(--accent2));
      transform: scaleX(0); transform-origin: left; transition: transform 0.3s;
    }
    .feature-card:hover { transform: translateY(-4px); box-shadow: 0 12px 40px rgba(26,18,8,0.1); }
    .feature-card:hover::before { transform: scaleX(1); }
    .feat-icon {
      width: 52px; height: 52px; border-radius: 14px;
      background: var(--white); display: flex; align-items: center; justify-content: center;
      font-size: 1.5rem; margin-bottom: 1.2rem; border: 1px solid var(--border);
    }
    .feature-card h3 { font-size: 1.05rem; font-weight: 600; margin-bottom: 0.6rem; }
    .feature-card p { font-size: 0.87rem; color: var(--ink2); line-height: 1.65; }

    /* ── ROLES ── */
    .roles { background: var(--bg); }
    .roles-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 1.5rem; margin-top: 3.5rem;
    }
    .role-card { border-radius: 20px; padding: 2.2rem; border: 1px solid var(--border); transition: transform 0.25s; }
    .role-card:hover { transform: translateY(-4px); }
    .role-patient { background: linear-gradient(135deg, #fff8f0, #fff3e8); }
    .role-doctor  { background: linear-gradient(135deg, #f0f7f4, #e8f4f0); }
    .role-admin   { background: linear-gradient(135deg, #f5f0ff, #ede8ff); }
    .role-icon { font-size: 2.2rem; margin-bottom: 1rem; }
    .role-card h3 { font-size: 1.2rem; font-weight: 700; margin-bottom: 0.5rem; }
    .role-card > p { font-size: 0.87rem; color: var(--ink2); margin-bottom: 1.2rem; line-height: 1.6; }
    .role-features { list-style: none; display: flex; flex-direction: column; gap: 0.5rem; }
    .role-features li { font-size: 0.85rem; color: var(--ink2); display: flex; align-items: center; gap: 0.5rem; }
    .role-features li::before { content: '→'; color: var(--accent); font-weight: 700; }

    /* ── HOW IT WORKS ── */
    .how { background: var(--white); }
    .steps {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 2rem; margin-top: 3.5rem;
    }
    .step { text-align: center; padding: 2rem 1.5rem; }
    .step-num {
      width: 56px; height: 56px; border-radius: 50%;
      background: var(--accent); color: var(--white);
      font-family: 'Playfair Display', serif;
      font-size: 1.3rem; font-weight: 900;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 1.2rem;
      box-shadow: 0 4px 20px rgba(200,64,42,0.3);
    }
    .step h3 { font-size: 1rem; font-weight: 600; margin-bottom: 0.5rem; }
    .step p { font-size: 0.85rem; color: var(--ink2); line-height: 1.65; }

    /* ── DEPARTMENTS ── */
    .departments { background: var(--bg2); }
    .dept-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
      gap: 1rem; margin-top: 3rem;
    }
    .dept-card {
      background: var(--white); border: 1px solid var(--border);
      border-radius: 16px; padding: 1.5rem 1rem;
      text-align: center;
      transition: transform 0.2s, box-shadow 0.2s; cursor: pointer;
    }
    .dept-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(26,18,8,0.1); }
    .dept-emoji { font-size: 2rem; margin-bottom: 0.7rem; }
    .dept-card h4 { font-size: 0.85rem; font-weight: 600; color: var(--ink); }

    /* ── CTA ── */
    .cta-section {
      background: var(--ink); padding: 6rem 5%;
      text-align: center; position: relative; overflow: hidden;
    }
    .cta-section::before {
      content: '';
      position: absolute; top: -200px; left: 50%; transform: translateX(-50%);
      width: 800px; height: 500px;
      background: radial-gradient(ellipse, rgba(200,64,42,0.2) 0%, transparent 70%);
      pointer-events: none;
    }
    .cta-section h2 { color: var(--white); position: relative; }
    .cta-section h2 em { font-style: italic; color: var(--accent2); }
    .cta-section p { color: rgba(255,255,255,0.6); margin-top: 1rem; position: relative; }
    .cta-btns { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; margin-top: 2.5rem; position: relative; }
    .btn-white {
      background: var(--white); color: var(--ink);
      padding: 0.9rem 2.2rem; border-radius: 50px;
      text-decoration: none; font-weight: 600;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .btn-white:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255,255,255,0.2); }
    .btn-ghost {
      border: 1.5px solid rgba(255,255,255,0.3); color: var(--white);
      padding: 0.9rem 2.2rem; border-radius: 50px;
      text-decoration: none; font-weight: 500;
      transition: border-color 0.2s, transform 0.2s;
    }
    .btn-ghost:hover { border-color: var(--accent2); transform: translateY(-2px); }

    /* ── FOOTER ── */
    footer {
      background: #110d06; color: rgba(255,255,255,0.5);
      padding: 3rem 5% 2rem;
      display: grid;
      grid-template-columns: 2fr 1fr 1fr 1fr;
      gap: 2rem;
    }
    .footer-brand .logo { color: var(--white); }
    .footer-brand p { font-size: 0.85rem; line-height: 1.7; margin-top: 0.8rem; color: rgba(255,255,255,0.4); }
    footer h5 { font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: rgba(255,255,255,0.7); margin-bottom: 1rem; }
    footer ul { list-style: none; display: flex; flex-direction: column; gap: 0.6rem; }
    footer ul a { text-decoration: none; color: rgba(255,255,255,0.45); font-size: 0.85rem; transition: color 0.2s; }
    footer ul a:hover { color: var(--accent2); }
    .footer-bottom {
      background: #110d06; border-top: 1px solid rgba(255,255,255,0.07);
      padding: 1.2rem 5%; text-align: center;
      font-size: 0.8rem; color: rgba(255,255,255,0.3);
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── RESPONSIVE ── */
    @media (max-width: 900px) {
      .hero { grid-template-columns: 1fr; padding-top: 6rem; }
      .card-stack { height: 340px; }
      .card-tiny { display: none; }
      .card-mini { width: 200px; right: 0; bottom: 10px; }
      .hero-stats { gap: 1.8rem; }
      footer { grid-template-columns: 1fr 1fr; }
    }
    @media (max-width: 640px) {
      .nav-links { display: none; }
      .hamburger { display: flex; }
      .hero { gap: 2rem; }
      .hero-stats { flex-wrap: wrap; gap: 1.2rem; }
      .features-grid, .roles-grid { grid-template-columns: 1fr; }
      footer { grid-template-columns: 1fr; }
      .card-mini { display: none; }
      .card-stack { height: auto; }
      .card-main { position: relative; }
      h1 { font-size: 2.4rem; }
    }
  </style>
</head>
<body>

<!-- NAV -->
<nav>
  <a href="#" class="logo">Medi<span>Book</span></a>
  <ul class="nav-links">
    <li><a href="#features">Features</a></li>
    <li><a href="#roles">For You</a></li>
    <li><a href="#how">How It Works</a></li>
    <li><a href="#departments">Departments</a></li>
    <li><a href="${pageContext.request.contextPath}/login" class="nav-cta">Book Now</a></li>
  </ul>
  <div class="hamburger" onclick="toggleMenu()">
    <span></span><span></span><span></span>
  </div>
</nav>

<div class="mobile-menu" id="mobileMenu">
  <a href="#features" onclick="toggleMenu()">Features</a>
  <a href="#roles" onclick="toggleMenu()">For You</a>
  <a href="#how" onclick="toggleMenu()">How It Works</a>
  <a href="#departments" onclick="toggleMenu()">Departments</a>
  <a href="${pageContext.request.contextPath}/login" class="nav-cta" style="width:fit-content">Book Now</a>
</div>

<!-- HERO -->
<section class="hero">
  <div class="hero-text">
    <div class="hero-badge">Now accepting appointments online</div>
    <h1>Your Health,<br/><em>Perfectly</em><br/>Scheduled.</h1>
    <p class="hero-sub">Book appointments with top specialists in seconds. No waiting room, no phone calls — just seamless care when you need it.</p>
    <div class="hero-actions">
      <a href="${pageContext.request.contextPath}/register" class="btn-primary">Book an Appointment →</a>
      <a href="#how" class="btn-secondary">See How It Works</a>
    </div>
    <div class="hero-stats">
      <div>
        <div class="stat-num">50+</div>
        <div class="stat-label">Specialist Doctors</div>
      </div>
      <div>
        <div class="stat-num">12</div>
        <div class="stat-label">Departments</div>
      </div>
      <div>
        <div class="stat-num">98%</div>
        <div class="stat-label">Patient Satisfaction</div>
      </div>
    </div>
  </div>

  <div class="hero-visual">
    <div class="card-stack">
      <div class="appt-card card-main">
        <div class="card-header">
          <div class="doc-avatar">S</div>
          <div class="doc-info">
            <h4>Dr. Sunita Rao</h4>
            <p>Cardiologist · 12 yrs exp.</p>
          </div>
        </div>
        <div class="card-row">
          <div><div class="card-label">Date</div><div class="card-val">April 2, 2026</div></div>
          <div><div class="card-label">Time</div><div class="card-val">10:30 AM</div></div>
        </div>
        <div class="card-row">
          <div><div class="card-label">Token No.</div><div class="card-val">#007</div></div>
          <div><div class="card-label">Status</div><div class="card-val"><span class="status-badge confirmed">Confirmed ✓</span></div></div>
        </div>
        <div style="margin-top:0.5rem">
          <div class="card-label">Reason</div>
          <div class="card-val" style="font-size:0.85rem;font-weight:400;color:var(--ink2);margin-top:0.2rem">Routine cardiac checkup</div>
        </div>
      </div>
      <div class="appt-card card-mini">
        <div class="mini-title">Departments</div>
        <div class="dept-list">
          <div class="dept-item"><span class="dept-dot" style="background:#c8402a"></span>Cardiology</div>
          <div class="dept-item"><span class="dept-dot" style="background:#2d6a4f"></span>Neurology</div>
          <div class="dept-item"><span class="dept-dot" style="background:#6366f1"></span>Orthopedics</div>
          <div class="dept-item"><span class="dept-dot" style="background:#f59e0b"></span>Pediatrics</div>
        </div>
      </div>
      <div class="appt-card card-tiny">
        <div class="tiny-label">Today's Appointments</div>
        <div class="tiny-num">24</div>
        <div style="font-size:0.72rem;color:var(--green);margin-top:0.3rem">↑ 8 from yesterday</div>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section class="features" id="features">
  <div class="section-tag">Why MediBook</div>
  <h2>Everything You Need<br/>for Seamless Care</h2>
  <p class="section-sub">From booking to follow-up, we've built every step to be fast, clear, and stress-free.</p>
  <div class="features-grid">
    <div class="feature-card"><div class="feat-icon">🗓️</div><h3>Instant Booking</h3><p>Pick your department, choose a doctor, select a slot — appointment confirmed in under 60 seconds.</p></div>
    <div class="feature-card"><div class="feat-icon">📋</div><h3>Live Status Tracking</h3><p>Know your appointment status in real time. Pending, Confirmed, Completed — always up to date.</p></div>
    <div class="feature-card"><div class="feat-icon">👨‍⚕️</div><h3>Expert Specialists</h3><p>Browse verified doctors with specializations and experience. Find the right expert for your needs.</p></div>
    <div class="feature-card"><div class="feat-icon">🔒</div><h3>Secure & Private</h3><p>Your medical data stays yours. Role-based access ensures only the right people see the right info.</p></div>
    <div class="feature-card"><div class="feat-icon">📱</div><h3>Works Everywhere</h3><p>Fully responsive design — book from your phone, tablet, or desktop with the same great experience.</p></div>
    <div class="feature-card"><div class="feat-icon">⚡</div><h3>Admin Control</h3><p>Admins manage doctors, departments, and appointments from one powerful, easy-to-use dashboard.</p></div>
  </div>
</section>

<!-- ROLES -->
<section class="roles" id="roles">
  <div class="section-tag">Built For Everyone</div>
  <h2>One Platform,<br/>Three Experiences</h2>
  <p class="section-sub">Whether you're a patient, doctor, or administrator — MediBook is designed with your workflow in mind.</p>
  <div class="roles-grid">
    <div class="role-card role-patient">
      <div class="role-icon">🧑‍⚕️</div>
      <h3>Patients</h3>
      <p>Book, track, and manage your appointments with ease.</p>
      <ul class="role-features">
        <li>Register & login securely</li>
        <li>Browse doctors by department</li>
        <li>Book with date & reason</li>
        <li>View appointment history</li>
        <li>Cancel pending bookings</li>
      </ul>
    </div>
    <div class="role-card role-doctor">
      <div class="role-icon">👨‍⚕️</div>
      <h3>Doctors</h3>
      <p>Manage your schedule and stay on top of patient appointments.</p>
      <ul class="role-features">
        <li>View today's appointments</li>
        <li>Confirm or complete visits</li>
        <li>Cancel when unavailable</li>
        <li>View full history</li>
        <li>Manage your profile</li>
      </ul>
    </div>
    <div class="role-card role-admin">
      <div class="role-icon">🛡️</div>
      <h3>Admins</h3>
      <p>Full control over the hospital system from one dashboard.</p>
      <ul class="role-features">
        <li>Add / remove departments</li>
        <li>Add / remove doctors</li>
        <li>View all appointments</li>
        <li>Update appointment status</li>
        <li>System-wide oversight</li>
      </ul>
    </div>
  </div>
</section>

<!-- HOW IT WORKS -->
<section class="how" id="how">
  <div style="text-align:center">
    <div class="section-tag">Simple Process</div>
    <h2>Book in 4 Easy Steps</h2>
    <p class="section-sub" style="margin:0.8rem auto 0">Getting the care you need has never been this straightforward.</p>
  </div>
  <div class="steps">
    <div class="step"><div class="step-num">1</div><h3>Register / Login</h3><p>Create your patient account in minutes or log in if you're already with us.</p></div>
    <div class="step"><div class="step-num">2</div><h3>Choose Department</h3><p>Browse our departments and find the specialist that suits your medical needs.</p></div>
    <div class="step"><div class="step-num">3</div><h3>Pick a Slot</h3><p>Select an available date and time slot that works for your schedule.</p></div>
    <div class="step"><div class="step-num">4</div><h3>Confirm & Attend</h3><p>Get your token number, track status, and visit your doctor at the appointed time.</p></div>
  </div>
</section>

<!-- DEPARTMENTS -->
<section class="departments" id="departments">
  <div class="section-tag">Specializations</div>
  <h2>Our Departments</h2>
  <p class="section-sub">Specialists across all major medical fields, ready to care for you.</p>
  <div class="dept-grid">
    <div class="dept-card"><div class="dept-emoji">❤️</div><h4>Cardiology</h4></div>
    <div class="dept-card"><div class="dept-emoji">🧠</div><h4>Neurology</h4></div>
    <div class="dept-card"><div class="dept-emoji">🦴</div><h4>Orthopedics</h4></div>
    <div class="dept-card"><div class="dept-emoji">👶</div><h4>Pediatrics</h4></div>
    <div class="dept-card"><div class="dept-emoji">👁️</div><h4>Ophthalmology</h4></div>
    <div class="dept-card"><div class="dept-emoji">🦷</div><h4>Dentistry</h4></div>
    <div class="dept-card"><div class="dept-emoji">🩺</div><h4>General Medicine</h4></div>
    <div class="dept-card"><div class="dept-emoji">🧬</div><h4>Dermatology</h4></div>
    <div class="dept-card"><div class="dept-emoji">🏃</div><h4>Physiotherapy</h4></div>
    <div class="dept-card"><div class="dept-emoji">🩻</div><h4>Radiology</h4></div>
    <div class="dept-card"><div class="dept-emoji">💊</div><h4>Pharmacy</h4></div>
    <div class="dept-card"><div class="dept-emoji">🧪</div><h4>Pathology</h4></div>
  </div>
</section>

<!-- CTA -->
<section class="cta-section">
  <div class="section-tag" style="color:var(--accent2)">Get Started Today</div>
  <h2>Ready to Book Your<br/><em>Next Appointment?</em></h2>
  <p>Join thousands of patients who trust MediBook for hassle-free healthcare access.</p>
  <div class="cta-btns">
    <a href="${pageContext.request.contextPath}/register" class="btn-white">Create Patient Account →</a>
    <a href="${pageContext.request.contextPath}/login" class="btn-ghost">Already registered? Login</a>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="footer-brand">
    <a href="#" class="logo">Medi<span>Book</span></a>
    <p>A modern hospital appointment system built with Java, Hibernate &amp; MySQL. Fast, secure, and reliable.</p>
  </div>
  <div>
    <h5>Platform</h5>
    <ul>
      <li><a href="#features">Features</a></li>
      <li><a href="#departments">Departments</a></li>
      <li><a href="#how">How It Works</a></li>
    </ul>
  </div>
  <div>
    <h5>Portals</h5>
    <ul>
      <li><a href="${pageContext.request.contextPath}/register">Patient Register</a></li>
      <li><a href="${pageContext.request.contextPath}/login">Doctor Login</a></li>
      <li><a href="${pageContext.request.contextPath}/login">Admin Login</a></li>
    </ul>
  </div>
  <div>
    <h5>Tech Stack</h5>
    <ul>
      <li><a href="#">Java Servlets</a></li>
      <li><a href="#">Hibernate 5.6</a></li>
      <li><a href="#">MySQL 8</a></li>
      <li><a href="#">Apache Tomcat 9</a></li>
    </ul>
  </div>
</footer>
<div class="footer-bottom">© 2026 MediBook Hospital System. All rights reserved.</div>

<script>
  function toggleMenu() {
    document.getElementById('mobileMenu').classList.toggle('open');
  }
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.style.animation = 'fadeUp 0.6s ease both';
        observer.unobserve(e.target);
      }
    });
  }, { threshold: 0.1 });
  document.querySelectorAll('.feature-card, .role-card, .step, .dept-card').forEach(el => {
    el.style.opacity = '0';
    observer.observe(el);
  });
</script>
</body>
</html>

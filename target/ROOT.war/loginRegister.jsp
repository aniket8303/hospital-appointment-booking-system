<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Hospital Appointment Booking System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #1a5c99 0%, #0d3b66 50%, #0a2744 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .hero-text {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        .hero-text h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }
        .hero-text p {
            font-size: 1rem;
            opacity: 0.85;
        }
        .container {
            background: white;
            border-radius: 16px;
            width: 100%;
            max-width: 440px;
            padding: 36px 32px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .tabs {
            display: flex;
            margin-bottom: 28px;
            border-bottom: 2px solid #eef2f7;
        }
        .tab {
            flex: 1;
            padding: 12px;
            text-align: center;
            cursor: pointer;
            color: #888;
            font-weight: 600;
            font-size: 15px;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            transition: all 0.2s;
        }
        .tab.active {
            color: #1a5c99;
            border-bottom: 3px solid #1a5c99;
        }
        .form-section { display: none; }
        .form-section.active { display: block; }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #444;
            margin-bottom: 6px;
        }
        .form-group input {
            width: 100%;
            padding: 12px 14px;
            border: 1.5px solid #dde3ec;
            border-radius: 8px;
            font-size: 14px;
            color: #333;
            transition: border 0.2s;
            outline: none;
        }
        .form-group input:focus {
            border-color: #1a5c99;
            box-shadow: 0 0 0 3px rgba(26,92,153,0.1);
        }
        .btn {
            width: 100%;
            padding: 13px;
            background: #1a5c99;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            margin-top: 4px;
        }
        .btn:hover { background: #154d82; }
        .btn:active { transform: scale(0.98); }
        .msg-error {
            background: #fff0f0;
            color: #c0392b;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 13px;
            border-left: 4px solid #e74c3c;
        }
        .msg-success {
            background: #f0fff4;
            color: #1a8a4a;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 13px;
            border-left: 4px solid #27ae60;
        }
        .features {
            display: flex;
            justify-content: center;
            gap: 24px;
            margin-top: 24px;
        }
        .feature {
            text-align: center;
            color: rgba(255,255,255,0.85);
            font-size: 13px;
        }
        .feature-icon {
            font-size: 24px;
            display: block;
            margin-bottom: 4px;
        }
        @media (max-width: 480px) {
            .hero-text h1 { font-size: 1.5rem; }
            .container { padding: 28px 20px; }
            .features { gap: 14px; }
        }
    </style>
</head>
<body>

<div class="hero-text">
    <h1>&#127973; Hospital Appointment Booking</h1>
    <p>Book doctor appointments quickly and easily</p>
</div>

<div class="container">

    <%
        String error   = request.getParameter("error");
        String success = request.getParameter("success");
    %>
    <% if (error != null && !error.isEmpty()) { %>
        <div class="msg-error">&#10060; <%= error %></div>
    <% } %>
    <% if (success != null && !success.isEmpty()) { %>
        <div class="msg-success">&#10004; <%= success %></div>
    <% } %>

    <div class="tabs">
        <div class="tab active" onclick="showTab('login', this)">Login</div>
        <div class="tab" onclick="showTab('register', this)">Register</div>
    </div>

    <!-- Login Form -->
    <div id="login" class="form-section active">
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Enter your email" required/>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required/>
            </div>
            <button type="submit" class="btn">Login</button>
        </form>
        <p style="text-align:center;font-size:12px;color:#aaa;margin-top:16px;">
            Default admin: admin@hospital.com / admin123
        </p>
    </div>

    <!-- Register Form -->
    <div id="register" class="form-section">
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="Enter your full name" required/>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Enter your email" required/>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Create a password" required/>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" placeholder="Enter phone number"/>
            </div>
            <button type="submit" class="btn">Register as Patient</button>
        </form>
    </div>
</div>

<div class="features">
    <div class="feature">
        <span class="feature-icon">&#128197;</span>
        Easy Booking
    </div>
    <div class="feature">
        <span class="feature-icon">&#128105;&#8205;&#9877;</span>
        Expert Doctors
    </div>
    <div class="feature">
        <span class="feature-icon">&#128274;</span>
        Secure & Safe
    </div>
</div>

<script>
    function showTab(tab, el) {
        document.querySelectorAll('.form-section').forEach(f => f.classList.remove('active'));
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        document.getElementById(tab).classList.add('active');
        el.classList.add('active');
    }
    // Auto-show register tab if came from failed register
    <% if (request.getParameter("tab") != null && request.getParameter("tab").equals("register")) { %>
        showTab('register', document.querySelectorAll('.tab')[1]);
    <% } %>
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.model.User" %>
<%@ page import="com.hospital.model.Doctor" %>
<%@ page import="com.hospital.model.Appointment" %>
<%@ page import="com.hospital.dao.DoctorDAO" %>
<%@ page import="com.hospital.dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"doctor".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    DoctorDAO doctorDAO = new DoctorDAO();
    Doctor doctor = doctorDAO.getDoctorByUserId(loggedUser.getUserId());

    AppointmentDAO apptDAO = new AppointmentDAO();
    List<Appointment> allAppts   = null;
    List<Appointment> todayAppts = null;

    if (doctor != null) {
        allAppts   = apptDAO.getAppointmentsByDoctor(doctor.getDoctorId());
        todayAppts = apptDAO.getTodayAppointmentsByDoctor(
            doctor.getDoctorId(), new Date(System.currentTimeMillis()));
    }

    int total = 0, pending = 0, completed = 0, cancelled = 0;
    if (allAppts != null) {
        total = allAppts.size();
        for (Appointment a : allAppts) {
            String s = a.getStatus();
            if ("pending".equalsIgnoreCase(s) || "confirmed".equalsIgnoreCase(s)) pending++;
            else if ("completed".equalsIgnoreCase(s)) completed++;
            else if ("cancelled".equalsIgnoreCase(s)) cancelled++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Doctor Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f7f4; }
        .header {
            background: linear-gradient(135deg, #1a7a4a, #0d5c36);
            color: white;
            padding: 16px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .header h2 { font-size: 20px; font-weight: 700; }
        .header-right { display: flex; align-items: center; gap: 16px; font-size: 14px; }
        .logout-btn {
            color: white;
            text-decoration: none;
            background: rgba(255,255,255,0.2);
            padding: 7px 16px;
            border-radius: 20px;
            font-size: 13px;
        }
        .logout-btn:hover { background: rgba(255,255,255,0.35); }
        .main { padding: 24px 28px; max-width: 1300px; margin: 0 auto; }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat {
            background: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .stat-num { font-size: 32px; font-weight: 700; margin-bottom: 4px; }
        .stat-label { font-size: 12px; color: #888; }
        .grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .card {
            background: white;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: #1a7a4a;
            margin-bottom: 18px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e8f5ee;
        }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #1a7a4a; color: white; padding: 11px 12px; text-align: left; font-weight: 600; }
        td { padding: 10px 12px; border-bottom: 1px solid #eef2f7; vertical-align: middle; }
        tr:hover td { background: #f5fbf7; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: capitalize; }
        .badge-pending   { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #cfe2ff; color: #084298; }
        .badge-completed { background: #d1e7dd; color: #0a5c36; }
        .badge-cancelled { background: #f8d7da; color: #842029; }
        .btn-confirm { background: #0d6efd; color: white; border: none; padding: 5px 10px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; margin-right: 4px; }
        .btn-complete { background: #1a7a4a; color: white; border: none; padding: 5px 10px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; margin-right: 4px; }
        .btn-cancel { background: #e74c3c; color: white; border: none; padding: 5px 10px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .today-card {
            border: 1px solid #d4edda;
            border-radius: 10px;
            padding: 12px 14px;
            margin-bottom: 10px;
            background: #f8fffe;
        }
        .token-badge {
            width: 34px; height: 34px;
            background: #1a7a4a; color: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700; font-size: 12px;
            flex-shrink: 0;
        }
        .msg-success {
            background: #f0fff4; color: #1a8a4a;
            padding: 12px 16px; border-radius: 8px;
            margin-bottom: 20px; font-size: 13px;
            border-left: 4px solid #27ae60;
        }
        .info-row {
            display: flex; justify-content: space-between;
            padding: 8px 0; border-bottom: 1px solid #eef2f7;
            font-size: 13px;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #888; font-weight: 600; }
        .info-val { color: #333; }
        .empty-msg { text-align: center; color: #aaa; padding: 24px; font-size: 13px; }
        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .grid2 { grid-template-columns: 1fr; }
            .main { padding: 16px; }
        }
    </style>
</head>
<body>

<div class="header">
    <h2>&#128105;&#8205;&#9877;&#65039; Doctor Dashboard</h2>
    <div class="header-right">
        <span>Dr. <%= loggedUser.getName() %></span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="main">

    <% String msg = request.getParameter("success"); %>
    <% if (msg != null && !msg.isEmpty()) { %><div class="msg-success">&#10004; <%= msg %></div><% } %>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat">
            <div class="stat-num" style="color:#1a7a4a;"><%= total %></div>
            <div class="stat-label">Total</div>
        </div>
        <div class="stat">
            <div class="stat-num" style="color:#856404;"><%= pending %></div>
            <div class="stat-label">Upcoming</div>
        </div>
        <div class="stat">
            <div class="stat-num" style="color:#0a5c36;"><%= completed %></div>
            <div class="stat-label">Completed</div>
        </div>
        <div class="stat">
            <div class="stat-num" style="color:#842029;"><%= cancelled %></div>
            <div class="stat-label">Cancelled</div>
        </div>
    </div>

    <div class="grid2">

        <!-- Profile -->
        <div class="card">
            <div class="card-title">&#128100; My Profile</div>
            <% if (doctor != null) { %>
            <div style="display:flex;align-items:center;gap:14px;margin-bottom:18px;">
                <div style="width:56px;height:56px;border-radius:50%;background:#1a7a4a;color:white;
                            display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:700;">
                    <%= loggedUser.getName().substring(0,1).toUpperCase() %>
                </div>
                <div>
                    <div style="font-size:16px;font-weight:700;color:#1a7a4a;">Dr. <%= loggedUser.getName() %></div>
                    <div style="font-size:13px;color:#888;">
                        <%= doctor.getSpecialization() != null ? doctor.getSpecialization() : "General Physician" %>
                    </div>
                </div>
            </div>
            <div class="info-row"><span class="info-label">Email</span><span class="info-val"><%= loggedUser.getEmail() %></span></div>
            <div class="info-row"><span class="info-label">Phone</span><span class="info-val"><%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "-" %></span></div>
            <div class="info-row"><span class="info-label">Department</span><span class="info-val"><%= doctor.getDepartment().getDeptName() %></span></div>
            <div class="info-row"><span class="info-label">Experience</span><span class="info-val"><%= doctor.getExperienceYears() %> years</span></div>
            <% } else { %>
                <p class="empty-msg">Doctor profile not found.</p>
            <% } %>
        </div>

        <!-- Today's Appointments -->
        <div class="card">
            <div class="card-title">
                &#128197; Today's Appointments
                <span style="background:#1a7a4a;color:white;font-size:11px;padding:2px 8px;border-radius:12px;margin-left:6px;">
                    <%= todayAppts != null ? todayAppts.size() : 0 %>
                </span>
            </div>
            <% if (todayAppts != null && !todayAppts.isEmpty()) {
                 for (Appointment a : todayAppts) { %>
                <div class="today-card">
                    <div style="display:flex;justify-content:space-between;align-items:center;">
                        <div style="display:flex;align-items:center;gap:10px;">
                            <div class="token-badge">#<%= a.getTokenNo() %></div>
                            <div>
                                <div style="font-weight:700;font-size:13px;"><%= a.getPatient().getName() %></div>
                                <div style="font-size:12px;color:#666;"><%= a.getReason() != null ? a.getReason() : "No reason given" %></div>
                            </div>
                        </div>
                        <span class="badge badge-<%= a.getStatus().toLowerCase() %>"><%= a.getStatus() %></span>
                    </div>
                    <% if ("pending".equalsIgnoreCase(a.getStatus())) { %>
                    <div style="margin-top:10px;display:flex;gap:6px;flex-wrap:wrap;">
                        <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                            <input type="hidden" name="action" value="confirm"/>
                            <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                            <button class="btn-confirm" type="submit">Confirm</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                            <input type="hidden" name="action" value="complete"/>
                            <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                            <button class="btn-complete" type="submit">Complete</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                            <input type="hidden" name="action" value="cancel"/>
                            <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                            <button class="btn-cancel" type="submit">Cancel</button>
                        </form>
                    </div>
                    <% } else if ("confirmed".equalsIgnoreCase(a.getStatus())) { %>
                    <div style="margin-top:10px;">
                        <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                            <input type="hidden" name="action" value="complete"/>
                            <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                            <button class="btn-complete" type="submit">Mark Complete</button>
                        </form>
                    </div>
                    <% } %>
                </div>
            <% }} else { %>
                <div class="empty-msg">No appointments scheduled for today.</div>
            <% } %>
        </div>
    </div>

    <!-- All Appointments -->
    <div class="card">
        <div class="card-title">&#128203; All Appointments</div>
        <% if (allAppts != null && !allAppts.isEmpty()) { %>
        <div style="overflow-x:auto;">
            <table>
                <tr>
                    <th>Token</th>
                    <th>Patient</th>
                    <th>Date</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                <% for (Appointment a : allAppts) { %>
                <tr>
                    <td><strong style="color:#1a7a4a;">#<%= a.getTokenNo() %></strong></td>
                    <td><%= a.getPatient().getName() %></td>
                    <td><%= a.getApptDate() %></td>
                    <td><%= a.getReason() != null ? a.getReason() : "-" %></td>
                    <td><span class="badge badge-<%= a.getStatus().toLowerCase() %>"><%= a.getStatus() %></span></td>
                    <td>
                        <% if ("pending".equalsIgnoreCase(a.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                                <input type="hidden" name="action" value="confirm"/>
                                <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                                <button class="btn-confirm" type="submit">Confirm</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                                <input type="hidden" name="action" value="cancel"/>
                                <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                                <button class="btn-cancel" type="submit">Cancel</button>
                            </form>
                        <% } else if ("confirmed".equalsIgnoreCase(a.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/doctor" method="post" style="display:inline">
                                <input type="hidden" name="action" value="complete"/>
                                <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                                <button class="btn-complete" type="submit">Complete</button>
                            </form>
                        <% } else { %>
                            <span style="color:#ccc;font-size:12px;">-</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } else { %>
            <div class="empty-msg">No appointments yet.</div>
        <% } %>
    </div>
</div>
</body>
</html>

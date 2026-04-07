<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.model.User" %>
<%@ page import="com.hospital.model.Department" %>
<%@ page import="com.hospital.model.Doctor" %>
<%@ page import="com.hospital.model.Appointment" %>
<%@ page import="com.hospital.dao.DepartmentDAO" %>
<%@ page import="com.hospital.dao.DoctorDAO" %>
<%@ page import="com.hospital.dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"admin".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    DepartmentDAO deptDAO  = new DepartmentDAO();
    DoctorDAO doctorDAO    = new DoctorDAO();
    AppointmentDAO apptDAO = new AppointmentDAO();
    List<Department>  depts   = deptDAO.getAllDepartments();
    List<Doctor>      doctors = doctorDAO.getAllDoctors();
    List<Appointment> appts   = apptDAO.getAllAppointments();

    int totalAppts = appts != null ? appts.size() : 0;
    int pendingAppts = 0, completedAppts = 0;
    if (appts != null) {
        for (Appointment a : appts) {
            if ("pending".equalsIgnoreCase(a.getStatus()) || "confirmed".equalsIgnoreCase(a.getStatus())) pendingAppts++;
            else if ("completed".equalsIgnoreCase(a.getStatus())) completedAppts++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f0ee; }
        .header {
            background: linear-gradient(135deg, #712B13, #4a1b0c);
            color: white;
            padding: 16px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        .header h2 { font-size: 20px; font-weight: 700; }
        .logout-btn {
            color: white;
            text-decoration: none;
            background: rgba(255,255,255,0.2);
            padding: 7px 16px;
            border-radius: 20px;
            font-size: 13px;
        }
        .logout-btn:hover { background: rgba(255,255,255,0.35); }
        .main { padding: 24px 28px; max-width: 1400px; margin: 0 auto; }
        .stats-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 24px; }
        .stat { background: white; border-radius: 12px; padding: 20px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.07); }
        .stat-num { font-size: 32px; font-weight: 700; margin-bottom: 4px; }
        .stat-label { font-size: 12px; color: #888; }
        .forms-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .card { background: white; border-radius: 12px; padding: 22px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); margin-bottom: 20px; }
        .card-title { font-size: 16px; font-weight: 700; color: #712B13; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid #f5e8e4; }
        .form-group { margin-bottom: 12px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: #555; margin-bottom: 5px; }
        .form-group input,
        .form-group select {
            width: 100%; padding: 10px 12px;
            border: 1.5px solid #dde3ec;
            border-radius: 8px; font-size: 13px; color: #333; outline: none;
        }
        .form-group input:focus, .form-group select:focus { border-color: #712B13; }
        .btn-submit {
            width: 100%; padding: 11px;
            background: #712B13; color: white;
            border: none; border-radius: 8px;
            font-size: 14px; font-weight: 600; cursor: pointer;
            margin-top: 6px;
        }
        .btn-submit:hover { background: #5a2010; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #712B13; color: white; padding: 11px 12px; text-align: left; font-weight: 600; }
        td { padding: 10px 12px; border-bottom: 1px solid #eef2f7; vertical-align: middle; }
        tr:hover td { background: #fdf8f6; }
        .del-btn { background: #e74c3c; color: white; border: none; padding: 5px 12px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .del-btn:hover { background: #c0392b; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: capitalize; }
        .badge-pending   { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #cfe2ff; color: #084298; }
        .badge-completed { background: #d1e7dd; color: #0a5c36; }
        .badge-cancelled { background: #f8d7da; color: #842029; }
        .msg-success { background: #f0fff4; color: #1a8a4a; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; border-left: 4px solid #27ae60; }
        .msg-error { background: #fff0f0; color: #c0392b; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; border-left: 4px solid #e74c3c; }
        .empty-msg { text-align: center; color: #aaa; padding: 24px; font-size: 13px; }
        .nav-tabs { display: flex; gap: 4px; margin-bottom: 20px; flex-wrap: wrap; }
        .nav-tab { padding: 9px 18px; background: white; border: none; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; color: #888; box-shadow: 0 1px 4px rgba(0,0,0,0.08); transition: all 0.2s; }
        .nav-tab.active { background: #712B13; color: white; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2,1fr); }
            .forms-grid { grid-template-columns: 1fr; }
            .main { padding: 16px; }
        }
    </style>
</head>
<body>

<div class="header">
    <h2>&#9874;&#65039; Admin Dashboard</h2>
    <div style="display:flex;align-items:center;gap:16px;font-size:14px;">
        <span>Welcome, <%= loggedUser.getName() %>!</span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="main">

    <% String msg = request.getParameter("success"); String err = request.getParameter("error"); %>
    <% if (msg != null && !msg.isEmpty()) { %><div class="msg-success">&#10004; <%= msg %></div><% } %>
    <% if (err != null && !err.isEmpty()) { %><div class="msg-error">&#10060; <%= err %></div><% } %>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat">
            <div class="stat-num" style="color:#712B13;"><%= depts != null ? depts.size() : 0 %></div>
            <div class="stat-label">Departments</div>
        </div>
        <div class="stat">
            <div class="stat-num" style="color:#1a5c99;"><%= doctors != null ? doctors.size() : 0 %></div>
            <div class="stat-label">Doctors</div>
        </div>
        <div class="stat">
            <div class="stat-num" style="color:#856404;"><%= pendingAppts %></div>
            <div class="stat-label">Pending Appts</div>
        </div>
        <div class="stat">
            <div class="stat-num" style="color:#0a5c36;"><%= completedAppts %></div>
            <div class="stat-label">Completed</div>
        </div>
    </div>

    <!-- Nav Tabs -->
    <div class="nav-tabs">
        <button class="nav-tab active" onclick="showSection('departments', this)">&#127970; Departments</button>
        <button class="nav-tab" onclick="showSection('doctors', this)">&#128105;&#8205;&#9877;&#65039; Doctors</button>
        <button class="nav-tab" onclick="showSection('appointments', this)">&#128203; Appointments</button>
    </div>

    <!-- DEPARTMENTS TAB -->
    <div id="departments" class="tab-content active">
        <div class="forms-grid">
            <div class="card">
                <div class="card-title">Add Department</div>
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="addDepartment"/>
                    <div class="form-group">
                        <label>Department Name *</label>
                        <input type="text" name="deptName" placeholder="e.g. Cardiology" required/>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <input type="text" name="description" placeholder="Short description"/>
                    </div>
                    <button type="submit" class="btn-submit">Add Department</button>
                </form>
            </div>
            <div class="card">
                <div class="card-title">Department List</div>
                <% if (depts != null && !depts.isEmpty()) { %>
                <table>
                    <tr><th>#</th><th>Name</th><th>Description</th><th>Action</th></tr>
                    <% int di = 1; for (Department d : depts) { %>
                    <tr>
                        <td><%= di++ %></td>
                        <td><strong><%= d.getDeptName() %></strong></td>
                        <td><%= d.getDescription() != null ? d.getDescription() : "-" %></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline">
                                <input type="hidden" name="action" value="deleteDepartment"/>
                                <input type="hidden" name="id" value="<%= d.getDeptId() %>"/>
                                <button class="del-btn" type="submit" onclick="return confirm('Delete department?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
                <% } else { %><div class="empty-msg">No departments yet.</div><% } %>
            </div>
        </div>
    </div>

    <!-- DOCTORS TAB -->
    <div id="doctors" class="tab-content">
        <div class="forms-grid">
            <div class="card">
                <div class="card-title">Add Doctor</div>
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="addDoctor"/>
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="name" placeholder="Doctor full name" required/>
                    </div>
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" name="email" placeholder="Login email" required/>
                    </div>
                    <div class="form-group">
                        <label>Password *</label>
                        <input type="password" name="password" placeholder="Login password" required/>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" placeholder="Phone number"/>
                    </div>
                    <div class="form-group">
                        <label>Specialization</label>
                        <input type="text" name="specialization" placeholder="e.g. Cardiologist"/>
                    </div>
                    <div class="form-group">
                        <label>Experience (years)</label>
                        <input type="number" name="experienceYears" value="1" min="0"/>
                    </div>
                    <div class="form-group">
                        <label>Department *</label>
                        <select name="deptId" required>
                            <option value="">-- Select Department --</option>
                            <% if (depts != null) { for (Department d : depts) { %>
                                <option value="<%= d.getDeptId() %>"><%= d.getDeptName() %></option>
                            <% }} %>
                        </select>
                    </div>
                    <button type="submit" class="btn-submit">Add Doctor</button>
                </form>
            </div>
            <div class="card">
                <div class="card-title">Doctor List</div>
                <% if (doctors != null && !doctors.isEmpty()) { %>
                <div style="overflow-x:auto;">
                    <table>
                        <tr><th>#</th><th>Name</th><th>Email</th><th>Specialization</th><th>Exp</th><th>Dept</th><th>Action</th></tr>
                        <% int doci = 1; for (Doctor d : doctors) { %>
                        <tr>
                            <td><%= doci++ %></td>
                            <td><strong>Dr. <%= d.getUser().getName() %></strong></td>
                            <td style="font-size:12px;"><%= d.getUser().getEmail() %></td>
                            <td><%= d.getSpecialization() != null ? d.getSpecialization() : "-" %></td>
                            <td><%= d.getExperienceYears() %> yrs</td>
                            <td><%= d.getDepartment().getDeptName() %></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline">
                                    <input type="hidden" name="action" value="deleteDoctor"/>
                                    <input type="hidden" name="id" value="<%= d.getDoctorId() %>"/>
                                    <button class="del-btn" type="submit" onclick="return confirm('Delete doctor and all their appointments?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                </div>
                <% } else { %><div class="empty-msg">No doctors yet.</div><% } %>
            </div>
        </div>
    </div>

    <!-- APPOINTMENTS TAB -->
    <div id="appointments" class="tab-content">
        <div class="card">
            <div class="card-title">All Appointments (<%= totalAppts %>)</div>
            <% if (appts != null && !appts.isEmpty()) { %>
            <div style="overflow-x:auto;">
                <table>
                    <tr><th>Token</th><th>Patient</th><th>Doctor</th><th>Department</th><th>Date</th><th>Reason</th><th>Status</th><th>Action</th></tr>
                    <% for (Appointment a : appts) { %>
                    <tr>
                        <td><strong style="color:#712B13;">#<%= a.getTokenNo() %></strong></td>
                        <td><%= a.getPatient().getName() %></td>
                        <td>Dr. <%= a.getDoctor().getUser().getName() %></td>
                        <td><%= a.getDoctor().getDepartment().getDeptName() %></td>
                        <td><%= a.getApptDate() %></td>
                        <td><%= a.getReason() != null ? a.getReason() : "-" %></td>
                        <td><span class="badge badge-<%= a.getStatus().toLowerCase() %>"><%= a.getStatus() %></span></td>
                        <td>
                            <% if (!"completed".equalsIgnoreCase(a.getStatus()) && !"cancelled".equalsIgnoreCase(a.getStatus())) { %>
                            <form action="${pageContext.request.contextPath}/admin" method="post" style="display:inline">
                                <input type="hidden" name="action" value="updateAppointmentStatus"/>
                                <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                                <select name="status" onchange="this.form.submit()" style="padding:4px 8px;font-size:12px;border-radius:6px;border:1px solid #ddd;">
                                    <option value="">Update</option>
                                    <option value="pending">Pending</option>
                                    <option value="confirmed">Confirmed</option>
                                    <option value="completed">Completed</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </form>
                            <% } else { %>
                                <span style="color:#ccc;font-size:12px;">-</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
            <% } else { %><div class="empty-msg">No appointments in the system yet.</div><% } %>
        </div>
    </div>
</div>

<script>
function showSection(id, btn) {
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.nav-tab').forEach(b => b.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    btn.classList.add('active');
}
// Auto-open correct tab on success/error
<% if (request.getParameter("success") != null && request.getParameter("success").contains("Doctor")) { %>
    window.onload = function() { showSection('doctors', document.querySelectorAll('.nav-tab')[1]); }
<% } else if (request.getParameter("success") != null && request.getParameter("success").contains("Appointment")) { %>
    window.onload = function() { showSection('appointments', document.querySelectorAll('.nav-tab')[2]); }
<% } %>
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.hospital.model.User" %>
<%@ page import="com.hospital.model.Doctor" %>
<%@ page import="com.hospital.model.Department" %>
<%@ page import="com.hospital.model.Appointment" %>
<%@ page import="com.hospital.dao.DoctorDAO" %>
<%@ page import="com.hospital.dao.DepartmentDAO" %>
<%@ page import="com.hospital.dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"patient".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    DoctorDAO doctorDAO       = new DoctorDAO();
    DepartmentDAO deptDAO     = new DepartmentDAO();
    AppointmentDAO apptDAO    = new AppointmentDAO();
    List<Doctor> doctors      = doctorDAO.getAllDoctors();
    List<Department> depts    = deptDAO.getAllDepartments();
    List<Appointment> appts   = apptDAO.getAppointmentsByPatient(loggedUser.getUserId());

    int total = 0, pending = 0, completed = 0, cancelled = 0;
    if (appts != null) {
        total = appts.size();
        for (Appointment a : appts) {
            String s = a.getStatus();
            if ("pending".equalsIgnoreCase(s) || "confirmed".equalsIgnoreCase(s)) pending++;
            else if ("completed".equalsIgnoreCase(s)) completed++;
            else if ("cancelled".equalsIgnoreCase(s)) cancelled++;
        }
    }
    String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Patient Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; }
        .header {
            background: linear-gradient(135deg, #1a5c99, #0d3b66);
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
            transition: background 0.2s;
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
        .stat-label { font-size: 12px; color: #888; font-weight: 500; }
        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
        }
        .card {
            background: white;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: #1a5c99;
            margin-bottom: 18px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e8f0f7;
        }
        .form-group { margin-bottom: 14px; }
        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
        }
        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1.5px solid #dde3ec;
            border-radius: 8px;
            font-size: 13px;
            color: #333;
            outline: none;
            transition: border 0.2s;
        }
        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus { border-color: #1a5c99; }
        .form-group textarea { height: 70px; resize: none; }
        .btn-primary {
            width: 100%;
            padding: 12px;
            background: #1a5c99;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 4px;
        }
        .btn-primary:hover { background: #154d82; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th {
            background: #1a5c99;
            color: white;
            padding: 11px 12px;
            text-align: left;
            font-weight: 600;
        }
        td { padding: 10px 12px; border-bottom: 1px solid #eef2f7; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f5f9ff; }
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: capitalize;
        }
        .badge-pending   { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #cfe2ff; color: #084298; }
        .badge-completed { background: #d1e7dd; color: #0a5c36; }
        .badge-cancelled { background: #f8d7da; color: #842029; }
        .cancel-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 5px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
        }
        .cancel-btn:hover { background: #c0392b; }
        .msg-success {
            background: #f0fff4;
            color: #1a8a4a;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            border-left: 4px solid #27ae60;
        }
        .msg-error {
            background: #fff0f0;
            color: #c0392b;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 13px;
            border-left: 4px solid #e74c3c;
        }
        .empty-msg { text-align: center; color: #aaa; padding: 30px; font-size: 13px; }
        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .content-grid { grid-template-columns: 1fr; }
            .main { padding: 16px; }
            .header { flex-direction: column; gap: 10px; text-align: center; }
        }
    </style>
</head>
<body>

<div class="header">
    <h2>&#127973; Patient Dashboard</h2>
    <div class="header-right">
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
            <div class="stat-num" style="color:#1a5c99;"><%= total %></div>
            <div class="stat-label">Total Appointments</div>
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

    <div class="content-grid">

        <!-- Book Appointment -->
        <div class="card">
            <div class="card-title">&#128197; Book New Appointment</div>
            <form action="${pageContext.request.contextPath}/patient" method="post">
                <input type="hidden" name="action" value="bookAppointment"/>

                <div class="form-group">
                    <label>Filter by Department</label>
                    <select id="deptFilter" onchange="filterDoctors()">
                        <option value="">-- All Departments --</option>
                        <% if (depts != null) { for (Department d : depts) { %>
                            <option value="<%= d.getDeptId() %>"><%= d.getDeptName() %></option>
                        <% }} %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Select Doctor *</label>
                    <select name="doctorId" id="doctorSelect" required>
                        <option value="">-- Select Doctor --</option>
                        <% if (doctors != null) { for (Doctor doc : doctors) { %>
                            <option value="<%= doc.getDoctorId() %>"
                                    data-dept="<%= doc.getDepartment().getDeptId() %>">
                                Dr. <%= doc.getUser().getName() %>
                                (<%= doc.getSpecialization() != null ? doc.getSpecialization() : doc.getDepartment().getDeptName() %>)
                            </option>
                        <% }} %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Appointment Date *</label>
                    <input type="date" name="apptDate" required min="<%= today %>"/>
                </div>

                <div class="form-group">
                    <label>Reason for Visit</label>
                    <textarea name="reason" placeholder="Describe your symptoms..."></textarea>
                </div>

                <button type="submit" class="btn-primary">&#128197; Book Appointment</button>
            </form>
        </div>

        <!-- Profile Card -->
        <div class="card">
            <div class="card-title">&#128100; My Profile</div>
            <div style="display:flex;align-items:center;gap:14px;margin-bottom:20px;">
                <div style="width:60px;height:60px;border-radius:50%;background:#1a5c99;
                            color:white;display:flex;align-items:center;justify-content:center;
                            font-size:22px;font-weight:700;">
                    <%= loggedUser.getName().substring(0,1).toUpperCase() %>
                </div>
                <div>
                    <div style="font-size:17px;font-weight:700;color:#1a5c99;"><%= loggedUser.getName() %></div>
                    <div style="font-size:13px;color:#888;">Patient</div>
                </div>
            </div>
            <div style="display:flex;flex-direction:column;gap:10px;font-size:13px;">
                <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #eef2f7;">
                    <span style="color:#888;font-weight:600;">Email</span>
                    <span style="color:#333;"><%= loggedUser.getEmail() %></span>
                </div>
                <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #eef2f7;">
                    <span style="color:#888;font-weight:600;">Phone</span>
                    <span style="color:#333;"><%= loggedUser.getPhone() != null ? loggedUser.getPhone() : "Not set" %></span>
                </div>
                <div style="display:flex;justify-content:space-between;padding:8px 0;">
                    <span style="color:#888;font-weight:600;">Role</span>
                    <span style="background:#e8f0f7;color:#1a5c99;padding:2px 10px;border-radius:12px;font-weight:600;font-size:12px;">Patient</span>
                </div>
            </div>
            <% if (depts != null && !depts.isEmpty()) { %>
            <div style="margin-top:20px;">
                <div style="font-size:13px;font-weight:600;color:#555;margin-bottom:10px;">Available Departments</div>
                <div style="display:flex;flex-wrap:wrap;gap:6px;">
                    <% for (Department d : depts) { %>
                        <span style="background:#e8f0f7;color:#1a5c99;padding:4px 12px;
                                     border-radius:20px;font-size:12px;font-weight:600;">
                            <%= d.getDeptName() %>
                        </span>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Appointments Table -->
    <div class="card">
        <div class="card-title">&#128203; My Appointments</div>
        <% if (appts != null && !appts.isEmpty()) { %>
        <div style="overflow-x:auto;">
            <table>
                <tr>
                    <th>Token</th>
                    <th>Doctor</th>
                    <th>Department</th>
                    <th>Date</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                <% for (Appointment a : appts) { %>
                <tr>
                    <td><strong style="color:#1a5c99;">#<%= a.getTokenNo() %></strong></td>
                    <td>Dr. <%= a.getDoctor().getUser().getName() %></td>
                    <td><%= a.getDoctor().getDepartment().getDeptName() %></td>
                    <td><%= a.getApptDate() %></td>
                    <td><%= a.getReason() != null ? a.getReason() : "-" %></td>
                    <td>
                        <span class="badge badge-<%= a.getStatus().toLowerCase() %>">
                            <%= a.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <% if ("pending".equalsIgnoreCase(a.getStatus()) || "confirmed".equalsIgnoreCase(a.getStatus())) { %>
                        <form action="${pageContext.request.contextPath}/patient" method="post" style="display:inline">
                            <input type="hidden" name="action" value="cancelAppointment"/>
                            <input type="hidden" name="apptId" value="<%= a.getApptId() %>"/>
                            <button class="cancel-btn" type="submit"
                                    onclick="return confirm('Cancel this appointment?')">Cancel</button>
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
            <div class="empty-msg">
                &#128197; No appointments yet. Book your first appointment above!
            </div>
        <% } %>
    </div>
</div>

<script>
function filterDoctors() {
    const deptId  = document.getElementById('deptFilter').value;
    const sel     = document.getElementById('doctorSelect');
    const options = sel.options;
    for (let i = 1; i < options.length; i++) {
        const optDept = options[i].getAttribute('data-dept');
        options[i].style.display = (deptId === '' || optDept === deptId) ? '' : 'none';
    }
    sel.value = '';
}
</script>
</body>
</html>

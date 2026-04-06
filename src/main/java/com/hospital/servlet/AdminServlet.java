package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.DepartmentDAO;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.UserDAO;
import com.hospital.model.Department;
import com.hospital.model.Doctor;
import com.hospital.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("views/adminDashboard.jsp");
            return;
        }

        switch (action) {

            case "addDepartment": {
                String deptName    = request.getParameter("deptName");
                String description = request.getParameter("description");
                Department dept = new Department();
                dept.setDeptName(deptName);
                dept.setDescription(description);
                new DepartmentDAO().saveDepartment(dept);
                response.sendRedirect("views/adminDashboard.jsp?success=Department+added+successfully!");
                break;
            }

            case "deleteDepartment": {
                int deptId = Integer.parseInt(request.getParameter("id"));
                new DepartmentDAO().deleteDepartment(deptId);
                response.sendRedirect("views/adminDashboard.jsp?success=Department+deleted!");
                break;
            }

            case "addDoctor": {
                String name           = request.getParameter("name");
                String email          = request.getParameter("email");
                String password       = request.getParameter("password");
                String phone          = request.getParameter("phone");
                String specialization = request.getParameter("specialization");
                int experienceYears   = Integer.parseInt(request.getParameter("experienceYears"));
                int deptId            = Integer.parseInt(request.getParameter("deptId"));

                UserDAO userDAO = new UserDAO();

                if (userDAO.emailExists(email)) {
                    response.sendRedirect("views/adminDashboard.jsp?error=Email+already+exists!");
                    return;
                }

                User user = new User();
                user.setName(name);
                user.setEmail(email);
                user.setPassword(password);
                user.setPhone(phone);
                user.setRole("doctor");
                userDAO.saveUser(user);

                User savedUser = userDAO.getUserByEmailAndPassword(email, password);
                Department dept = new DepartmentDAO().getDepartmentById(deptId);

                Doctor doctor = new Doctor();
                doctor.setUser(savedUser);
                doctor.setDepartment(dept);
                doctor.setSpecialization(specialization);
                doctor.setExperienceYears(experienceYears);
                doctor.setActive(true);

                new DoctorDAO().saveDoctor(doctor);
                response.sendRedirect("views/adminDashboard.jsp?success=Doctor+added+successfully!");
                break;
            }

            case "deleteDoctor": {
                int doctorId = Integer.parseInt(request.getParameter("id"));
                new DoctorDAO().deleteDoctor(doctorId);
                response.sendRedirect("views/adminDashboard.jsp?success=Doctor+deleted!");
                break;
            }

            case "updateAppointmentStatus": {
                int apptId  = Integer.parseInt(request.getParameter("apptId"));
                String status = request.getParameter("status");
                new AppointmentDAO().updateStatus(apptId, status);
                response.sendRedirect("views/adminDashboard.jsp?success=Appointment+status+updated!");
                break;
            }

            default:
                response.sendRedirect("views/adminDashboard.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("views/adminDashboard.jsp");
    }
}

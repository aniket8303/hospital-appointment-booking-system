package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import com.hospital.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DoctorServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"doctor".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendRedirect("loginRegister.jsp");
            return;
        }

        int apptId = Integer.parseInt(request.getParameter("apptId"));
        AppointmentDAO apptDAO = new AppointmentDAO();

        if ("complete".equals(action)) {
            apptDAO.updateStatus(apptId, "completed");
            response.sendRedirect("views/doctorDashboard.jsp?success=Appointment+marked+completed!");
        } else if ("cancel".equals(action)) {
            apptDAO.updateStatus(apptId, "cancelled");
            response.sendRedirect("views/doctorDashboard.jsp?success=Appointment+cancelled!");
        } else if ("confirm".equals(action)) {
            apptDAO.confirmAppointment(apptId);
            response.sendRedirect("views/doctorDashboard.jsp?success=Appointment+confirmed!");
        } else {
            response.sendRedirect("views/doctorDashboard.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("views/doctorDashboard.jsp");
    }
}

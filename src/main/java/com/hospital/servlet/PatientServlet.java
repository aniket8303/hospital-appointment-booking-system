package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.DoctorDAO;
import com.hospital.model.Appointment;
import com.hospital.model.Doctor;
import com.hospital.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

public class PatientServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User patient = (User) session.getAttribute("loggedUser");

        if (patient == null) {
            response.sendRedirect("loginRegister.jsp");
            return;
        }

        if ("bookAppointment".equals(action)) {
            int doctorId      = Integer.parseInt(request.getParameter("doctorId"));
            String apptDateStr = request.getParameter("apptDate");
            String reason      = request.getParameter("reason");
            Date apptDate      = Date.valueOf(apptDateStr);

            Doctor doctor = new DoctorDAO().getDoctorById(doctorId);
            AppointmentDAO apptDAO = new AppointmentDAO();
            int tokenNo = apptDAO.getNextTokenNo(doctorId, apptDate);

            Appointment appt = new Appointment();
            appt.setPatient(patient);
            appt.setDoctor(doctor);
            appt.setApptDate(apptDate);
            appt.setReason(reason);
            appt.setStatus("pending");
            appt.setTokenNo(tokenNo);

            apptDAO.saveAppointment(appt);
            response.sendRedirect("views/patientDashboard.jsp?success=Appointment+booked!+Token:+" + tokenNo);

        } else if ("cancelAppointment".equals(action)) {
            int apptId = Integer.parseInt(request.getParameter("apptId"));
            new AppointmentDAO().cancelAppointment(apptId);
            response.sendRedirect("views/patientDashboard.jsp?success=Appointment+cancelled!");
        } else {
            response.sendRedirect("views/patientDashboard.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("views/patientDashboard.jsp");
    }
}

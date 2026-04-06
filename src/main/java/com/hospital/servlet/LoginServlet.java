package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Login attempt: " + email + " / " + password);

        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmailAndPassword(email, password);

        System.out.println("User found: " + (user != null));

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("role", user.getRole());

            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("views/adminDashboard.jsp");
            } else if ("doctor".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("views/doctorDashboard.jsp");
            } else {
                response.sendRedirect("views/patientDashboard.jsp");
            }
        } else {
            response.sendRedirect("loginRegister.jsp?error=Invalid+email+or+password");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("loginRegister.jsp");
    }
}

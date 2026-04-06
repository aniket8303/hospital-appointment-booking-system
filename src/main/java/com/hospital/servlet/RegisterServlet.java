package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String phone    = request.getParameter("phone");

        UserDAO dao = new UserDAO();

        if (dao.emailExists(email)) {
            response.sendRedirect("loginRegister.jsp?error=Email+already+registered");
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setRole("patient");

        dao.saveUser(user);
        response.sendRedirect("loginRegister.jsp?success=Registration+successful!+Please+login.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("loginRegister.jsp");
    }
}

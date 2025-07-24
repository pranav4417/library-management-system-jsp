package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/UpdateStudentServlet")
public class UpdateStudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");

            PreparedStatement ps = con.prepareStatement("UPDATE users SET name=?, email=?, course=? WHERE id=?");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, course);
            ps.setInt(4, id);
            ps.executeUpdate();

            response.sendRedirect("manageStudents.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Update error: " + e.getMessage());
        }
    }
}

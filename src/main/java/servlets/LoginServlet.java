package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // DB config
        String jdbcURL = "jdbc:mysql://localhost:3306/librarydb";
        String dbUser = "root";
        String dbPass = "pranav123";

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection con = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

            // Use prepared statement to avoid SQL injection
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, uname);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login success — start session
                HttpSession session = request.getSession();
                session.setAttribute("username", uname);
                response.sendRedirect("dashboard.jsp");
            } else {
                // Login failed
                out.println("<html><body>");
                out.println("<h3 style='color:red;'>❌ Invalid username or password</h3>");
                out.println("<a href='login.html'>⬅️ Try Again</a>");
                out.println("</body></html>");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (ClassNotFoundException | SQLException e) {
            out.println("<html><body>");
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
            out.println("</body></html>");
        } finally {
            out.close();
        }
    }
}

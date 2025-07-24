<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get username and password from request
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Null/empty check
    if(username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
        out.println("<script>alert('Please enter both username and password.'); history.back();</script>");
        return;
    }

    // JDBC setup
    String dbURL = "jdbc:mysql://localhost:3306/librarydb";
    String dbUser = "root";
    String dbPass = "pranav123";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Use prepared statement to avoid SQL injection
        PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");
        pst.setString(1, username);
        pst.setString(2, password);

        ResultSet rs = pst.executeQuery();

        if(rs.next()) {
            String role = rs.getString("role");

            // Set session variables
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            // Redirect based on role
            if("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("userDashboard.jsp");
            }
        } else {
            out.println("<script>alert('Invalid username or password.'); history.back();</script>");
        }

        // Cleanup
        rs.close();
        pst.close();
        con.close();

    } catch(Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
    }
%>

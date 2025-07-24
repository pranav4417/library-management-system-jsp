<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String name = "", email = "", course = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            course = rs.getString("course");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<html>
<head>
    <title>Update Student</title>
</head>
<body>
    <h2>Update Student Info</h2>
    <form action="UpdateStudentServlet" method="post">
        <input type="hidden" name="id" value="<%=id%>">
        Name: <input type="text" name="name" value="<%=name%>"><br><br>
        Email: <input type="text" name="email" value="<%=email%>"><br><br>
        Course: <input type="text" name="course" value="<%=course%>"><br><br>
        <input type="submit" value="Update">
    </form>
</body>
</html>

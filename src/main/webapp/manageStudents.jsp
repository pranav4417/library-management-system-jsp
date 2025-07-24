<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Students</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
      background: #f0f2f5;
      animation: fadeIn 0.5s ease-in;
    }
    header {
      background: #3f51b5;
      color: white;
      padding: 20px;
      font-size: 24px;
      text-align: center;
    }
    .container {
      margin: 30px auto;
      width: 90%;
      max-width: 1000px;
      background: white;
      padding: 25px;
      border-radius: 10px;
      box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
      animation: slideUp 0.6s ease;
    }
    h2 {
      color: #333;
      margin-bottom: 20px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th, td {
      text-align: center;
      padding: 12px;
      border-bottom: 1px solid #ddd;
    }
    th {
      background: #f5f5f5;
    }
    .action-btn {
      border: none;
      border-radius: 6px;
      padding: 6px 12px;
      cursor: pointer;
      font-size: 14px;
      color: white;
    }
    .update-btn { background-color: #4caf50; }
    .delete-btn { background-color: #f44336; }
    .add-btn {
      background-color: #2196f3;
      margin-bottom: 15px;
      float: right;
    }
    .back-btn {
      background-color: #607d8b;
      margin-bottom: 15px;
      color: white;
      text-decoration: none;
      padding: 8px 14px;
      border-radius: 6px;
      display: inline-block;
    }
    .action-btn i { margin-right: 5px; }
    input[type="text"], input[type="email"] {
      padding: 5px;
      width: 90%;
      border: 1px solid #ccc;
      border-radius: 5px;
    }
    .add-form {
      margin-bottom: 30px;
      display: none;
      background: #f9f9f9;
      padding: 15px;
      border-radius: 10px;
      border: 1px solid #ddd;
    }
    @keyframes fadeIn {
      from {opacity: 0;}
      to {opacity: 1;}
    }
    @keyframes slideUp {
      from {transform: translateY(30px); opacity: 0;}
      to {transform: translateY(0); opacity: 1;}
    }
  </style>
  <script>
    function toggleAddForm() {
      const form = document.getElementById("addStudentForm");
      form.style.display = form.style.display === "none" ? "block" : "none";
    }
  </script>
</head>
<body>

<%
  // Handle Add
  if (request.getParameter("add") != null) {
    String name = request.getParameter("new_username");
    String email = request.getParameter("new_email");
    String course = request.getParameter("new_course");
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      PreparedStatement ps = con.prepareStatement("INSERT INTO users (username, email, course) VALUES (?, ?, ?)");
      ps.setString(1, name);
      ps.setString(2, email);
      ps.setString(3, course);
      ps.executeUpdate();
      con.close();
    } catch (Exception e) {
      out.println("<p style='color:red;'>Add Error: " + e.getMessage() + "</p>");
    }
  }

  // Handle Update
  if (request.getParameter("update") != null) {
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("username");
    String email = request.getParameter("email");
    String course = request.getParameter("course");
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      PreparedStatement ps = con.prepareStatement("UPDATE users SET username=?, email=?, course=? WHERE id=?");
      ps.setString(1, name);
      ps.setString(2, email);
      ps.setString(3, course);
      ps.setInt(4, id);
      ps.executeUpdate();
      con.close();
    } catch (Exception e) {
      out.println("<p style='color:red;'>Update Error: " + e.getMessage() + "</p>");
    }
  }

  // Handle Delete
  if (request.getParameter("delete") != null) {
    int id = Integer.parseInt(request.getParameter("id"));
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?");
      ps.setInt(1, id);
      ps.executeUpdate();
      con.close();
    } catch (Exception e) {
      out.println("<p style='color:red;'>Delete Error: " + e.getMessage() + "</p>");
    }
  }
%>

<header>👨‍🎓 Manage Students</header>
<div class="container">
  <!-- Back to Dashboard Button -->
  <a href="dashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>

  <h2>
    Student Records
    <button class="action-btn add-btn" onclick="toggleAddForm()">
      <i class="fas fa-user-plus"></i> Add Student
    </button>
  </h2>

  <!-- Add Student Form -->
  <div id="addStudentForm" class="add-form">
    <form method="post">
      <input type="text" name="new_username" placeholder="Name" required />
      <input type="email" name="new_email" placeholder="Email" required />
      <input type="text" name="new_course" placeholder="Course" required />
      <button type="submit" name="add" class="action-btn update-btn"><i class="fas fa-plus"></i> Add</button>
    </form>
  </div>

  <%
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      Statement stmt = con.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT * FROM users");

      out.println("<table>");
      out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Course</th><th>Actions</th></tr>");
      while (rs.next()) {
        int id = rs.getInt("id");
        String name = rs.getString("username");
        String email = rs.getString("email");
        String course = rs.getString("course");

        out.println("<tr>");
        out.println("<form method='post'>");
        out.println("<input type='hidden' name='id' value='" + id + "'/>");
        out.println("<td>" + id + "</td>");
        out.println("<td><input type='text' name='username' value='" + name + "' required></td>");
        out.println("<td><input type='email' name='email' value='" + email + "' required></td>");
        out.println("<td><input type='text' name='course' value='" + course + "' required></td>");
        out.println("<td>");
        out.println("<button type='submit' name='update' class='action-btn update-btn'><i class='fas fa-save'></i> Update</button>");
        out.println("</form>");
        out.println("<form method='post' style='display:inline;'>");
        out.println("<input type='hidden' name='id' value='" + id + "'/>");
        out.println("<button type='submit' name='delete' class='action-btn delete-btn'><i class='fas fa-trash'></i> Delete</button>");
        out.println("</form>");
        out.println("</td>");
        out.println("</tr>");
      }
      out.println("</table>");
      con.close();
    } catch (Exception e) {
      out.println("<p style='color:red;'>Display Error: " + e.getMessage() + "</p>");
    }
  %>
</div>

</body>
</html>

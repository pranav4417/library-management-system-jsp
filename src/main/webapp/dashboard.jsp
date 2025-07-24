<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>📚 Library Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      padding: 0;
      background: #f0f2f5;
      animation: fadeIn 0.5s ease-in-out;
    }

    header {
      background-color: #673ab7;
      color: white;
      padding: 20px;
      text-align: center;
      font-size: 28px;
      font-weight: bold;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    nav {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      background-color: #3f51b5;
      padding: 10px;
    }

    nav a {
      color: white;
      text-decoration: none;
      margin: 8px 12px;
      padding: 10px 14px;
      border-radius: 6px;
      background-color: #5c6bc0;
      transition: background-color 0.3s ease;
    }

    nav a:hover {
      background-color: #7986cb;
    }

    .container {
      padding: 30px;
      max-width: 1100px;
      margin: auto;
    }

    h2 {
      color: #333;
      margin-bottom: 20px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      box-shadow: 0 3px 8px rgba(0,0,0,0.1);
      background: white;
      animation: slideIn 0.4s ease-in-out;
    }

    table th, table td {
      padding: 12px 16px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }

    table th {
      background-color: #eeeeee;
      color: #333;
      font-weight: 600;
    }

    table tr:hover {
      background-color: #f1f1f1;
      transition: background 0.2s ease-in-out;
    }

    .error {
      color: red;
      font-weight: bold;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }

    @keyframes slideIn {
      from { transform: translateY(20px); opacity: 0; }
      to   { transform: translateY(0); opacity: 1; }
    }
  </style>
</head>
<body>

<header>📚 Library Management Dashboard</header>

<nav>

  <a href="issuebook.jsp">📌 Issue Book</a>
  <a href="searchBook.html">🔍 Search Book</a>
  <a href="manageStudents.jsp">👥 Manage Students</a>
  <a href="manageBooks.jsp">📚 Manage Books</a>
  <a href="login.html">🚪 Logout</a>
</nav>

<div class="container">
  <h2>📖 Available Books</h2>
  <%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM books");

        out.println("<table>");
        out.println("<tr><th>ID</th><th>Title</th><th>Author</th><th>Status</th></tr>");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getInt("id") + "</td>");
            out.println("<td>" + rs.getString("title") + "</td>");
            out.println("<td>" + rs.getString("author") + "</td>");
            out.println("<td>" + rs.getString("status") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        con.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
    }
  %>
</div>
<footer style="text-align:center; padding: 10px; background-color:#f2f2f2; color:#333; font-family:Arial, sans-serif; font-size: 14px; margin-top: 50px;">
  &copy; <%= java.time.Year.now() %> Pranav Kandakurthi | Curious CSE Student | Presidency University<br>
  Driven by Ethical Knowledge 🕉️ | All rights reserved.
</footer>

</body>
</html>

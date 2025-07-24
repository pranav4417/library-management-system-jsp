<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>📚 Manage Books</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f7fa;
    }

    header {
      background-color: #2c3e50;
      color: white;
      padding: 20px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      position: relative;
    }

    .back-btn {
      position: absolute;
      right: 20px;
      top: 20px;
      background-color: #34495e;
      color: white;
      padding: 8px 12px;
      text-decoration: none;
      border-radius: 5px;
      font-size: 14px;
    }

    .container {
      width: 90%;
      max-width: 1000px;
      margin: 40px auto;
      background-color: white;
      padding: 30px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      border-radius: 8px;
    }

    h2 {
      color: #333;
      margin-bottom: 20px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }

    th, td {
      padding: 12px 15px;
      text-align: left;
    }

    th {
      background-color: #2980b9;
      color: white;
    }

    tr:nth-child(even) {
      background-color: #f2f2f2;
    }

    .action-btn {
      border: none;
      padding: 8px 12px;
      font-size: 14px;
      border-radius: 4px;
      cursor: pointer;
      color: white;
      transition: background-color 0.3s ease;
    }

    .update-btn {
      background-color: #27ae60;
    }

    .delete-btn {
      background-color: #e74c3c;
    }

    .add-btn {
      background-color: #3498db;
      margin-top: 10px;
    }

    .update-btn:hover {
      background-color: #219150;
    }

    .delete-btn:hover {
      background-color: #c0392b;
    }

    .add-btn:hover {
      background-color: #2980b9;
    }

    input[type="text"] {
      width: 90%;
      padding: 5px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    form {
      display: inline;
    }

    .add-form {
      margin-bottom: 20px;
    }
  </style>
</head>
<body>

<header>
  📚 Manage Books
  <a href="dashboard.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
</header>

<%
  // Handle Add
  if (request.getParameter("add") != null) {
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String status = request.getParameter("status");
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      PreparedStatement ps = con.prepareStatement("INSERT INTO books(title, author, status) VALUES (?, ?, ?)");
      ps.setString(1, title);
      ps.setString(2, author);
      ps.setString(3, status);
      ps.executeUpdate();
      con.close();
    } catch (Exception e) {
      out.println("<p style='color:red;'>Add Error: " + e.getMessage() + "</p>");
    }
  }

  // Handle Update
  if (request.getParameter("update") != null) {
    int id = Integer.parseInt(request.getParameter("id"));
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String status = request.getParameter("status");
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      PreparedStatement ps = con.prepareStatement("UPDATE books SET title=?, author=?, status=? WHERE id=?");
      ps.setString(1, title);
      ps.setString(2, author);
      ps.setString(3, status);
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
      PreparedStatement ps = con.prepareStatement("DELETE FROM books WHERE id=?");
      ps.setInt(1, id);
      ps.executeUpdate();
      con.close();
    } catch (Exception e) {
      out.println("<p style='color:red;'>Delete Error: " + e.getMessage() + "</p>");
    }
  }
%>

<div class="container">
  <h2>Book Records</h2>

  <!-- Add Book Form -->
  <form method="post" class="add-form">
    <table>
      <tr>
        <td><input type="text" name="title" placeholder="Title" required></td>
        <td><input type="text" name="author" placeholder="Author" required></td>
        <td><input type="text" name="status" placeholder="Available / Issued" required></td>
        <td><button type="submit" name="add" class="action-btn add-btn"><i class="fas fa-plus"></i> Add Book</button></td>
      </tr>
    </table>
  </form>

  <!-- Book Table -->
  <%
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
      Statement stmt = con.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT * FROM books");

      out.println("<table>");
      out.println("<tr><th>ID</th><th>Title</th><th>Author</th><th>Status</th><th>Actions</th></tr>");
      while (rs.next()) {
        int id = rs.getInt("id");
        String title = rs.getString("title");
        String author = rs.getString("author");
        String status = rs.getString("status");

        out.println("<tr>");
        out.println("<form method='post'>");
        out.println("<input type='hidden' name='id' value='" + id + "'/>");
        out.println("<td>" + id + "</td>");
        out.println("<td><input type='text' name='title' value='" + title + "' required></td>");
        out.println("<td><input type='text' name='author' value='" + author + "' required></td>");
        out.println("<td><input type='text' name='status' value='" + status + "' required></td>");
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

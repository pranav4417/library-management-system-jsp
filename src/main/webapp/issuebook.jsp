<%@ page import="java.sql.*, java.util.*" %>
<html>
<head>
  <title>Issue a Book</title>
  <style>
    body { font-family: Arial; background-color: #eef; padding: 30px; }
    form { background: #fff; padding: 20px; width: 400px; margin: auto; border-radius: 10px; }
    select, input, button { width: 100%; padding: 10px; margin-top: 10px; }
    button { background-color: #0077cc; color: white; border: none; margin-top: 20px; }
    .message { text-align: center; font-weight: bold; margin-top: 20px; }
  </style>
</head>
<body>
<%
    String msg = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String status = "issued";
        String username = "";
        String bookTitle = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");

            // Get student username
            PreparedStatement getUser = conn.prepareStatement("SELECT username FROM users WHERE id = ?");
            getUser.setInt(1, studentId);
            ResultSet rsUser = getUser.executeQuery();
            if (rsUser.next()) {
                username = rsUser.getString("username");
            }

            // Get book title
            PreparedStatement getBook = conn.prepareStatement("SELECT title FROM books WHERE id = ?");
            getBook.setInt(1, bookId);
            ResultSet rsBook = getBook.executeQuery();
            if (rsBook.next()) {
                bookTitle = rsBook.getString("title");
            }

            // 1. Update book status
            PreparedStatement ps1 = conn.prepareStatement("UPDATE books SET status = ? WHERE id = ?");
            ps1.setString(1, status);
            ps1.setInt(2, bookId);
            ps1.executeUpdate();

            // 2. Insert into issued_books
            PreparedStatement ps2 = conn.prepareStatement("INSERT INTO issued_books (user_id, book_id, issue_date) VALUES (?, ?, NOW())");
            ps2.setInt(1, studentId);
            ps2.setInt(2, bookId);
            ps2.executeUpdate();

            // 3. Insert into borrowed_books
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO borrowed_books (username, book_title, borrowed_date) VALUES (?, ?, CURDATE())");
            ps3.setString(1, username);
            ps3.setString(2, bookTitle);
            ps3.executeUpdate();

            msg = " Book issued successfully to " + username + "!";

            conn.close();
        } catch (Exception e) {
            msg = " Error: " + e.getMessage();
        }
    }
%>

<h2 style="text-align:center;">Issue a Book</h2>
<form method="post" action="issuebook.jsp">
  <label for="student">Select Student:</label>
  <select name="studentId" required>
    <%
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users");
        while(rs.next()) {
    %>
      <option value="<%=rs.getInt("id")%>"><%=rs.getString("username")%></option>
    <%
        }
        conn.close();
      } catch(Exception e) { out.println("Error: "+e); }
    %>
  </select>

  <label for="book">Select Book:</label>
  <select name="bookId" required>
    <%
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM books WHERE status = 'available'");
        while(rs.next()) {
    %>
      <option value="<%=rs.getInt("id")%>"><%=rs.getString("title")%></option>
    <%
        }
        conn.close();
      } catch(Exception e) { out.println("Error: "+e); }
    %>
  </select>

  <button type="submit">Issue Book</button>
</form>

<% if (!msg.isEmpty()) { %>
  <div class="message"><%= msg %></div>
<% } %>

<footer style="text-align:center; padding: 10px; background-color:#f2f2f2; color:#333; font-family:Arial, sans-serif; font-size: 14px; margin-top: 50px;">
  &copy; <%= java.time.Year.now() %> Pranav Kandakurthi | Curious CSE Student | Presidency University<br>
  Driven by Ethical Knowledge | All rights reserved.
</footer>
</body>
</html>

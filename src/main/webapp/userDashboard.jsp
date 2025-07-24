<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        out.println("<script>alert('Please login first.'); location.href='login.jsp';</script>");
        return;
    }

    List<String> borrowedBooks = new ArrayList<>();
    String currentEmail = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");

        // Fetch borrowed books
        PreparedStatement pst = con.prepareStatement("SELECT book_title FROM borrowed_books WHERE username=?");
        pst.setString(1, username);
        ResultSet rs = pst.executeQuery();
        while (rs.next()) {
            borrowedBooks.add(rs.getString("book_title"));
        }

        // Fetch current email
        pst = con.prepareStatement("SELECT email FROM users WHERE username=?");
        pst.setString(1, username);
        rs = pst.executeQuery();
        if (rs.next()) {
            currentEmail = rs.getString("email");
        }

        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }

    // Handle email update
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("updateEmail") != null) {
        String newEmail = request.getParameter("newEmail");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/librarydb", "root", "pranav123");

            PreparedStatement pst = con.prepareStatement("UPDATE users SET email=? WHERE username=?");
            pst.setString(1, newEmail);
            pst.setString(2, username);
            int rows = pst.executeUpdate();
            con.close();

            if (rows > 0) {
                out.println("<script>alert('Email updated successfully!'); location.href='userDashboard.jsp';</script>");
            } else {
                out.println("<script>alert('Email update failed.');</script>");
            }
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #e0eafc, #cfdef3);
            margin: 0;
            padding: 0;
        }

        .dashboard {
            max-width: 700px;
            margin: 50px auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .tabs {
            display: flex;
            border-bottom: 2px solid #eee;
            background-color: #f7f9fc;
        }

        .tab {
            flex: 1;
            text-align: center;
            padding: 15px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
        }

        .tab:hover {
            background-color: #e0eafc;
        }

        .tab.active {
            background-color: #ffffff;
            border-bottom: 3px solid #0077cc;
        }

        .content {
            padding: 30px;
            display: none;
        }

        .content.active {
            display: block;
        }

        ul {
            padding-left: 20px;
        }

        li {
            margin-bottom: 8px;
        }

        input[type="email"] {
            padding: 10px;
            width: 70%;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        input[type="submit"] {
            padding: 10px 15px;
            background-color: #0077cc;
            color: white;
            border: none;
            margin-left: 10px;
            cursor: pointer;
            border-radius: 6px;
        }

        input[type="submit"]:hover {
            background-color: #005fa3;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }
    </style>

    <script>
        function showTab(tabId) {
            const tabs = document.querySelectorAll('.tab');
            const contents = document.querySelectorAll('.content');
            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));

            document.getElementById(tabId).classList.add('active');
            document.getElementById(tabId + "-tab").classList.add('active');
        }

        window.onload = function () {
            showTab('borrowed');
        };
    </script>
</head>
<body>
    <div class="dashboard">
        <div class="tabs">
            <div class="tab" id="borrowed-tab" onclick="showTab('borrowed')"> Borrowed Books</div>
            <div class="tab" id="email-tab" onclick="showTab('email')"> Update Email</div>
        </div>

        <div class="content" id="borrowed">
            <h2>Welcome, <%= username %>!</h2>
            <h3>Your Borrowed Books:</h3>
            <ul>
                <% if (borrowedBooks.isEmpty()) { %>
                    <li>No books borrowed yet.</li>
                <% } else {
                    for (String title : borrowedBooks) { %>
                        <li><%= title %></li>
                <%  } } %>
            </ul>
        </div>

        <div class="content" id="email">
            <h2>Update Your Email</h2>
            <form method="post">
                <input type="email" name="newEmail" value="<%= currentEmail %>" required />
                <input type="submit" name="updateEmail" value="Update" />
            </form>
        </div>
    </div>
</body>
</html>

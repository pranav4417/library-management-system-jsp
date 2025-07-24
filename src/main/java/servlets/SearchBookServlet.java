package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SearchBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String query = request.getParameter("query");

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/librarydb", "root", "pranav123"
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM books WHERE title LIKE ? OR author LIKE ?"
            );
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            ResultSet rs = ps.executeQuery();

            out.println("<html><head><title>Search Results</title></head><body>");
            out.println("<h2>Search Results for: " + query + "</h2>");
            out.println("<table border='1' cellpadding='10'>");
            out.println("<tr><th>ID</th><th>Title</th><th>Author</th><th>ISBN</th><th>Status</th></tr>");
            
            boolean found = false;
            while (rs.next()) {
                found = true;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("title") + "</td>");
                out.println("<td>" + rs.getString("author") + "</td>");
                out.println("<td>" + rs.getString("isbn") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
                out.println("</tr>");
            }

            if (!found) {
                out.println("<tr><td colspan='5'>No books found.</td></tr>");
            }

            out.println("</table><br><a href='searchBook.html'>Search Again</a>");
            out.println("<br><a href='dashboard.jsp'>⬅ Back to Dashboard</a>");
            out.println("</body></html>");
            
            con.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
}

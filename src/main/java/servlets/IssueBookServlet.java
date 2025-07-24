package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class IssueBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "pranav123");

            // Insert into issued_books
            String issueQuery = "INSERT INTO issued_books (user_id, book_id, issue_date, return_date) VALUES (?, ?, CURDATE(), NULL)";
            PreparedStatement pst = con.prepareStatement(issueQuery);
            pst.setInt(1, userId);
            pst.setInt(2, bookId);
            int result = pst.executeUpdate();

            // Update book status
            String updateQuery = "UPDATE books SET status='issued' WHERE id=?";
            PreparedStatement pst2 = con.prepareStatement(updateQuery);
            pst2.setInt(1, bookId);
            pst2.executeUpdate();

            if(result > 0){
                out.println("<h3>Book issued successfully!</h3>");
            } else {
                out.println("<h3>Failed to issue book.</h3>");
            }
            con.close();
        } catch(Exception e){
            e.printStackTrace(out);
        }
        out.println("<br><a href='dashboard.jsp'>⬅ Back to Dashboard</a>");
    }
}

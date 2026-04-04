<%@ page import="java.sql.*" %>

<%
    String type = request.getParameter("type");
    String description = request.getParameter("description");
    String amountStr = request.getParameter("amount");
    String dateStr = request.getParameter("date");
    String category = request.getParameter("category");

    Connection con = null;

    try {
        // Basic validation
        if(type == null || amountStr == null || dateStr == null){
            out.println("<h3 style='color:red;'>Missing required fields!</h3>");
            return;
        }

        int amount = Integer.parseInt(amountStr);

        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/finance_db",
                "root",
                "12345678"
        );

        String query = "INSERT INTO transactions(type, amount, category, date, description) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(query);

        ps.setString(1, type);
        ps.setInt(2, amount);
        ps.setString(3, category);
        ps.setDate(4, java.sql.Date.valueOf(dateStr));
        ps.setString(5, description);

        int result = ps.executeUpdate();

        if(result > 0){
            // SUCCESS → go back to dashboard
            response.sendRedirect("index.jsp");
        } else {
            out.println("<h3 style='color:red;'>Failed to add transaction!</h3>");
        }

    } catch(NumberFormatException e){
        out.println("<h3 style='color:red;'>Invalid amount format!</h3>");

    } catch(Exception e){
        out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");

    } finally {
        if(con != null){
            try { con.close(); } catch(Exception e){}
        }
    }
%>
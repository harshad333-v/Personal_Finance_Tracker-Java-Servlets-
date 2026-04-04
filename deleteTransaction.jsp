<%@ page import="java.sql.*" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/finance_db",
            "root",
            "12345678"
    );

    PreparedStatement ps = con.prepareStatement(
            "DELETE FROM transactions WHERE id=?"
    );

    ps.setInt(1, id);
    ps.executeUpdate();

    response.sendRedirect("index.jsp");
%>
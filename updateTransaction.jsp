<%@ page import="java.sql.*" %>

<%
  int id = Integer.parseInt(request.getParameter("id"));
  String type = request.getParameter("type");
  String description = request.getParameter("description");
  String category = request.getParameter("category");
  int amount = Integer.parseInt(request.getParameter("amount"));
  String date = request.getParameter("date");

  Class.forName("com.mysql.cj.jdbc.Driver");

  Connection con = DriverManager.getConnection(
          "jdbc:mysql://localhost:3306/finance_db",
          "root",
          "12345678"
  );

  PreparedStatement ps = con.prepareStatement(
          "UPDATE transactions SET type=?, description=?, category=?, amount=?, date=? WHERE id=?"
  );

  ps.setString(1, type);
  ps.setString(2, description);
  ps.setString(3, category);
  ps.setInt(4, amount);
  ps.setDate(5, java.sql.Date.valueOf(date));
  ps.setInt(6, id);

  ps.executeUpdate();

  response.sendRedirect("index.jsp");
%>
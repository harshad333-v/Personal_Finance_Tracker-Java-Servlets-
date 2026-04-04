<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/finance_db",
            "root",
            "12345678"
    );

    PreparedStatement ps = con.prepareStatement("SELECT * FROM transactions WHERE id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    rs.next();
%>

<html>
<head>
    <title>Edit Transaction</title>
    <meta charset="UTF-8">

    <style>
        body {
            font-family: Arial;
            background: #f0f2f5;
        }

        .container {
            width: 500px;
            margin: 50px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #6c63ff;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            color: white;
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .update-btn {
            background: #6c63ff;
        }

        .delete-btn {
            background: red;
            margin-top: 10px;
        }

        .back-btn {
            background: #999;
            margin-top: 10px;
        }
    </style>

</head>

<body>

<div class="container">

    <h2>Edit Transaction</h2>

    <!-- UPDATE FORM -->
    <form action="updateTransaction.jsp" method="post">

        <input type="hidden" name="id" value="<%= id %>">

        <select name="type" required>
            <option value="income" <%= rs.getString("type").equals("income") ? "selected" : "" %>>Income</option>
            <option value="expense" <%= rs.getString("type").equals("expense") ? "selected" : "" %>>Expense</option>
        </select>

        <input type="text" name="description"
               value="<%= rs.getString("description") %>" required>

        <input type="text" name="category"
               value="<%= rs.getString("category") %>" required>

        <input type="number" name="amount"
               value="<%= rs.getInt("amount") %>" required>

        <input type="date" name="date"
               value="<%= rs.getDate("date") %>" required>

        <button class="update-btn" type="submit">
            Update Transaction
        </button>

    </form>

    <!-- DELETE FORM -->
    <form action="deleteTransaction.jsp" method="get"
          onsubmit="return confirm('Are you sure you want to delete this transaction?')">

        <input type="hidden" name="id" value="<%= id %>">


    </form>

    <!-- BACK BUTTON -->
    <a href="index.jsp">
        <button class="back-btn">
            Back to Dashboard
        </button>
    </a>

</div>

</body>
</html>
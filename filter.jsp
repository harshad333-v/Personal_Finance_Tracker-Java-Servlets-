<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Financial Filter Report</title>
    <meta charset="UTF-8">

    <style>
        body {
            font-family: Arial;
            background: #f0f2f5;
        }

        .container {
            width: 650px;
            margin: 40px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #6c63ff;
        }

        /* FILTER FORM */
        form input, form select {
            width: 100%;
            padding: 10px;
            margin: 6px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            background: #6c63ff;
            color: white;
            border: none;
            padding: 10px;
            width: 100%;
            border-radius: 5px;
            cursor: pointer;
        }

        /* SUMMARY */
        .summary {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .card {
            width: 32%;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
        }

        .income { background: #e8f5e9; color: green; }
        .expense { background: #fdecea; color: red; }
        .balance { background: #e3f2fd; color: #1565c0; }

        /* TABLE */
        .table-container {
            max-height: 250px;
            overflow-y: auto;
            margin-top: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }

        .table-container thead th {
            position: sticky;
            top: 0;
            background: #fff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .green { color: green; }
        .red { color: red; }
    </style>

</head>

<body>

<div class="container">

    <h2>Financial Filter Report</h2>

    <!-- FILTER FORM -->
    <form method="get">

        <select name="type">
            <option value="">All Types</option>
            <option value="income">Income</option>
            <option value="expense">Expense</option>
        </select>

        <select name="category">
            <option value="">All Categories</option>
            <option>Salary</option>
            <option>Bonus</option>
            <option>Food</option>
            <option>Rent</option>
            <option>Shopping</option>
            <option>Travel</option>
            <option>Other</option>
        </select>

        <input type="date" name="fromDate">
        <input type="date" name="toDate">

        <input type="text" name="desc" placeholder="Search Description">

        <button type="submit">Apply Filter</button>

    </form>

    <%
        String type = request.getParameter("type");
        String category = request.getParameter("category");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String desc = request.getParameter("desc");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/finance_db",
                "root",
                "12345678"
        );

        String query = "SELECT * FROM transactions WHERE 1=1";

        if(type != null && !type.equals("")){
            query += " AND type='" + type + "'";
        }
        if(category != null && !category.equals("")){
            query += " AND category='" + category + "'";
        }
        if(fromDate != null && !fromDate.equals("")){
            query += " AND date >= '" + fromDate + "'";
        }
        if(toDate != null && !toDate.equals("")){
            query += " AND date <= '" + toDate + "'";
        }
        if(desc != null && !desc.equals("")){
            query += " AND description LIKE '%" + desc + "%'";
        }

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(query);

        int totalIncome = 0;
        int totalExpense = 0;
    %>

    <!-- TABLE -->
    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Date</th>
                <th>Description</th>
                <th>Category</th>
                <th>Amount</th>
            </tr>
            </thead>

            <tbody>

            <%
                boolean hasData = false;

                while(rs.next()){
                    hasData = true;

                    int amt = rs.getInt("amount");
                    String t = rs.getString("type");

                    if(t.equals("income")){
                        totalIncome += amt;
                    } else {
                        totalExpense += amt;
                    }
            %>

            <tr>
                <td><%= rs.getDate("date") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= rs.getString("category") %></td>
                <td class="<%= t.equals("income") ? "green" : "red" %>">
                    &#8377;<%= amt %>
                </td>
            </tr>

            <%
                }

                if(!hasData){
            %>
            <tr>
                <td colspan="4">No records found</td>
            </tr>
            <%
                }
            %>

            </tbody>
        </table>
    </div>

    <%
        int balance = totalIncome - totalExpense;
    %>

    <!-- SUMMARY (BALANCE SHEET STYLE) -->
    <div class="summary">
        <div class="card income">
            Income <br> &#8377;<%= totalIncome %>
        </div>
        <div class="card expense">
            Expense <br> &#8377;<%= totalExpense %>
        </div>
        <div class="card balance">
            Balance <br> &#8377;<%= balance %>
        </div>
    </div>

    <a href="index.jsp">
        <button style="margin-top:15px;">Back to Dashboard</button>
    </a>

</div>

</body>
</html>
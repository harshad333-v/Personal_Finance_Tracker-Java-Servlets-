<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    int income = 0;
    int expense = 0;

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/finance_db",
            "root",
            "12345678"
    );

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM transactions");

    while(rs.next()){
        if(rs.getString("type").equals("income")){
            income += rs.getInt("amount");
        } else {
            expense += rs.getInt("amount");
        }
    }

    int balance = income - expense;

// Percentage for bars
    int total = income + expense;
    int incomePercent = 0;
    int expensePercent = 0;

    if(total > 0){
        incomePercent = (income * 100) / total;
        expensePercent = (expense * 100) / total;
    }
%>

<html>
<head>
    <title>Financial Report</title>
    <meta charset="UTF-8">

    <style>
        body {
            font-family: Arial;
            background: #f0f2f5;
        }

        .container {
            width: 500px;
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

        .card {
            padding: 15px;
            margin: 10px 0;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
        }

        .income {
            background: #e8f5e9;
            color: green;
        }

        .expense {
            background: #fdecea;
            color: red;
        }

        .balance {
            background: #e3f2fd;
            color: #1565c0;
        }

        .bar-container {
            width: 100%;
            background: #eee;
            border-radius: 10px;
            margin: 10px 0;
        }

        .bar {
            height: 20px;
            border-radius: 10px;
        }

        .income-bar {
            background: #4CAF50;
        }

        .expense-bar {
            background: #f44336;
        }

        button {
            margin-top: 15px;
            padding: 10px;
            width: 100%;
            background: #6c63ff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>

</head>

<body>

<div class="container">

    <h2>Financial Report</h2>

    <!-- Cards -->
    <div class="card income">
        Total Income: &#8377;<%= income %>
    </div>

    <div class="card expense">
        Total Expense: &#8377;<%= expense %>
    </div>

    <div class="card balance">
        Balance: &#8377;<%= balance %>
    </div>

    <!-- Bars -->
    <h3>Income vs Expense</h3>

    <p>Income</p>
    <div class="bar-container">
        <div class="bar income-bar" style="width:<%= incomePercent %>%"></div>
    </div>

    <p>Expense</p>
    <div class="bar-container">
        <div class="bar expense-bar" style="width:<%= expensePercent %>%"></div>
    </div>

    <!-- Back -->
    <a href="index.jsp">
        <button>Back to Dashboard</button>
    </a>

</div>

</body>
</html>
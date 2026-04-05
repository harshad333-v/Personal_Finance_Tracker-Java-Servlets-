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

// Calculate totals
    Statement st1 = con.createStatement();
    ResultSet rs1 = st1.executeQuery("SELECT * FROM transactions");

    while(rs1.next()){
        if(rs1.getString("type").equals("income")){
            income += rs1.getInt("amount");
        } else {
            expense += rs1.getInt("amount");
        }
    }

    int balance = income - expense;

// Transaction list
    Statement st2 = con.createStatement();
    ResultSet rs2 = st2.executeQuery("SELECT * FROM transactions ORDER BY date DESC");
%>

<html>
<head>
    <title>Personal Finance Tracker</title>
    <meta charset="UTF-8">

    <style>

        body {
            font-family: Arial;
            background: #F5E9D8;
        }

        .container {
            width: 600px;
            margin: 40px auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            color: #3E2C23;
        }

        .balance {
            text-align: center;
            margin: 20px 0;
        }

        .cards {
            display: flex;
            justify-content: space-between;
        }

        .card {
            width: 45%;
            padding: 15px;
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

        form input, form select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            background: #2FA4D7;
            color: white;
            border: none;
            padding: 10px;
            width: 100%;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #E76F2E;
        }

        .top-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .top-buttons a {
            flex: 1;
        }

        /* SCROLL TABLE */
        .table-container {
            max-height: 250px;
            overflow-y: auto;
            margin-top: 10px;
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

    <h1>Personal Finance Tracker</h1>

    <!-- Navigation -->
    <div class="top-buttons">
        <a href="filter.jsp"><button>Filter</button></a>
        <a href="report.jsp"><button>Report</button></a>
    </div>

    <!-- Balance -->
    <div class="balance">
        <h3>Your Balance</h3>
        <h2>&#8377;<%= balance %></h2>
    </div>

    <!-- Cards -->
    <div class="cards">
        <div class="card income">
            Income <br> &#8377;<%= income %>
        </div>

        <div class="card expense">
            Expense <br> &#8377;<%= expense %>
        </div>
    </div>

    <!-- Add Transaction -->
    <h3>Add Transaction</h3>

    <form action="addTransaction.jsp" method="post">

        <select name="type" id="type" onchange="updateCategory()" required>
            <option value="">Select Type</option>
            <option value="income">Income</option>
            <option value="expense">Expense</option>
        </select>

        <select name="category" id="category" required>
            <option value="">Select Category</option>
        </select>

        <input type="text" name="description" placeholder="Description" required>

        <input type="number" name="amount" placeholder="Amount" required>

        <input type="date" name="date" id="date" required>

        <button type="submit">Add Transaction</button>

    </form>

    <!-- Transaction Table -->
    <h3>Transaction History</h3>

    <div class="table-container">

        <table>
            <thead>
            <tr>
                <th>Date</th>
                <th>Description</th>
                <th>Category</th>
                <th>Amount</th>
                <th>Action</th>
            </tr>
            </thead>

            <tbody>

            <%
                while(rs2.next()){
            %>

            <tr>
                <td><%= rs2.getDate("date") %></td>
                <td><%= rs2.getString("description") %></td>
                <td><%= rs2.getString("category") %></td>

                <td class="<%= rs2.getString("type").equals("income") ? "green" : "red" %>">
                    &#8377;<%= rs2.getInt("amount") %>
                </td>

                <td>
                    <a href="edit.jsp?id=<%= rs2.getInt("id") %>">
                        <button style="padding:5px;">Edit</button>
                    </a>
                </td>
            </tr>

            <%
                }
            %>

            </tbody>
        </table>

    </div>

</div>

<!-- JAVASCRIPT -->
<script>

    // Dynamic category
    function updateCategory() {
        let type = document.getElementById("type").value;
        let category = document.getElementById("category");

        category.innerHTML = "<option value=''>Select Category</option>";

        if (type === "income") {
            category.innerHTML += "<option>Salary</option>";
            category.innerHTML += "<option>Bonus</option>";
            category.innerHTML += "<option>Other</option>";
        } else if (type === "expense") {
            category.innerHTML += "<option>Food</option>";
            category.innerHTML += "<option>Rent</option>";
            category.innerHTML += "<option>Shopping</option>";
            category.innerHTML += "<option>Travel</option>";
            category.innerHTML += "<option>Other</option>";
        }
    }

    // Auto date + restrict future
    window.onload = function() {
        let today = new Date().toISOString().split('T')[0];
        let dateInput = document.getElementById("date");

        dateInput.value = today;
        dateInput.setAttribute("max", today);
    };

</script>

</body>
</html>
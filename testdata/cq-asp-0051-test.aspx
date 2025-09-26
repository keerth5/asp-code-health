<%@ Page Language="VB" %>
<html>
<head>
    <title>SQL Injection Vulnerability Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: SQL Injection vulnerabilities - string concatenation with user input
        
        Sub BadSQLInjectionExamples()
            ' BAD: Command text with string concatenation
            Dim userId As String = Request.Form("userId")
            Dim userName As String = txtUserName.Text
            Dim searchTerm As String = Request.QueryString("search")
            
            ' BAD: Direct concatenation in CommandText
            Dim sql1 As String = "SELECT * FROM Users WHERE UserId = '" + userId + "'"
            Dim sql2 As String = "SELECT * FROM Products WHERE Name LIKE '%" + searchTerm + "%'"
            Dim query As String = "DELETE FROM Orders WHERE CustomerId = " + Request.Form("customerId")
            
            ' BAD: CommandText assignment with concatenation
            command.CommandText = "SELECT * FROM Users WHERE Name = '" + userName ' Bad: SQL injection
            cmd.CommandText = "INSERT INTO Logs VALUES ('" + Request.Form("message") + "')" ' Bad: SQL injection
            
            ' BAD: Execute methods with concatenated strings
            cmd.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE Email = '" + Request.Form("email") + "'") ' Bad: SQL injection
            command.ExecuteNonQuery("UPDATE Users SET Status = 'Active' WHERE Id = " + userId) ' Bad: SQL injection
            db.Execute("DELETE FROM Sessions WHERE UserId = " + Session("UserId").ToString()) ' Bad: SQL injection
            
            ' BAD: SQL statements with direct concatenation
            Dim selectQuery = "SELECT * FROM Customers WHERE City = '" + Request.QueryString("city") + "'"
            Dim insertQuery = "INSERT INTO Orders (CustomerId, Total) VALUES (" + customerId + ", " + total + ")"
            Dim updateQuery = "UPDATE Products SET Price = " + newPrice + " WHERE Id = " + Request.Form("productId")
            Dim deleteQuery = "DELETE FROM Users WHERE Username = '" + txtUsername.Text + "'"
        End Sub
        
        Sub MoreBadSQLExamples()
            ' BAD: Various SQL injection patterns
            Dim userInput As String = Request.Form("input")
            Dim sessionValue As String = Session("value").ToString()
            
            ' BAD: Different SQL operations with concatenation
            ExecuteQuery("SELECT * FROM Orders WHERE Status = '" + userInput + "'") ' Bad: SQL injection
            RunCommand("INSERT INTO Audit VALUES ('" + sessionValue + "', GETDATE())") ' Bad: SQL injection
            
            ' BAD: Complex queries with multiple concatenations
            Dim complexQuery As String = "SELECT u.Name, o.Total FROM Users u " +
                                        "JOIN Orders o ON u.Id = o.UserId " +
                                        "WHERE u.Email = '" + Request.Form("email") + "' " +
                                        "AND o.Date > '" + Request.QueryString("startDate") + "'"
        End Sub
        
        ' GOOD: Parameterized queries to prevent SQL injection
        
        Sub GoodParameterizedQueries()
            ' GOOD: Using parameterized queries
            Dim userId As String = Request.Form("userId")
            Dim userName As String = txtUserName.Text
            
            ' GOOD: Parameterized command
            Dim cmd As New SqlCommand("SELECT * FROM Users WHERE UserId = @userId", connection)
            cmd.Parameters.AddWithValue("@userId", userId)
            
            ' GOOD: Multiple parameters
            Dim query As New SqlCommand("SELECT * FROM Orders WHERE CustomerId = @customerId AND Status = @status", connection)
            query.Parameters.AddWithValue("@customerId", Request.Form("customerId"))
            query.Parameters.AddWithValue("@status", "Active")
            
            ' GOOD: Stored procedures
            Dim spCmd As New SqlCommand("sp_GetUserOrders", connection)
            spCmd.CommandType = CommandType.StoredProcedure
            spCmd.Parameters.AddWithValue("@UserId", userId)
            
            ' GOOD: Using SqlParameter objects
            Dim param As New SqlParameter("@userName", SqlDbType.VarChar, 50)
            param.Value = userName
            cmd.Parameters.Add(param)
        End Sub
        
        Sub GoodInputValidation()
            ' GOOD: Input validation before database operations
            Dim userId As String = Request.Form("userId")
            
            ' Validate input
            If Not Integer.TryParse(userId, Nothing) Then
                Throw New ArgumentException("Invalid user ID")
            End If
            
            ' Use validated input in parameterized query
            Dim cmd As New SqlCommand("SELECT * FROM Users WHERE UserId = @userId", connection)
            cmd.Parameters.AddWithValue("@userId", Convert.ToInt32(userId))
        End Sub
        
        Sub GoodWhitelistValidation()
            ' GOOD: Whitelist validation for dynamic table names
            Dim tableName As String = Request.QueryString("table")
            Dim allowedTables As String() = {"Users", "Orders", "Products", "Categories"}
            
            If Not allowedTables.Contains(tableName) Then
                Throw New ArgumentException("Invalid table name")
            End If
            
            ' Safe to use in query since it's validated against whitelist
            Dim query As String = "SELECT COUNT(*) FROM " + tableName
            Dim cmd As New SqlCommand(query, connection)
        End Sub
        
        Sub GoodEscapingAndEncoding()
            ' GOOD: Proper escaping when parameters aren't possible
            Dim userInput As String = Request.Form("input")
            
            ' Escape single quotes
            userInput = userInput.Replace("'", "''")
            
            ' Additional validation
            If userInput.Contains("--") OrElse userInput.Contains(";") Then
                Throw New ArgumentException("Invalid input detected")
            End If
            
            ' Use escaped input (though parameterized queries are still preferred)
            Dim query As String = "SELECT * FROM Logs WHERE Message = '" + userInput + "'"
        End Sub
        
        ' Helper methods and fields
        Private connection As SqlConnection
        Private command As SqlCommand
        Private cmd As SqlCommand
        Private db As Object
        Private txtUserName As TextBox
        Private txtUsername As TextBox
        Private customerId As String = "1"
        Private total As String = "100.00"
        Private newPrice As String = "50.00"
        
        Sub ExecuteQuery(query As String)
        End Sub
        
        Sub RunCommand(command As String)
        End Sub
    </script>
</body>
</html>

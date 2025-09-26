<%@ Page Language="VB" %>
<html>
<head>
    <title>Hardcoded String Values Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Hardcoded string values
        Sub BadHardcodedStringsMethod()
            Response.Write("This is a very long hardcoded message that should be in a resource file")
            Echo("Another long hardcoded string that makes localization difficult and increases maintenance")
            
            Dim connectionString As String = "Server=localhost;Database=MyDB;User=admin;Password=secret123;"
            Dim dataSource As String = "Data Source=192.168.1.100;Initial Catalog=ProductionDB;"
            Dim server As String = "Server=prod-server-01.company.com;Integrated Security=true;"
            
            Dim sqlQuery As String = "SELECT u.id, u.name, u.email, u.created_date FROM users u WHERE u.active = 1 AND u.department = 'IT'"
            Dim insertQuery As String = "INSERT INTO products (name, price, category, description) VALUES ('Sample Product', 99.99, 'Electronics', 'A sample product')"
            Dim updateQuery As String = "UPDATE customers SET status = 'active', last_login = GETDATE() WHERE customer_id = 12345"
            Dim deleteQuery As String = "DELETE FROM temp_data WHERE created_date < DATEADD(day, -30, GETDATE()) AND processed = 1"
        End Sub
        
        ' GOOD: Using constants and resource files
        Const SHORT_MESSAGE As String = "OK"
        Const ERROR_CODE As String = "ERR001"
        
        Sub GoodResourceUsageMethod()
            Response.Write(Resources.Messages.WelcomeMessage)
            Echo(GetLocalizedString("GREETING_MESSAGE"))
            
            Dim connectionString As String = ConfigurationManager.ConnectionStrings("DefaultConnection").ConnectionString
            Dim dataSource As String = GetConnectionString()
            
            Dim sqlQuery As String = "SELECT * FROM users WHERE id = @userId"
            Dim simpleQuery As String = "SELECT COUNT(*) FROM products"
            
            ' Short strings are acceptable
            Response.Write("OK")
            Response.Write("Error")
            Response.Write("Success")
        End Sub
        
        Function GetConnectionString() As String
            Return ConfigurationManager.AppSettings("DatabaseConnection")
        End Function
        
        Function GetLocalizedString(key As String) As String
            Return ResourceManager.GetString(key)
        End Function
    </script>
</body>
</html>

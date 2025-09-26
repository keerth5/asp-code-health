<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Error Handling Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Database operations without error handling
        Sub BadDatabaseMethod()
            Dim connection As New SqlConnection("connection string")
            Dim command As New SqlCommand("SELECT * FROM users", connection)
            connection.Open()
            Dim result = command.ExecuteReader()
            ' No try/catch or On Error handling
        End Sub
        
        Function BadSqlFunction() As DataSet
            Dim adapter As New SqlDataAdapter("SELECT * FROM products", "connection")
            Dim dataset As New DataSet()
            adapter.Fill(dataset)
            Return dataset
            ' Missing error handling for database operations
        End Function
        
        ' BAD: File operations without error handling
        Sub BadFileMethod()
            Dim reader As New StreamReader("C:\temp\file.txt")
            Dim content As String = reader.ReadToEnd()
            reader.Close()
            ' No error handling for file operations
        End Sub
        
        Function BadFileStreamFunction() As String
            Dim fileStream As New FileStream("C:\data\log.txt", FileMode.Open)
            Dim streamReader As New StreamReader(fileStream)
            Dim result As String = streamReader.ReadToEnd()
            streamReader.Close()
            fileStream.Close()
            Return result
            ' Missing error handling
        End Function
        
        ' BAD: Response operations without error handling
        Sub BadResponseMethod()
            Response.Redirect("http://example.com/page.aspx")
            ' No error handling for redirect
        End Sub
        
        Sub BadServerTransferMethod()
            Server.Transfer("AnotherPage.aspx")
            ' Missing error handling
        End Sub
        
        ' GOOD: Methods with proper error handling
        Sub GoodDatabaseMethodWithTry()
            Try
                Dim connection As New SqlConnection("connection string")
                Dim command As New SqlCommand("SELECT * FROM users", connection)
                connection.Open()
                Dim result = command.ExecuteReader()
            Catch ex As Exception
                Response.Write("Database error: " & ex.Message)
            End Try
        End Sub
        
        Sub GoodDatabaseMethodWithOnError()
            On Error GoTo ErrorHandler
            Dim connection As New SqlConnection("connection string")
            connection.Open()
            Exit Sub
            
ErrorHandler:
            Response.Write("Error occurred")
        End Sub
        
        Sub GoodFileMethodWithTry()
            Try
                Dim reader As New StreamReader("C:\temp\file.txt")
                Dim content As String = reader.ReadToEnd()
                reader.Close()
            Catch ex As Exception
                Response.Write("File error: " & ex.Message)
            End Try
        End Sub
        
        Sub GoodResponseMethodWithTry()
            Try
                Response.Redirect("http://example.com/page.aspx")
            Catch ex As Exception
                Response.Write("Redirect error: " & ex.Message)
            End Try
        End Sub
        
        ' GOOD: Methods without risky operations don't need error handling
        Sub GoodSafeMethod()
            Dim message As String = "Hello World"
            Response.Write(message)
        End Sub
    </script>
</body>
</html>

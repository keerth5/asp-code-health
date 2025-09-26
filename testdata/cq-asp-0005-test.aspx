<%@ Page Language="VB" %>
<html>
<head>
    <title>God Class Anti-Pattern Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: God class with manager pattern
        Public Class BadUserManager
            Sub CreateUser()
            End Sub
            
            Sub UpdateUser()
            End Sub
            
            Sub DeleteUser()
            End Sub
            
            Function ValidateUser() As Boolean
                Return True
            End Function
            
            Function AuthenticateUser() As Boolean
                Return True
            End Function
            
            Sub SendEmail()
            End Sub
            
            Sub LogActivity()
            End Sub
            
            Function GenerateReport() As String
                Return ""
            End Function
            
            Sub BackupData()
            End Sub
            
            Sub RestoreData()
            End Sub
            
            Function CalculateMetrics() As Double
                Return 0
            End Function
            
            Sub ProcessPayments()
            End Sub
            
            Sub HandleNotifications()
            End Sub
            
            Function ExportData() As String
                Return ""
            End Function
            
            Sub ImportData()
            End Sub
            
            Function GenerateReports() As String
                Return ""
            End Function
        End Class
        
        ' BAD: God class with multiple responsibilities
        Public Class BadSystemController
            ' Database operations
            Sub ConnectDatabase()
            End Sub
            
            Function ExecuteQuery() As DataSet
                Return Nothing
            End Function
            
            ' File operations  
            Sub ReadFile()
            End Sub
            
            Sub WriteFile()
            End Sub
            
            ' Email operations
            Sub SendEmail()
            End Sub
            
            Sub ProcessEmailQueue()
            End Sub
            
            ' XML operations
            Function ParseXml() As XmlDocument
                Return Nothing
            End Function
            
            Sub GenerateXml()
            End Sub
            
            ' JSON operations
            Function ParseJson() As Object
                Return Nothing
            End Function
            
            Sub GenerateJson()
            End Sub
            
            ' HTTP operations
            Function MakeHttpRequest() As String
                Return ""
            End Function
            
            Sub ProcessHttpResponse()
            End Sub
            
            ' Additional methods
            Sub LogErrors()
            End Sub
            
            Sub ValidateInput()
            End Sub
            
            Function CalculateResults() As Double
                Return 0
            End Function
        End Class
        
        ' GOOD: Focused class with single responsibility
        Public Class GoodUserService
            Sub CreateUser()
            End Sub
            
            Sub UpdateUser()
            End Sub
            
            Function GetUser() As Object
                Return Nothing
            End Function
        End Class
    </script>
</body>
</html>

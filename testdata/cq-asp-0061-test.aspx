<%@ Page Language="VB" %>
<html>
<head>
    <title>Null Reference Exception Risk Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Null reference exception risks - using objects without null checks
        
        Sub BadNullReferenceExamples()
            ' BAD: Using object properties/methods without null checks
            Dim userName As String = Request.Form("userName")
            Dim userLength = userName.Length ' Bad: no null check
            Dim userUpper = userName.ToUpper() ' Bad: no null check
            Dim userSub = userName.Substring(0, 3) ' Bad: no null check
            Dim userIndex = userName.IndexOf("@") ' Bad: no null check
            Dim userContains = userName.Contains("test") ' Bad: no null check
            
            ' BAD: Session/Request/Application objects without checks
            Dim sessionValue = Session("UserData").ToString() ' Bad: no null check
            Dim requestParam = Request.QueryString("param").ToLower() ' Bad: no null check
            Dim appSetting = Application("Setting").ToUpper() ' Bad: no null check
            
            ' BAD: Array/Collection access without null checks
            Dim users As String() = GetUserList()
            Dim firstUser = users(0).Length ' Bad: no null check for array element
            Dim userInfo = users(1).ToUpper() ' Bad: no null check for array element
            
            ' BAD: Object method calls without validation
            Dim customer As Customer = GetCustomer()
            Dim customerName = customer.Name.ToString() ' Bad: no null check
            Dim customerEmail = customer.Email.ToLower() ' Bad: no null check
        End Sub
        
        Sub MoreBadNullExamples()
            ' BAD: Chained method calls without null checks
            Dim result = GetData().GetValue().ToString() ' Bad: multiple potential null references
            Dim processed = ProcessData().Result.ToUpper() ' Bad: chained calls without checks
            
            ' BAD: Collection operations without null checks
            Dim items As List(Of String) = GetItems()
            Dim itemCount = items.Count ' Bad: no null check
            Dim firstItem = items(0).Length ' Bad: no null check
            
            ' BAD: Property access without validation
            Dim config As Configuration = GetConfiguration()
            Dim dbConnection = config.ConnectionString.Length ' Bad: no null check
            Dim serverName = config.ServerName.ToUpper() ' Bad: no null check
        End Sub
        
        ' GOOD: Proper null checks before using objects
        
        Sub GoodNullCheckExamples()
            ' GOOD: Null checks before using string methods
            Dim userName As String = Request.Form("userName")
            If userName IsNot Nothing Then
                Dim userLength = userName.Length ' Good: null check performed
                Dim userUpper = userName.ToUpper() ' Good: null check performed
                Dim userSub = userName.Substring(0, 3) ' Good: null check performed
            End If
            
            ' GOOD: Alternative null check syntax
            If userName <> Nothing Then
                Dim userIndex = userName.IndexOf("@") ' Good: null check performed
                Dim userContains = userName.Contains("test") ' Good: null check performed
            End If
            
            ' GOOD: C# style null checks
            If userName != Nothing Then
                Dim result = userName.ToLower() ' Good: null check performed
            End If
        End Sub
        
        Sub GoodSessionAndRequestChecks()
            ' GOOD: Session/Request/Application with null checks
            If Session("UserData") IsNot Nothing Then
                Dim sessionValue = Session("UserData").ToString() ' Good: null check performed
            End If
            
            If Request.QueryString("param") IsNot Nothing Then
                Dim requestParam = Request.QueryString("param").ToLower() ' Good: null check performed
            End If
            
            If Application("Setting") IsNot Nothing Then
                Dim appSetting = Application("Setting").ToUpper() ' Good: null check performed
            End If
        End Sub
        
        Sub GoodArrayAndObjectChecks()
            ' GOOD: Array access with null checks
            Dim users As String() = GetUserList()
            If users IsNot Nothing AndAlso users.Length > 0 Then
                If users(0) IsNot Nothing Then
                    Dim firstUser = users(0).Length ' Good: null check performed
                End If
                
                If users(1) IsNot Nothing Then
                    Dim userInfo = users(1).ToUpper() ' Good: null check performed
                End If
            End If
            
            ' GOOD: Object method calls with validation
            Dim customer As Customer = GetCustomer()
            If customer IsNot Nothing Then
                If customer.Name IsNot Nothing Then
                    Dim customerName = customer.Name.ToString() ' Good: null check performed
                End If
                
                If customer.Email IsNot Nothing Then
                    Dim customerEmail = customer.Email.ToLower() ' Good: null check performed
                End If
            End If
        End Sub
        
        Sub GoodChainedCallsWithChecks()
            ' GOOD: Defensive programming for chained calls
            Dim data = GetData()
            If data IsNot Nothing Then
                Dim value = data.GetValue()
                If value IsNot Nothing Then
                    Dim result = value.ToString() ' Good: each step checked
                End If
            End If
            
            ' GOOD: Collection operations with null checks
            Dim items As List(Of String) = GetItems()
            If items IsNot Nothing Then
                Dim itemCount = items.Count ' Good: null check performed
                
                If items.Count > 0 AndAlso items(0) IsNot Nothing Then
                    Dim firstItem = items(0).Length ' Good: null check performed
                End If
            End If
        End Sub
        
        Sub GoodNullableAndHasValueChecks()
            ' GOOD: Using HasValue for nullable types
            Dim nullableInt As Integer? = GetNullableValue()
            If nullableInt.HasValue Then
                Dim value = nullableInt.Value ' Good: HasValue check
            End If
            
            ' GOOD: Using IsNull function
            If Not IsNull(Session("Data")) Then
                Dim sessionData = Session("Data").ToString() ' Good: IsNull check
            End If
        End Sub
        
        Sub GoodTryPatternUsage()
            ' GOOD: Using try-catch for null reference protection
            Try
                Dim result = GetRiskyData().ProcessValue().ToString() ' Good: protected by try-catch
            Catch ex As NullReferenceException
                ' Handle null reference appropriately
                LogError("Null reference encountered")
            End Try
        End Sub
        
        ' Helper methods and classes
        Function GetUserList() As String()
            Return New String() {"user1", "user2", Nothing}
        End Function
        
        Function GetCustomer() As Customer
            Return New Customer()
        End Function
        
        Function GetData() As DataObject
            Return New DataObject()
        End Function
        
        Function ProcessData() As ProcessResult
            Return New ProcessResult()
        End Function
        
        Function GetItems() As List(Of String)
            Return New List(Of String)()
        End Function
        
        Function GetConfiguration() As Configuration
            Return New Configuration()
        End Function
        
        Function GetNullableValue() As Integer?
            Return Nothing
        End Function
        
        Function GetRiskyData() As RiskyDataObject
            Return New RiskyDataObject()
        End Function
        
        Sub LogError(message As String)
        End Sub
        
        ' Helper classes
        Public Class Customer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Public Class DataObject
            Public Function GetValue() As ValueObject
                Return New ValueObject()
            End Function
        End Class
        
        Public Class ValueObject
            Public Overrides Function ToString() As String
                Return "Value"
            End Function
        End Class
        
        Public Class ProcessResult
            Public Property Result As ResultObject
        End Class
        
        Public Class ResultObject
            Public Function ToUpper() As String
                Return "RESULT"
            End Function
        End Class
        
        Public Class Configuration
            Public Property ConnectionString As String
            Public Property ServerName As String
        End Class
        
        Public Class RiskyDataObject
            Public Function ProcessValue() As ProcessedValue
                Return New ProcessedValue()
            End Function
        End Class
        
        Public Class ProcessedValue
            Public Overrides Function ToString() As String
                Return "Processed"
            End Function
        End Class
    </script>
</body>
</html>

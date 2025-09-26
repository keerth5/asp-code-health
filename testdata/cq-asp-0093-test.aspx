<%@ Page Language="VB" %>
<html>
<head>
    <title>Violation of DRY Principle Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Violation of DRY principle - duplicated logic throughout codebase
        
        ' BAD: Repeated null checks and exception throwing
        Sub BadValidateUser(user As User)
            If user Is Nothing Then
                Throw New ArgumentNullException("user", "User cannot be null")
            End If
            
            If user.Name Is Nothing Then
                Throw New ArgumentNullException("user.Name", "User name cannot be null")
            End If
            
            If user.Email Is Nothing Then
                Throw New ArgumentNullException("user.Email", "User email cannot be null")
            End If
        End Sub
        
        Sub BadValidateOrder(order As Order)
            If order Is Nothing Then
                Throw New ArgumentNullException("order", "Order cannot be null")
            End If
            
            If order.Customer Is Nothing Then
                Throw New ArgumentNullException("order.Customer", "Order customer cannot be null")
            End If
            
            If order.Items Is Nothing Then
                Throw New ArgumentNullException("order.Items", "Order items cannot be null")
            End If
        End Sub
        
        ' BAD: Repeated request/response handling
        Sub BadProcessUserRequest()
            Dim userId = Request.QueryString("userId")
            If String.IsNullOrEmpty(userId) Then
                Response.Write("Error: User ID required")
                Return
            End If
            
            Dim user = GetUser(userId)
            Response.Write($"User: {user.Name}")
        End Sub
        
        Sub BadProcessOrderRequest()
            Dim orderId = Request.QueryString("orderId")
            If String.IsNullOrEmpty(orderId) Then
                Response.Write("Error: Order ID required")
                Return
            End If
            
            Dim order = GetOrder(orderId)
            Response.Write($"Order: {order.Id}")
        End Sub
        
        Sub BadProcessProductRequest()
            Dim productId = Request.QueryString("productId")
            If String.IsNullOrEmpty(productId) Then
                Response.Write("Error: Product ID required")
                Return
            End If
            
            Dim product = GetProduct(productId)
            Response.Write($"Product: {product.Name}")
        End Sub
        
        ' BAD: Repeated connection string patterns
        Function BadGetUserData() As DataTable
            Dim connectionString = "Server=localhost;Database=UserDB;Trusted_Connection=true"
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim command As New SqlCommand("SELECT * FROM Users", connection)
                Dim adapter As New SqlDataAdapter(command)
                Dim dataTable As New DataTable()
                adapter.Fill(dataTable)
                Return dataTable
            End Using
        End Function
        
        Function BadGetOrderData() As DataTable
            Dim connectionString = "Server=localhost;Database=OrderDB;Trusted_Connection=true"
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim command As New SqlCommand("SELECT * FROM Orders", connection)
                Dim adapter As New SqlDataAdapter(command)
                Dim dataTable As New DataTable()
                adapter.Fill(dataTable)
                Return dataTable
            End Using
        End Function
        
        Function BadGetProductData() As DataTable
            Dim connectionString = "Server=localhost;Database=ProductDB;Trusted_Connection=true"
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim command As New SqlCommand("SELECT * FROM Products", connection)
                Dim adapter As New SqlDataAdapter(command)
                Dim dataTable As New DataTable()
                adapter.Fill(dataTable)
                Return dataTable
            End Using
        End Function
        
        ' BAD: Repeated validation patterns
        Function BadValidateEmail(email As String) As Boolean
            If String.IsNullOrEmpty(email) Then Return False
            If Not email.Contains("@") Then Return False
            If email.Length < 5 Then Return False
            If email.Length > 100 Then Return False
            Return True
        End Function
        
        Function BadValidatePhone(phone As String) As Boolean
            If String.IsNullOrEmpty(phone) Then Return False
            If phone.Length < 10 Then Return False
            If phone.Length > 15 Then Return False
            Return True
        End Function
        
        Function BadValidateName(name As String) As Boolean
            If String.IsNullOrEmpty(name) Then Return False
            If name.Length < 2 Then Return False
            If name.Length > 50 Then Return False
            Return True
        End Function
        
        ' BAD: Repeated error handling patterns
        Sub BadHandleUserError(ex As Exception)
            LogError("User Error: " & ex.Message)
            Response.Write("An error occurred while processing user data")
            Response.StatusCode = 500
        End Sub
        
        Sub BadHandleOrderError(ex As Exception)
            LogError("Order Error: " & ex.Message)
            Response.Write("An error occurred while processing order data")
            Response.StatusCode = 500
        End Sub
        
        Sub BadHandleProductError(ex As Exception)
            LogError("Product Error: " & ex.Message)
            Response.Write("An error occurred while processing product data")
            Response.StatusCode = 500
        End Sub
        
        ' BAD: Repeated form validation
        Function BadValidateUserForm() As Boolean
            If String.IsNullOrEmpty(Request.Form("firstName")) Then
                Response.Write("First name is required")
                Return False
            End If
            If String.IsNullOrEmpty(Request.Form("lastName")) Then
                Response.Write("Last name is required")
                Return False
            End If
            If String.IsNullOrEmpty(Request.Form("email")) Then
                Response.Write("Email is required")
                Return False
            End If
            Return True
        End Function
        
        Function BadValidateOrderForm() As Boolean
            If String.IsNullOrEmpty(Request.Form("customerId")) Then
                Response.Write("Customer ID is required")
                Return False
            End If
            If String.IsNullOrEmpty(Request.Form("productId")) Then
                Response.Write("Product ID is required")
                Return False
            End If
            If String.IsNullOrEmpty(Request.Form("quantity")) Then
                Response.Write("Quantity is required")
                Return False
            End If
            Return True
        End Function
        
        ' GOOD: DRY principle applied with reusable methods
        
        ' GOOD: Generic null validation
        Sub GoodValidateNotNull(obj As Object, paramName As String)
            If obj Is Nothing Then
                Throw New ArgumentNullException(paramName, $"{paramName} cannot be null")
            End If
        End Sub
        
        ' GOOD: Centralized validation
        Sub GoodValidateUser(user As User)
            GoodValidateNotNull(user, "user")
            GoodValidateNotNull(user.Name, "user.Name")
            GoodValidateNotNull(user.Email, "user.Email")
        End Sub
        
        Sub GoodValidateOrder(order As Order)
            GoodValidateNotNull(order, "order")
            GoodValidateNotNull(order.Customer, "order.Customer")
            GoodValidateNotNull(order.Items, "order.Items")
        End Sub
        
        ' GOOD: Generic request processing
        Function GoodProcessEntityRequest(Of T)(entityName As String, getId As Func(Of String, T), formatEntity As Func(Of T, String)) As String
            Dim id = Request.QueryString($"{entityName}Id")
            If String.IsNullOrEmpty(id) Then
                Return $"Error: {entityName} ID required"
            End If
            
            Try
                Dim entity = getId(id)
                Return formatEntity(entity)
            Catch ex As Exception
                Return $"Error processing {entityName}: {ex.Message}"
            End Try
        End Function
        
        ' GOOD: Centralized database operations
        Function GoodExecuteQuery(connectionString As String, query As String) As DataTable
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim command As New SqlCommand(query, connection)
                Dim adapter As New SqlDataAdapter(command)
                Dim dataTable As New DataTable()
                adapter.Fill(dataTable)
                Return dataTable
            End Using
        End Function
        
        Function GoodGetUserData() As DataTable
            Return GoodExecuteQuery(GetConnectionString("UserDB"), "SELECT * FROM Users")
        End Function
        
        Function GoodGetOrderData() As DataTable
            Return GoodExecuteQuery(GetConnectionString("OrderDB"), "SELECT * FROM Orders")
        End Function
        
        Function GoodGetProductData() As DataTable
            Return GoodExecuteQuery(GetConnectionString("ProductDB"), "SELECT * FROM Products")
        End Function
        
        ' GOOD: Generic validation with parameters
        Function GoodValidateStringField(value As String, fieldName As String, minLength As Integer, maxLength As Integer, Optional allowEmpty As Boolean = False) As Boolean
            If String.IsNullOrEmpty(value) Then
                If Not allowEmpty Then
                    Response.Write($"{fieldName} is required")
                    Return False
                End If
                Return True
            End If
            
            If value.Length < minLength Then
                Response.Write($"{fieldName} must be at least {minLength} characters")
                Return False
            End If
            
            If value.Length > maxLength Then
                Response.Write($"{fieldName} cannot exceed {maxLength} characters")
                Return False
            End If
            
            Return True
        End Function
        
        Function GoodValidateEmail(email As String) As Boolean
            If Not GoodValidateStringField(email, "Email", 5, 100) Then Return False
            If Not email.Contains("@") Then
                Response.Write("Email must contain @ symbol")
                Return False
            End If
            Return True
        End Function
        
        Function GoodValidatePhone(phone As String) As Boolean
            Return GoodValidateStringField(phone, "Phone", 10, 15)
        End Function
        
        Function GoodValidateName(name As String) As Boolean
            Return GoodValidateStringField(name, "Name", 2, 50)
        End Function
        
        ' GOOD: Centralized error handling
        Sub GoodHandleError(ex As Exception, context As String)
            LogError($"{context} Error: {ex.Message}")
            Response.Write($"An error occurred while processing {context.ToLower()} data")
            Response.StatusCode = 500
        End Sub
        
        ' GOOD: Generic form validation
        Function GoodValidateRequiredFields(requiredFields As Dictionary(Of String, String)) As Boolean
            For Each field In requiredFields
                If String.IsNullOrEmpty(Request.Form(field.Key)) Then
                    Response.Write($"{field.Value} is required")
                    Return False
                End If
            Next
            Return True
        End Function
        
        Function GoodValidateUserForm() As Boolean
            Dim requiredFields As New Dictionary(Of String, String) From {
                {"firstName", "First name"},
                {"lastName", "Last name"},
                {"email", "Email"}
            }
            Return GoodValidateRequiredFields(requiredFields)
        End Function
        
        Function GoodValidateOrderForm() As Boolean
            Dim requiredFields As New Dictionary(Of String, String) From {
                {"customerId", "Customer ID"},
                {"productId", "Product ID"},
                {"quantity", "Quantity"}
            }
            Return GoodValidateRequiredFields(requiredFields)
        End Function
        
        ' GOOD: Configuration-driven approach
        Class GoodValidationConfig
            Public Property FieldName As String
            Public Property MinLength As Integer
            Public Property MaxLength As Integer
            Public Property Required As Boolean
            Public Property Pattern As String
        End Class
        
        Class GoodValidationEngine
            Private ReadOnly _configs As Dictionary(Of String, GoodValidationConfig)
            
            Public Sub New()
                _configs = New Dictionary(Of String, GoodValidationConfig)()
                InitializeConfigs()
            End Sub
            
            Private Sub InitializeConfigs()
                _configs("email") = New GoodValidationConfig With {
                    .FieldName = "Email",
                    .MinLength = 5,
                    .MaxLength = 100,
                    .Required = True,
                    .Pattern = ".*@.*"
                }
                
                _configs("phone") = New GoodValidationConfig With {
                    .FieldName = "Phone",
                    .MinLength = 10,
                    .MaxLength = 15,
                    .Required = True
                }
                
                _configs("name") = New GoodValidationConfig With {
                    .FieldName = "Name",
                    .MinLength = 2,
                    .MaxLength = 50,
                    .Required = True
                }
            End Sub
            
            Public Function ValidateField(fieldType As String, value As String) As ValidationResult
                If Not _configs.ContainsKey(fieldType) Then
                    Return New ValidationResult With {.IsValid = False, .ErrorMessage = "Unknown field type"}
                End If
                
                Dim config = _configs(fieldType)
                Return ValidateAgainstConfig(value, config)
            End Function
            
            Private Function ValidateAgainstConfig(value As String, config As GoodValidationConfig) As ValidationResult
                If config.Required AndAlso String.IsNullOrEmpty(value) Then
                    Return New ValidationResult With {.IsValid = False, .ErrorMessage = $"{config.FieldName} is required"}
                End If
                
                If Not String.IsNullOrEmpty(value) Then
                    If value.Length < config.MinLength Then
                        Return New ValidationResult With {.IsValid = False, .ErrorMessage = $"{config.FieldName} must be at least {config.MinLength} characters"}
                    End If
                    
                    If value.Length > config.MaxLength Then
                        Return New ValidationResult With {.IsValid = False, .ErrorMessage = $"{config.FieldName} cannot exceed {config.MaxLength} characters"}
                    End If
                    
                    If Not String.IsNullOrEmpty(config.Pattern) AndAlso Not System.Text.RegularExpressions.Regex.IsMatch(value, config.Pattern) Then
                        Return New ValidationResult With {.IsValid = False, .ErrorMessage = $"{config.FieldName} format is invalid"}
                    End If
                End If
                
                Return New ValidationResult With {.IsValid = True}
            End Function
        End Class
        
        ' GOOD: Template method pattern to eliminate duplication
        MustInherit Class GoodDataProcessor
            Public Function ProcessData(id As String) As String
                Try
                    ValidateInput(id)
                    Dim data = RetrieveData(id)
                    Dim result = ProcessSpecificData(data)
                    Return FormatResult(result)
                Catch ex As Exception
                    Return HandleError(ex)
                End Try
            End Function
            
            Protected Overridable Sub ValidateInput(id As String)
                If String.IsNullOrEmpty(id) Then
                    Throw New ArgumentException("ID is required")
                End If
            End Sub
            
            Protected MustOverride Function RetrieveData(id As String) As Object
            Protected MustOverride Function ProcessSpecificData(data As Object) As Object
            Protected MustOverride Function FormatResult(result As Object) As String
            
            Protected Overridable Function HandleError(ex As Exception) As String
                LogError(ex.Message)
                Return "An error occurred during processing"
            End Function
        End Class
        
        Class GoodUserDataProcessor
            Inherits GoodDataProcessor
            
            Protected Overrides Function RetrieveData(id As String) As Object
                Return GetUser(id)
            End Function
            
            Protected Overrides Function ProcessSpecificData(data As Object) As Object
                Dim user = CType(data, User)
                Return New With {user.Name, user.Email}
            End Function
            
            Protected Overrides Function FormatResult(result As Object) As String
                Return $"User: {result.Name} ({result.Email})"
            End Function
        End Class
        
        Class GoodOrderDataProcessor
            Inherits GoodDataProcessor
            
            Protected Overrides Function RetrieveData(id As String) As Object
                Return GetOrder(id)
            End Function
            
            Protected Overrides Function ProcessSpecificData(data As Object) As Object
                Dim order = CType(data, Order)
                Return New With {order.Id, .CustomerName = order.Customer.Name}
            End Function
            
            Protected Overrides Function FormatResult(result As Object) As String
                Return $"Order: {result.Id} for {result.CustomerName}"
            End Function
        End Class
        
        ' Supporting classes
        Class User
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Class Order
            Public Property Id As String
            Public Property Customer As User
            Public Property Items As List(Of Object)
        End Class
        
        Class Product
            Public Property Name As String
        End Class
        
        Class ValidationResult
            Public Property IsValid As Boolean
            Public Property ErrorMessage As String
        End Class
        
        Class SqlConnection
            Implements IDisposable
            
            Public Sub New(connectionString As String)
            End Sub
            
            Public Sub Open()
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
        End Class
        
        Class SqlCommand
            Public Sub New(query As String, connection As SqlConnection)
            End Sub
        End Class
        
        Class SqlDataAdapter
            Public Sub New(command As SqlCommand)
            End Sub
            
            Public Sub Fill(dataTable As DataTable)
            End Sub
        End Class
        
        Class DataTable
        End Class
        
        ' Helper methods
        Function GetUser(userId As String) As User
            Return New User()
        End Function
        
        Function GetOrder(orderId As String) As Order
            Return New Order()
        End Function
        
        Function GetProduct(productId As String) As Product
            Return New Product()
        End Function
        
        Function GetConnectionString(database As String) As String
            Return $"Server=localhost;Database={database};Trusted_Connection=true"
        End Function
        
        Sub LogError(message As String)
        End Sub
    </script>
</body>
</html>

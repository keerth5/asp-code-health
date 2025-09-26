<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Code Contracts Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing code contracts - public methods without proper precondition and postcondition checks
        
        ' BAD: Public method with parameters but no null checks
        Public Function BadCalculateTotal(items As List(Of Item)) As Decimal
            ' No null check for items parameter
            Dim total As Decimal = 0
            For Each item In items
                total += item.Price * item.Quantity
            Next
            Return total
        End Function
        
        ' BAD: Public method with string parameter but no validation
        Public Function BadProcessUserName(userName As String) As String
            ' No null/empty check for userName
            Return userName.ToUpper().Trim()
        End Function
        
        ' BAD: Public method with numeric parameters but no range validation
        Public Function BadCalculateDiscount(orderTotal As Decimal, discountPercent As Double) As Decimal
            ' No validation for negative values or invalid percentages
            Return orderTotal * (discountPercent / 100)
        End Function
        
        ' BAD: Public method with integer parameter but no range check
        Public Sub BadSetUserAge(userId As Integer, age As Integer)
            ' No validation for userId or age range
            UpdateUserAge(userId, age)
        End Sub
        
        ' BAD: Protected method without parameter validation
        Protected Function BadValidateEmail(email As String) As Boolean
            ' No null/empty check for email parameter
            Return email.Contains("@") AndAlso email.Contains(".")
        End Function
        
        ' BAD: Public method with multiple parameters, no validation
        Public Sub BadCreateUser(id As Integer, name As String, email As String, age As Integer)
            ' No parameter validation at all
            Dim user As New User()
            user.Id = id
            user.Name = name
            user.Email = email
            user.Age = age
            SaveUser(user)
        End Sub
        
        ' BAD: Public method with collection parameter, no validation
        Public Function BadProcessOrders(orders As List(Of Order)) As Integer
            ' No null check or empty collection validation
            Dim processed As Integer = 0
            For Each order In orders
                ProcessSingleOrder(order)
                processed += 1
            Next
            Return processed
        End Function
        
        ' BAD: Public method with object parameter, no null check
        Public Sub BadUpdateCustomer(customer As Customer)
            ' No null check for customer object
            customer.LastModified = DateTime.Now
            SaveCustomer(customer)
        End Sub
        
        ' BAD: Public method with decimal parameter, no range validation
        Protected Function BadCalculateInterest(principal As Decimal, rate As Double, years As Integer) As Decimal
            ' No validation for negative values or invalid ranges
            Return principal * rate * years
        End Function
        
        ' BAD: Public method returning object without postcondition
        Public Function BadGetUserById(userId As Integer) As User
            ' No validation that userId is positive
            ' No guarantee about return value (could be null)
            Return LoadUserFromDatabase(userId)
        End Function
        
        ' GOOD: Public methods with proper precondition and postcondition checks
        
        ' GOOD: Public method with comprehensive parameter validation
        Public Function GoodCalculateTotal(items As List(Of Item)) As Decimal
            ' Precondition: Validate input parameters
            If items Is Nothing Then
                Throw New ArgumentNullException(NameOf(items), "Items collection cannot be null.")
            End If
            
            If items.Count = 0 Then
                Throw New ArgumentException("Items collection cannot be empty.", NameOf(items))
            End If
            
            ' Validate each item in the collection
            For Each item In items
                If item Is Nothing Then
                    Throw New ArgumentException("Items collection cannot contain null items.", NameOf(items))
                End If
                If item.Price < 0 Then
                    Throw New ArgumentException("Item price cannot be negative.", NameOf(items))
                End If
                If item.Quantity <= 0 Then
                    Throw New ArgumentException("Item quantity must be positive.", NameOf(items))
                End If
            Next
            
            Dim total As Decimal = 0
            For Each item In items
                total += item.Price * item.Quantity
            Next
            
            ' Postcondition: Ensure result is valid
            If total < 0 Then
                Throw New InvalidOperationException("Calculated total cannot be negative.")
            End If
            
            Return total
        End Function
        
        ' GOOD: Public method with string parameter validation
        Public Function GoodProcessUserName(userName As String) As String
            ' Precondition: Validate string parameter
            If userName Is Nothing Then
                Throw New ArgumentNullException(NameOf(userName), "User name cannot be null.")
            End If
            
            If String.IsNullOrWhiteSpace(userName) Then
                Throw New ArgumentException("User name cannot be empty or whitespace.", NameOf(userName))
            End If
            
            If userName.Length > 50 Then
                Throw New ArgumentException("User name cannot exceed 50 characters.", NameOf(userName))
            End If
            
            Dim result As String = userName.ToUpper().Trim()
            
            ' Postcondition: Ensure result is valid
            If String.IsNullOrEmpty(result) Then
                Throw New InvalidOperationException("Processed user name cannot be empty.")
            End If
            
            Return result
        End Function
        
        ' GOOD: Public method with numeric parameter validation
        Public Function GoodCalculateDiscount(orderTotal As Decimal, discountPercent As Double) As Decimal
            ' Precondition: Validate numeric parameters
            If orderTotal < 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(orderTotal), "Order total cannot be negative.")
            End If
            
            If discountPercent < 0 OrElse discountPercent > 100 Then
                Throw New ArgumentOutOfRangeException(NameOf(discountPercent), "Discount percent must be between 0 and 100.")
            End If
            
            Dim discount As Decimal = orderTotal * (discountPercent / 100)
            
            ' Postcondition: Ensure result is valid
            If discount < 0 OrElse discount > orderTotal Then
                Throw New InvalidOperationException("Calculated discount is invalid.")
            End If
            
            Return discount
        End Function
        
        ' GOOD: Public method with integer parameter validation
        Public Sub GoodSetUserAge(userId As Integer, age As Integer)
            ' Precondition: Validate parameters
            If userId <= 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(userId), "User ID must be positive.")
            End If
            
            If age < 0 OrElse age > 150 Then
                Throw New ArgumentOutOfRangeException(NameOf(age), "Age must be between 0 and 150.")
            End If
            
            ' Verify user exists before updating
            If Not UserExists(userId) Then
                Throw New ArgumentException($"User with ID {userId} does not exist.", NameOf(userId))
            End If
            
            UpdateUserAge(userId, age)
        End Sub
        
        ' GOOD: Protected method with proper validation
        Protected Function GoodValidateEmail(email As String) As Boolean
            ' Precondition: Validate email parameter
            If email Is Nothing Then
                Throw New ArgumentNullException(NameOf(email), "Email cannot be null.")
            End If
            
            If String.IsNullOrWhiteSpace(email) Then
                Throw New ArgumentException("Email cannot be empty or whitespace.", NameOf(email))
            End If
            
            If email.Length > 254 Then ' RFC 5321 limit
                Throw New ArgumentException("Email address is too long.", NameOf(email))
            End If
            
            Dim isValid As Boolean = email.Contains("@") AndAlso email.Contains(".")
            
            ' Additional validation logic could go here
            If isValid Then
                Dim parts() As String = email.Split("@"c)
                isValid = parts.Length = 2 AndAlso 
                         parts(0).Length > 0 AndAlso 
                         parts(1).Length > 0
            End If
            
            Return isValid
        End Function
        
        ' GOOD: Public method with comprehensive parameter validation
        Public Sub GoodCreateUser(id As Integer, name As String, email As String, age As Integer)
            ' Precondition: Validate all parameters
            If id <= 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(id), "User ID must be positive.")
            End If
            
            If name Is Nothing Then
                Throw New ArgumentNullException(NameOf(name), "Name cannot be null.")
            End If
            
            If String.IsNullOrWhiteSpace(name) Then
                Throw New ArgumentException("Name cannot be empty or whitespace.", NameOf(name))
            End If
            
            If name.Length > 100 Then
                Throw New ArgumentException("Name cannot exceed 100 characters.", NameOf(name))
            End If
            
            If Not GoodValidateEmail(email) Then
                Throw New ArgumentException("Email format is invalid.", NameOf(email))
            End If
            
            If age < 0 OrElse age > 150 Then
                Throw New ArgumentOutOfRangeException(NameOf(age), "Age must be between 0 and 150.")
            End If
            
            ' Check if user ID already exists
            If UserExists(id) Then
                Throw New InvalidOperationException($"User with ID {id} already exists.")
            End If
            
            Dim user As New User()
            user.Id = id
            user.Name = name
            user.Email = email
            user.Age = age
            
            SaveUser(user)
            
            ' Postcondition: Verify user was created successfully
            If Not UserExists(id) Then
                Throw New InvalidOperationException("Failed to create user.")
            End If
        End Sub
        
        ' GOOD: Public method with collection validation and postcondition
        Public Function GoodProcessOrders(orders As List(Of Order)) As Integer
            ' Precondition: Validate collection parameter
            If orders Is Nothing Then
                Throw New ArgumentNullException(NameOf(orders), "Orders collection cannot be null.")
            End If
            
            If orders.Count = 0 Then
                Throw New ArgumentException("Orders collection cannot be empty.", NameOf(orders))
            End If
            
            ' Validate each order in the collection
            For i As Integer = 0 To orders.Count - 1
                If orders(i) Is Nothing Then
                    Throw New ArgumentException($"Order at index {i} cannot be null.", NameOf(orders))
                End If
                
                If orders(i).Id <= 0 Then
                    Throw New ArgumentException($"Order at index {i} has invalid ID.", NameOf(orders))
                End If
            Next
            
            Dim processed As Integer = 0
            For Each order In orders
                ProcessSingleOrder(order)
                processed += 1
            Next
            
            ' Postcondition: Ensure all orders were processed
            If processed <> orders.Count Then
                Throw New InvalidOperationException("Not all orders were processed successfully.")
            End If
            
            Return processed
        End Function
        
        ' GOOD: Public method with object parameter validation
        Public Sub GoodUpdateCustomer(customer As Customer)
            ' Precondition: Validate customer object
            If customer Is Nothing Then
                Throw New ArgumentNullException(NameOf(customer), "Customer cannot be null.")
            End If
            
            If customer.Id <= 0 Then
                Throw New ArgumentException("Customer must have a valid ID.", NameOf(customer))
            End If
            
            If String.IsNullOrWhiteSpace(customer.Name) Then
                Throw New ArgumentException("Customer name cannot be empty.", NameOf(customer))
            End If
            
            If Not GoodValidateEmail(customer.Email) Then
                Throw New ArgumentException("Customer email is invalid.", NameOf(customer))
            End If
            
            ' Verify customer exists
            If Not CustomerExists(customer.Id) Then
                Throw New ArgumentException($"Customer with ID {customer.Id} does not exist.", NameOf(customer))
            End If
            
            customer.LastModified = DateTime.Now
            SaveCustomer(customer)
            
            ' Postcondition: Verify update was successful
            Dim updatedCustomer As Customer = LoadCustomerFromDatabase(customer.Id)
            If updatedCustomer Is Nothing OrElse updatedCustomer.LastModified <> customer.LastModified Then
                Throw New InvalidOperationException("Failed to update customer.")
            End If
        End Sub
        
        ' GOOD: Public method with Code Contracts library (if available)
        Public Function GoodCalculateInterest(principal As Decimal, rate As Double, years As Integer) As Decimal
            ' Preconditions using Contract.Requires (conceptual - VB.NET doesn't have built-in contracts)
            ' Contract.Requires(principal >= 0, "Principal must be non-negative")
            ' Contract.Requires(rate >= 0, "Interest rate must be non-negative")  
            ' Contract.Requires(years >= 0, "Years must be non-negative")
            
            ' Manual precondition checks
            If principal < 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(principal), "Principal must be non-negative.")
            End If
            
            If rate < 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(rate), "Interest rate must be non-negative.")
            End If
            
            If years < 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(years), "Years must be non-negative.")
            End If
            
            Dim interest As Decimal = principal * rate * years
            
            ' Postcondition: Ensure result is valid
            ' Contract.Ensures(Contract.Result<Decimal>() >= 0, "Interest must be non-negative")
            If interest < 0 Then
                Throw New InvalidOperationException("Calculated interest cannot be negative.")
            End If
            
            Return interest
        End Function
        
        ' GOOD: Public method with guaranteed non-null return
        Public Function GoodGetUserById(userId As Integer) As User
            ' Precondition: Validate user ID
            If userId <= 0 Then
                Throw New ArgumentOutOfRangeException(NameOf(userId), "User ID must be positive.")
            End If
            
            Dim user As User = LoadUserFromDatabase(userId)
            
            ' Postcondition: Guarantee non-null return or throw exception
            If user Is Nothing Then
                Throw New InvalidOperationException($"User with ID {userId} was not found.")
            End If
            
            ' Additional postcondition checks
            If user.Id <> userId Then
                Throw New InvalidOperationException("Loaded user has incorrect ID.")
            End If
            
            Return user
        End Function
        
        ' Helper methods
        Private Sub UpdateUserAge(userId As Integer, age As Integer)
            ' Update user age in database
        End Sub
        
        Private Sub SaveUser(user As User)
            ' Save user to database
        End Sub
        
        Private Sub ProcessSingleOrder(order As Order)
            ' Process individual order
        End Sub
        
        Private Sub SaveCustomer(customer As Customer)
            ' Save customer to database
        End Sub
        
        Private Function UserExists(userId As Integer) As Boolean
            ' Check if user exists in database
            Return True
        End Function
        
        Private Function CustomerExists(customerId As Integer) As Boolean
            ' Check if customer exists in database
            Return True
        End Function
        
        Private Function LoadUserFromDatabase(userId As Integer) As User
            ' Load user from database
            Return New User() With {.Id = userId, .Name = "Test User", .Email = "test@example.com"}
        End Function
        
        Private Function LoadCustomerFromDatabase(customerId As Integer) As Customer
            ' Load customer from database
            Return New Customer() With {.Id = customerId, .Name = "Test Customer", .Email = "customer@example.com"}
        End Function
        
        ' Supporting classes
        Class Item
            Public Property Price As Decimal
            Public Property Quantity As Integer
        End Class
        
        Class User
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
            Public Property Age As Integer
        End Class
        
        Class Customer
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
            Public Property LastModified As DateTime
        End Class
        
        Class Order
            Public Property Id As Integer
            Public Property CustomerId As Integer
            Public Property Items As List(Of Item)
            Public Property Total As Decimal
        End Class
    </script>
</body>
</html>

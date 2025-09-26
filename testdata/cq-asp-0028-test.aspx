<%@ Page Language="VB" %>
<html>
<head>
    <title>Inefficient LINQ Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inefficient LINQ usage
        Sub BadLinqUsageMethod()
            Dim users = GetUsers()
            
            ' Multiple enumeration - inefficient
            Dim activeUsers = users.Where(Function(u) u.IsActive).Count() ' First enumeration
            Dim adminUsers = users.Where(Function(u) u.IsAdmin).Any() ' Second enumeration
            Dim firstUser = users.Where(Function(u) u.IsActive).First() ' Third enumeration
            
            ' Inefficient count check
            If users.Count() > 0 Then ' Should use Any()
                ProcessUsers(users)
            End If
            
            ' Chaining inefficient operations
            Dim result = users.Where(Function(u) u.IsActive).Select(Function(u) u.Name).Where(Function(n) n.Length > 5).Select(Function(n) n.ToUpper())
            
            Dim products = GetProducts()
            
            ' More inefficient patterns
            Dim expensiveProducts = products.Where(Function(p) p.Price > 100).Count()
            Dim cheapProducts = products.Where(Function(p) p.Price < 50).Any()
            Dim firstExpensive = products.Where(Function(p) p.Price > 100).First()
            
            ' Inefficient ordering
            Dim sortedProducts = products.OrderBy(Function(p) p.Name).Where(Function(p) p.IsAvailable)
        End Sub
        
        Function BadLinqFunction() As Integer
            Dim orders = GetOrders()
            
            ' Multiple enumerations of same collection
            Dim pendingCount = orders.Where(Function(o) o.Status = "Pending").Count()
            Dim completedAny = orders.Where(Function(o) o.Status = "Completed").Any()
            
            Return pendingCount
        End Function
        
        Sub BadCountCheckMethod()
            Dim items = GetItems()
            
            If items.Count() > 0 Then ' Inefficient - should use Any()
                ProcessItems(items)
            End If
            
            If items.Where(Function(i) i.IsValid).Count() > 0 Then ' Very inefficient
                ProcessValidItems(items)
            End If
        End Sub
        
        ' GOOD: Efficient LINQ usage
        Sub GoodLinqUsageMethod()
            Dim users = GetUsers().ToList() ' Materialize once
            
            ' Single enumeration with stored result
            Dim activeUsers = users.Where(Function(u) u.IsActive).ToList()
            Dim activeCount = activeUsers.Count()
            Dim hasAdmins = activeUsers.Any(Function(u) u.IsAdmin)
            Dim firstActive = activeUsers.FirstOrDefault()
            
            ' Efficient count check
            If users.Any() Then
                ProcessUsers(users)
            End If
            
            ' Efficient chaining
            Dim result = users.Where(Function(u) u.IsActive AndAlso u.Name.Length > 5).Select(Function(u) u.Name.ToUpper()).ToList()
            
            Dim products = GetProducts().ToList()
            
            ' Efficient filtering and counting
            Dim expensiveProducts = products.Where(Function(p) p.Price > 100).ToList()
            Dim expensiveCount = expensiveProducts.Count()
            Dim hasCheapProducts = products.Any(Function(p) p.Price < 50)
            Dim firstExpensive = expensiveProducts.FirstOrDefault()
            
            ' Efficient ordering - filter first, then order
            Dim sortedProducts = products.Where(Function(p) p.IsAvailable).OrderBy(Function(p) p.Name).ToList()
        End Sub
        
        Function GoodLinqFunction() As Integer
            Dim orders = GetOrders().ToList() ' Materialize once
            
            ' Single enumeration with grouped operations
            Dim ordersByStatus = orders.GroupBy(Function(o) o.Status).ToDictionary(Function(g) g.Key, Function(g) g.Count())
            
            Dim pendingCount = ordersByStatus.GetValueOrDefault("Pending", 0)
            Dim hasCompleted = ordersByStatus.ContainsKey("Completed")
            
            Return pendingCount
        End Function
        
        Sub GoodCountCheckMethod()
            Dim items = GetItems()
            
            If items.Any() Then ' Efficient
                ProcessItems(items)
            End If
            
            If items.Any(Function(i) i.IsValid) Then ' Efficient
                ProcessValidItems(items)
            End If
            
            ' When you actually need the count
            Dim validItems = items.Where(Function(i) i.IsValid).ToList()
            If validItems.Count > 0 Then
                ProcessValidItems(validItems)
            End If
        End Sub
        
        ' Efficient aggregation patterns
        Sub GoodAggregationMethod()
            Dim sales = GetSales()
            
            ' Efficient single-pass operations
            Dim totalSales = sales.Sum(Function(s) s.Amount)
            Dim averageSale = sales.Average(Function(s) s.Amount)
            Dim maxSale = sales.Max(Function(s) s.Amount)
            
            ' Efficient grouping
            Dim salesByRegion = sales.GroupBy(Function(s) s.Region).ToDictionary(Function(g) g.Key, Function(g) g.Sum(Function(s) s.Amount))
        End Sub
        
        ' Helper methods and classes
        Function GetUsers() As IEnumerable(Of User)
            Return New List(Of User)()
        End Function
        
        Function GetProducts() As IEnumerable(Of Product)
            Return New List(Of Product)()
        End Function
        
        Function GetOrders() As IEnumerable(Of Order)
            Return New List(Of Order)()
        End Function
        
        Function GetItems() As IEnumerable(Of Item)
            Return New List(Of Item)()
        End Function
        
        Function GetSales() As IEnumerable(Of Sale)
            Return New List(Of Sale)()
        End Function
        
        Sub ProcessUsers(users As IEnumerable(Of User))
        End Sub
        
        Sub ProcessItems(items As IEnumerable(Of Item))
        End Sub
        
        Sub ProcessValidItems(items As IEnumerable(Of Item))
        End Sub
        
        ' Sample classes
        Public Class User
            Public Property IsActive As Boolean
            Public Property IsAdmin As Boolean
            Public Property Name As String
        End Class
        
        Public Class Product
            Public Property Price As Decimal
            Public Property Name As String
            Public Property IsAvailable As Boolean
        End Class
        
        Public Class Order
            Public Property Status As String
        End Class
        
        Public Class Item
            Public Property IsValid As Boolean
        End Class
        
        Public Class Sale
            Public Property Amount As Decimal
            Public Property Region As String
        End Class
    </script>
</body>
</html>

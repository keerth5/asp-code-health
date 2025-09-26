<%@ Page Language="VB" %>
<html>
<head>
    <title>Excessive Object Creation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Excessive object creation in loops and frequently called methods
        
        Sub BadObjectCreationInLoops()
            ' BAD: Creating objects inside loops
            For i = 1 To 1000
                Dim newString As New String("data".ToCharArray()) ' Bad: object creation in loop
                Dim sb As New StringBuilder() ' Bad: object creation in loop
                Dim list As New List(Of String)() ' Bad: object creation in loop
                Dim dict As New Dictionary(Of String, Integer)() ' Bad: object creation in loop
                Dim arrayList As New ArrayList() ' Bad: object creation in loop
                Dim dateTime As New DateTime(2023, 1, 1) ' Bad: object creation in loop
                
                ProcessData(newString)
            Next
            
            While hasMoreData
                Dim user As New User() ' Bad: object creation in loop
                Dim order As New Order() ' Bad: object creation in loop
                ProcessUser(user)
            End While
            
            For Each item In items
                Dim processor As New DataProcessor() ' Bad: object creation in loop
                Dim result = processor.Process(item)
                ProcessResult(result)
            Next
        End Sub
        
        Sub BadStringOperationsInLoops()
            ' BAD: String operations that create objects in loops
            For i = 1 To 100
                Dim formatted = String.Format("Item {0}", i) ' Bad: String.Format in loop
                Dim concatenated = String.Concat("A", "B", "C") ' Bad: String.Concat in loop
                ProcessString(formatted)
            Next
            
            While condition
                Dim combined = String.Format("Value: {0}, Index: {1}", value, index) ' Bad: in loop
                LogMessage(combined)
            End While
            
            For Each record In records
                Dim message = String.Concat("Processing: ", record.Name, " at ", DateTime.Now.ToString()) ' Bad: in loop
                WriteLog(message)
            Next
        End Sub
        
        Function BadFrequentObjectCreation() As String
            ' BAD: Creating objects in frequently called method
            Dim result As String = ""
            
            For i = 1 To 50
                Dim temp As New StringBuilder() ' Bad: frequent object creation
                temp.Append("Item ")
                temp.Append(i.ToString())
                result += temp.ToString()
            Next
            
            Return result
        End Function
        
        Sub BadExcessiveCollectionCreation()
            ' BAD: Creating collections inside loops
            For Each category In categories
                Dim products As New List(Of Product)() ' Bad: collection creation in loop
                Dim productDict As New Dictionary(Of String, Product)() ' Bad: dictionary creation in loop
                
                For Each product In GetProductsForCategory(category.Id)
                    products.Add(product)
                    productDict.Add(product.Name, product)
                Next
                
                ProcessProducts(products)
            Next
        End Sub
        
        Sub BadDateTimeCreation()
            ' BAD: Creating DateTime objects in loops
            For i = 1 To 365
                Dim date As New DateTime(2023, 1, 1) ' Bad: DateTime creation in loop
                Dim specificDate = date.AddDays(i)
                ProcessDate(specificDate)
            Next
            
            While processing
                Dim now As New DateTime() ' Bad: DateTime creation in loop
                Dim timestamp = DateTime.Now ' Better, but still in loop
                LogTimestamp(timestamp)
            End While
        End Sub
        
        ' GOOD: Efficient object creation patterns
        
        Sub GoodObjectReusePattern()
            ' GOOD: Reusing objects instead of creating new ones
            Dim sb As New StringBuilder() ' Create once outside loop
            Dim list As New List(Of String)() ' Create once outside loop
            Dim dict As New Dictionary(Of String, Integer)() ' Create once outside loop
            
            For i = 1 To 1000
                sb.Clear() ' Reuse existing StringBuilder
                sb.Append("Item ")
                sb.Append(i.ToString())
                
                list.Clear() ' Reuse existing List
                list.Add(sb.ToString())
                
                ProcessData(sb.ToString())
            Next
        End Sub
        
        Sub GoodObjectPooling()
            ' GOOD: Using object pooling
            Dim processorPool As New ObjectPool(Of DataProcessor)(Function() New DataProcessor())
            
            For Each item In items
                Dim processor = processorPool.Get() ' Get from pool
                Try
                    Dim result = processor.Process(item)
                    ProcessResult(result)
                Finally
                    processorPool.Return(processor) ' Return to pool
                End Try
            Next
        End Sub
        
        Function GoodStringBuilderUsage() As String
            ' GOOD: Using StringBuilder efficiently
            Dim sb As New StringBuilder(1000) ' Pre-allocate capacity
            
            For i = 1 To 50
                sb.Append("Item ")
                sb.Append(i.ToString())
                sb.AppendLine()
            Next
            
            Return sb.ToString()
        End Function
        
        Sub GoodPreallocatedCollections()
            ' GOOD: Pre-allocating collections with known size
            Dim products As New List(Of Product)(categories.Count * 10) ' Pre-allocate
            Dim productDict As New Dictionary(Of String, Product)(100) ' Pre-allocate
            
            For Each category In categories
                Dim categoryProducts = GetProductsForCategory(category.Id)
                products.AddRange(categoryProducts) ' Add to pre-allocated collection
                
                For Each product In categoryProducts
                    productDict(product.Name) = product
                Next
            Next
            
            ProcessProducts(products)
        End Sub
        
        Sub GoodStaticDateTimeUsage()
            ' GOOD: Using static DateTime values and efficient date operations
            Dim baseDate As New DateTime(2023, 1, 1) ' Create once
            
            For i = 1 To 365
                Dim specificDate = baseDate.AddDays(i) ' Efficient date calculation
                ProcessDate(specificDate)
            Next
        End Sub
        
        Sub GoodLazyInitialization()
            ' GOOD: Lazy initialization for expensive objects
            Dim lazyProcessor As New Lazy(Of ExpensiveProcessor)(Function() New ExpensiveProcessor())
            
            For Each item In items
                If item.RequiresProcessing Then
                    Dim processor = lazyProcessor.Value ' Create only when needed
                    processor.Process(item)
                End If
            Next
        End Sub
        
        Sub GoodFactoryPattern()
            ' GOOD: Using factory pattern to control object creation
            Dim factory As New ProcessorFactory()
            
            For Each item In items
                Dim processor = factory.GetProcessor(item.Type) ' Factory manages creation/reuse
                processor.Process(item)
            Next
        End Sub
        
        Sub GoodStringInterning()
            ' GOOD: Using string interning for repeated strings
            Dim commonString = String.Intern("CommonValue") ' Intern frequently used strings
            
            For i = 1 To 1000
                If data(i) = commonString Then ' Reference comparison instead of new strings
                    ProcessCommonValue(data(i))
                End If
            Next
        End Sub
        
        ' Helper methods and fields
        Private hasMoreData As Boolean = True
        Private condition As Boolean = True
        Private processing As Boolean = True
        Private items As New List(Of Object)()
        Private records As New List(Of Record)()
        Private categories As New List(Of Category)()
        Private data(1000) As String
        Private value As String = "test"
        Private index As Integer = 1
        
        Sub ProcessData(data As String)
        End Sub
        
        Sub ProcessUser(user As User)
        End Sub
        
        Sub ProcessResult(result As Object)
        End Sub
        
        Sub ProcessString(str As String)
        End Sub
        
        Sub LogMessage(message As String)
        End Sub
        
        Sub WriteLog(message As String)
        End Sub
        
        Sub ProcessProducts(products As List(Of Product))
        End Sub
        
        Function GetProductsForCategory(categoryId As Integer) As List(Of Product)
            Return New List(Of Product)()
        End Function
        
        Sub ProcessDate(date As DateTime)
        End Sub
        
        Sub LogTimestamp(timestamp As DateTime)
        End Sub
        
        Sub ProcessCommonValue(value As String)
        End Sub
        
        ' Helper classes
        Public Class User
            Public Property Id As Integer
            Public Property Name As String
        End Class
        
        Public Class Order
            Public Property Id As Integer
            Public Property Amount As Decimal
        End Class
        
        Public Class DataProcessor
            Public Function Process(item As Object) As Object
                Return item
            End Function
        End Class
        
        Public Class Product
            Public Property Id As Integer
            Public Property Name As String
        End Class
        
        Public Class Category
            Public Property Id As Integer
            Public Property Name As String
        End Class
        
        Public Class Record
            Public Property Name As String
        End Class
        
        Public Class ExpensiveProcessor
            Public Sub Process(item As Object)
            End Sub
        End Class
        
        Public Class ProcessorFactory
            Public Function GetProcessor(type As String) As DataProcessor
                Return New DataProcessor()
            End Function
        End Class
        
        Public Class ObjectPool(Of T As {Class, New})
            Private factory As Func(Of T)
            Private pool As New ConcurrentQueue(Of T)()
            
            Public Sub New(factory As Func(Of T))
                Me.factory = factory
            End Sub
            
            Public Function [Get]() As T
                Dim item As T = Nothing
                If pool.TryDequeue(item) Then
                    Return item
                End If
                Return factory()
            End Function
            
            Public Sub [Return](item As T)
                pool.Enqueue(item)
            End Sub
        End Class
    </script>
</body>
</html>

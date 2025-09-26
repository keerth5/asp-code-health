<%@ Page Language="VB" %>
<html>
<head>
    <title>Index Out of Bounds Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Index out of bounds risks - array/collection access without bounds checking
        
        Sub BadIndexOutOfBoundsExamples()
            ' BAD: Array access without bounds checking
            Dim numbers(10) As Integer
            Dim index As Integer = GetIndex()
            Dim value = numbers(index) ' Bad: no bounds check
            Dim anotherValue = numbers(15) ' Bad: hardcoded index without bounds check
            
            ' BAD: String operations without bounds checking
            Dim text As String = "Hello World"
            Dim userInput As Integer = GetUserInput()
            Dim substring1 = text.Substring(userInput) ' Bad: no bounds check
            Dim substring2 = text.Substring(5, userInput) ' Bad: no length validation
            Dim substring3 = text.Substring(20, 5) ' Bad: start index out of bounds
            
            ' BAD: Collection operations without bounds checking
            Dim items As New List(Of String)
            items.Add("item1")
            items.Add("item2")
            Dim itemIndex As Integer = GetItemIndex()
            Dim item = items(itemIndex) ' Bad: no bounds check
            Dim removedItem = items.Remove(items(itemIndex)) ' Bad: no bounds check
            items.Insert(itemIndex, "newitem") ' Bad: no bounds check
            
            ' BAD: Array operations without validation
            Dim data As String() = GetDataArray()
            Dim dataIndex As Integer = GetDataIndex()
            Dim dataValue = data(dataIndex) ' Bad: no bounds check
            data(dataIndex) = "new value" ' Bad: no bounds check
        End Sub
        
        Sub MoreBadIndexExamples()
            ' BAD: Multiple array accesses without checks
            Dim matrix(5, 5) As Integer
            Dim row As Integer = GetRow()
            Dim col As Integer = GetColumn()
            matrix(row, col) = 100 ' Bad: no bounds check for 2D array
            
            ' BAD: String manipulation without validation
            Dim filename As String = GetFilename()
            Dim extension = filename.Substring(filename.Length - 3) ' Bad: assumes minimum length
            
            ' BAD: Collection modification without bounds checking
            Dim queue As New Queue(Of String)
            queue.Enqueue("item1")
            Dim queueIndex As Integer = GetQueueIndex()
            ' Simulating array-like access (bad example)
            Dim queueArray = queue.ToArray()
            Dim queueItem = queueArray(queueIndex) ' Bad: no bounds check
        End Sub
        
        ' GOOD: Proper bounds checking before array/collection access
        
        Sub GoodBoundsCheckExamples()
            ' GOOD: Array access with bounds checking
            Dim numbers(10) As Integer
            Dim index As Integer = GetIndex()
            If index >= 0 AndAlso index < numbers.Length Then
                Dim value = numbers(index) ' Good: bounds check performed
            End If
            
            ' GOOD: Alternative bounds checking
            If index < numbers.Length Then
                Dim anotherValue = numbers(index) ' Good: bounds check performed
            End If
        End Sub
        
        Sub GoodStringOperationsWithChecks()
            ' GOOD: String operations with bounds checking
            Dim text As String = "Hello World"
            Dim userInput As Integer = GetUserInput()
            
            If userInput >= 0 AndAlso userInput < text.Length Then
                Dim substring1 = text.Substring(userInput) ' Good: bounds check performed
            End If
            
            If userInput >= 0 AndAlso (userInput + 5) <= text.Length Then
                Dim substring2 = text.Substring(userInput, 5) ' Good: length validation
            End If
            
            If text.Length >= 5 Then
                Dim substring3 = text.Substring(0, 5) ' Good: length validation
            End If
        End Sub
        
        Sub GoodCollectionOperationsWithChecks()
            ' GOOD: Collection operations with bounds checking
            Dim items As New List(Of String)
            items.Add("item1")
            items.Add("item2")
            Dim itemIndex As Integer = GetItemIndex()
            
            If itemIndex >= 0 AndAlso itemIndex < items.Count Then
                Dim item = items(itemIndex) ' Good: bounds check performed
                items.RemoveAt(itemIndex) ' Good: bounds check performed
            End If
            
            If itemIndex >= 0 AndAlso itemIndex <= items.Count Then
                items.Insert(itemIndex, "newitem") ' Good: bounds check performed
            End If
        End Sub
        
        Sub GoodArrayOperationsWithValidation()
            ' GOOD: Array operations with validation
            Dim data As String() = GetDataArray()
            Dim dataIndex As Integer = GetDataIndex()
            
            If data IsNot Nothing AndAlso dataIndex >= 0 AndAlso dataIndex < data.Length Then
                Dim dataValue = data(dataIndex) ' Good: bounds check performed
                data(dataIndex) = "new value" ' Good: bounds check performed
            End If
        End Sub
        
        Sub GoodMultiDimensionalArrayChecks()
            ' GOOD: 2D array access with bounds checking
            Dim matrix(5, 5) As Integer
            Dim row As Integer = GetRow()
            Dim col As Integer = GetColumn()
            
            If row >= 0 AndAlso row <= matrix.GetUpperBound(0) AndAlso 
               col >= 0 AndAlso col <= matrix.GetUpperBound(1) Then
                matrix(row, col) = 100 ' Good: bounds check performed
            End If
        End Sub
        
        Sub GoodStringManipulationWithValidation()
            ' GOOD: String manipulation with validation
            Dim filename As String = GetFilename()
            If filename IsNot Nothing AndAlso filename.Length >= 3 Then
                Dim extension = filename.Substring(filename.Length - 3) ' Good: length validation
            End If
        End Sub
        
        Sub GoodTryPatternForBoundsChecking()
            ' GOOD: Using try-catch for bounds protection
            Dim data As String() = GetDataArray()
            Dim index As Integer = GetIndex()
            
            Try
                Dim value = data(index) ' Good: protected by try-catch
                data(index) = "new value" ' Good: protected by try-catch
            Catch ex As IndexOutOfRangeException
                ' Handle bounds exception appropriately
                LogError("Index out of bounds: " & index.ToString())
            End Try
        End Sub
        
        Sub GoodCollectionSafeAccess()
            ' GOOD: Safe collection access patterns
            Dim items As New List(Of String)
            items.Add("item1")
            items.Add("item2")
            
            ' Safe enumeration
            For i As Integer = 0 To items.Count - 1
                Dim item = items(i) ' Good: loop bounds are safe
                ProcessItem(item)
            Next
            
            ' Safe access with validation
            If items.Count > 0 Then
                Dim firstItem = items(0) ' Good: count validation
                Dim lastItem = items(items.Count - 1) ' Good: count validation
            End If
        End Sub
        
        Sub GoodBoundsCheckingWithConstants()
            ' GOOD: Using constants for bounds validation
            Const MaxIndex As Integer = 10
            Dim data(MaxIndex) As String
            Dim index As Integer = GetIndex()
            
            If index >= 0 AndAlso index <= MaxIndex Then
                data(index) = "value" ' Good: bounds check with constant
            End If
        End Sub
        
        ' Helper methods
        Function GetIndex() As Integer
            Return 5
        End Function
        
        Function GetUserInput() As Integer
            Return 3
        End Function
        
        Function GetItemIndex() As Integer
            Return 1
        End Function
        
        Function GetDataArray() As String()
            Return New String() {"data1", "data2", "data3"}
        End Function
        
        Function GetDataIndex() As Integer
            Return 2
        End Function
        
        Function GetRow() As Integer
            Return 2
        End Function
        
        Function GetColumn() As Integer
            Return 3
        End Function
        
        Function GetFilename() As String
            Return "document.pdf"
        End Function
        
        Function GetQueueIndex() As Integer
            Return 0
        End Function
        
        Sub ProcessItem(item As String)
        End Sub
        
        Sub LogError(message As String)
        End Sub
    </script>
</body>
</html>

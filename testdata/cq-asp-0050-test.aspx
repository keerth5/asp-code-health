<%@ Page Language="VB" %>
<html>
<head>
    <title>Boxing and Unboxing Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Boxing and unboxing - value types being boxed/unboxed frequently
        
        Sub BadBoxingInLoops()
            ' BAD: Boxing value types when adding to non-generic collections
            Dim arrayList As New ArrayList()
            Dim hashtable As New Hashtable()
            
            For i = 1 To 1000
                arrayList.Add(i) ' Bad: boxing int to object
                arrayList.Add(3.14) ' Bad: boxing double to object
                arrayList.Add(True) ' Bad: boxing bool to object
                arrayList.Add(123.45D) ' Bad: boxing decimal to object
            Next
            
            While hasMoreData
                hashtable.Add("key" & counter, counter) ' Bad: boxing int to object
                hashtable.Add("price", price) ' Bad: boxing double to object
                hashtable.Add("active", isActive) ' Bad: boxing bool to object
                counter += 1
            End While
            
            For Each value In valuesToProcess
                arrayList.Insert(0, value) ' Bad: boxing in loop
            Next
        End Sub
        
        Sub BadObjectAssignmentBoxing()
            ' BAD: Assigning value types to Object variables in loops
            For i = 1 To 100
                Dim obj As Object = i ' Bad: boxing int
                Dim obj2 As Object = 3.14 ' Bad: boxing double
                Dim obj3 As Object = True ' Bad: boxing bool
                Dim obj4 As Object = 99.99D ' Bad: boxing decimal
                
                ProcessObject(obj)
                ProcessObject(obj2)
                ProcessObject(obj3)
                ProcessObject(obj4)
            Next
            
            While processing
                Dim boxedValue As Object = currentValue ' Bad: boxing in loop
                Dim boxedFlag As Object = processingFlag ' Bad: boxing in loop
                StoreBoxedValue(boxedValue, boxedFlag)
            End While
        End Sub
        
        Sub BadUnboxingInLoops()
            ' BAD: Unboxing in loops
            Dim objects As New ArrayList()
            objects.AddRange({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
            
            For i = 0 To objects.Count - 1
                Dim intValue = CInt(objects(i)) ' Bad: unboxing in loop
                Dim doubleValue = CDbl(objects(i)) ' Bad: unboxing in loop
                Dim boolValue = CBool(objects(i)) ' Bad: unboxing in loop
                
                ProcessValues(intValue, doubleValue, boolValue)
            Next
            
            For Each obj In objects
                Dim unboxedInt = CInt(obj) ' Bad: unboxing in loop
                Dim unboxedDecimal = CDec(obj) ' Bad: unboxing in loop
                ProcessUnboxedValues(unboxedInt, unboxedDecimal)
            Next
        End Sub
        
        Function BadRepeatedBoxingUnboxing() As Integer
            ' BAD: Repeated boxing and unboxing operations
            Dim total As Integer = 0
            Dim values As New ArrayList()
            
            For i = 1 To 50
                values.Add(i) ' Boxing
            Next
            
            For Each obj In values
                total += CInt(obj) ' Unboxing
            Next
            
            Return total
        End Function
        
        Sub BadMethodParameterBoxing()
            ' BAD: Passing value types to methods expecting Object
            For i = 1 To 100
                ProcessGenericObject(i) ' Bad: boxing int parameter
                ProcessGenericObject(3.14) ' Bad: boxing double parameter
                ProcessGenericObject(True) ' Bad: boxing bool parameter
            Next
        End Sub
        
        ' GOOD: Avoiding boxing and unboxing
        
        Sub GoodGenericCollections()
            ' GOOD: Using generic collections to avoid boxing
            Dim intList As New List(Of Integer)()
            Dim doubleList As New List(Of Double)()
            Dim boolList As New List(Of Boolean)()
            Dim decimalList As New List(Of Decimal)()
            Dim dictionary As New Dictionary(Of String, Integer)()
            
            For i = 1 To 1000
                intList.Add(i) ' No boxing - type-safe
                doubleList.Add(3.14) ' No boxing - type-safe
                boolList.Add(True) ' No boxing - type-safe
                decimalList.Add(123.45D) ' No boxing - type-safe
            Next
            
            While hasMoreData
                dictionary.Add("key" & counter, counter) ' No boxing - type-safe
                counter += 1
            End While
        End Sub
        
        Sub GoodTypedVariables()
            ' GOOD: Using properly typed variables
            For i = 1 To 100
                Dim intValue As Integer = i ' No boxing - proper type
                Dim doubleValue As Double = 3.14 ' No boxing - proper type
                Dim boolValue As Boolean = True ' No boxing - proper type
                Dim decimalValue As Decimal = 99.99D ' No boxing - proper type
                
                ProcessTypedValues(intValue, doubleValue, boolValue, decimalValue)
            Next
        End Sub
        
        Sub GoodGenericMethodUsage()
            ' GOOD: Using generic methods to avoid boxing
            For i = 1 To 100
                ProcessGenericValue(i) ' No boxing - generic method
                ProcessGenericValue(3.14) ' No boxing - generic method
                ProcessGenericValue(True) ' No boxing - generic method
            Next
        End Sub
        
        Function GoodTypeSafeCollectionProcessing() As Integer
            ' GOOD: Type-safe collection processing without boxing/unboxing
            Dim total As Integer = 0
            Dim values As New List(Of Integer)()
            
            ' Add values without boxing
            For i = 1 To 50
                values.Add(i) ' No boxing
            Next
            
            ' Process values without unboxing
            For Each value In values
                total += value ' No unboxing - already correct type
            Next
            
            Return total
        End Function
        
        Sub GoodStructUsage()
            ' GOOD: Using structs appropriately to avoid boxing
            Dim points As New List(Of Point)()
            
            For i = 1 To 100
                Dim point As New Point(i, i * 2) ' Struct - no boxing
                points.Add(point) ' No boxing with generic collection
            Next
            
            For Each point In points
                ProcessPoint(point) ' No unboxing - direct struct usage
            Next
        End Sub
        
        Sub GoodValueTypeArrays()
            ' GOOD: Using value type arrays instead of object collections
            Dim intArray(999) As Integer
            Dim doubleArray(999) As Double
            Dim boolArray(999) As Boolean
            
            For i = 0 To 999
                intArray(i) = i ' No boxing - direct assignment
                doubleArray(i) = i * 3.14 ' No boxing - direct assignment
                boolArray(i) = (i Mod 2 = 0) ' No boxing - direct assignment
            Next
            
            For i = 0 To 999
                ProcessArrayValues(intArray(i), doubleArray(i), boolArray(i)) ' No unboxing
            Next
        End Sub
        
        Sub GoodNullableTypes()
            ' GOOD: Using nullable types appropriately
            Dim nullableInts As New List(Of Integer?)()
            Dim nullableDoubles As New List(Of Double?)()
            
            For i = 1 To 100
                If i Mod 2 = 0 Then
                    nullableInts.Add(i) ' No boxing with nullable in generic collection
                Else
                    nullableInts.Add(Nothing) ' No boxing for null
                End If
            Next
            
            For Each nullableInt In nullableInts
                If nullableInt.HasValue Then
                    ProcessNullableValue(nullableInt.Value) ' No unboxing
                End If
            Next
        End Sub
        
        Sub GoodInterfaceImplementation()
            ' GOOD: Implementing interfaces on value types without boxing
            Dim comparableInts As New List(Of ComparableInt)()
            
            For i = 1 To 100
                comparableInts.Add(New ComparableInt(i)) ' No boxing
            Next
            
            comparableInts.Sort() ' Uses IComparable without boxing
        End Sub
        
        Function GoodLINQWithValueTypes() As List(Of Integer)
            ' GOOD: LINQ operations that don't cause boxing
            Dim numbers As New List(Of Integer)(Enumerable.Range(1, 1000))
            
            ' All operations preserve value types - no boxing
            Dim evenNumbers = numbers.Where(Function(n) n Mod 2 = 0).ToList()
            Dim doubledNumbers = numbers.Select(Function(n) n * 2).ToList()
            Dim sum = numbers.Sum() ' No boxing in aggregation
            
            Return evenNumbers
        End Function
        
        Sub GoodDictionaryWithValueTypes()
            ' GOOD: Using generic dictionaries with value types
            Dim intToStringMap As New Dictionary(Of Integer, String)()
            Dim stringToIntMap As New Dictionary(Of String, Integer)()
            
            For i = 1 To 100
                intToStringMap.Add(i, "Value" & i.ToString()) ' No boxing of key
                stringToIntMap.Add("Key" & i.ToString(), i) ' No boxing of value
            Next
            
            For Each kvp In intToStringMap
                ProcessKeyValuePair(kvp.Key, kvp.Value) ' No unboxing
            Next
        End Sub
        
        ' Helper methods and fields
        Private hasMoreData As Boolean = True
        Private counter As Integer = 1
        Private price As Double = 19.99
        Private isActive As Boolean = True
        Private valuesToProcess As New List(Of Integer)()
        Private processing As Boolean = True
        Private currentValue As Integer = 42
        Private processingFlag As Boolean = True
        
        Sub ProcessObject(obj As Object)
        End Sub
        
        Sub StoreBoxedValue(value As Object, flag As Object)
        End Sub
        
        Sub ProcessValues(intVal As Integer, doubleVal As Double, boolVal As Boolean)
        End Sub
        
        Sub ProcessUnboxedValues(intVal As Integer, decimalVal As Decimal)
        End Sub
        
        Sub ProcessGenericObject(obj As Object)
        End Sub
        
        Sub ProcessTypedValues(intVal As Integer, doubleVal As Double, boolVal As Boolean, decimalVal As Decimal)
        End Sub
        
        Sub ProcessGenericValue(Of T)(value As T)
        End Sub
        
        Sub ProcessPoint(point As Point)
        End Sub
        
        Sub ProcessArrayValues(intVal As Integer, doubleVal As Double, boolVal As Boolean)
        End Sub
        
        Sub ProcessNullableValue(value As Integer)
        End Sub
        
        Sub ProcessKeyValuePair(key As Integer, value As String)
        End Sub
        
        ' Helper structures and classes
        Public Structure Point
            Public X As Integer
            Public Y As Integer
            
            Public Sub New(x As Integer, y As Integer)
                Me.X = x
                Me.Y = y
            End Sub
        End Structure
        
        Public Structure ComparableInt
            Implements IComparable(Of ComparableInt)
            
            Public Value As Integer
            
            Public Sub New(value As Integer)
                Me.Value = value
            End Sub
            
            Public Function CompareTo(other As ComparableInt) As Integer Implements IComparable(Of ComparableInt).CompareTo
                Return Value.CompareTo(other.Value)
            End Function
        End Structure
    </script>
</body>
</html>

<%@ Page Language="VB" %>
<html>
<head>
    <title>Collection Modification During Iteration Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Collection modification during iteration - modifying collections while iterating through them
        
        Sub BadForEachModification()
            ' BAD: Modifying collection during For Each iteration
            Dim items As New List(Of String)()
            items.AddRange({"item1", "item2", "item3", "item4"})
            
            For Each item In items
                If item.Contains("2") Then
                    items.Remove(item) ' BAD: Modifying collection during iteration
                End If
            Next
        End Sub
        
        Sub BadForEachAddition()
            ' BAD: Adding to collection during For Each
            Dim numbers As New List(Of Integer)()
            numbers.AddRange({1, 2, 3, 4, 5})
            
            For Each number In numbers
                If number Mod 2 = 0 Then
                    numbers.Add(number * 10) ' BAD: Adding during iteration
                End If
            Next
        End Sub
        
        Sub BadForEachClear()
            ' BAD: Clearing collection during iteration
            Dim data As New List(Of String)()
            data.AddRange({"a", "b", "c"})
            
            For Each item In data
                If item = "b" Then
                    data.Clear() ' BAD: Clearing during iteration
                End If
            Next
        End Sub
        
        Sub BadForEachInsert()
            ' BAD: Inserting into collection during iteration
            Dim values As New List(Of Integer)()
            values.AddRange({10, 20, 30})
            
            For Each value In values
                If value = 20 Then
                    values.Insert(1, 15) ' BAD: Inserting during iteration
                End If
            Next
        End Sub
        
        Sub BadForLoopWithCountModification()
            ' BAD: Modifying collection size during for loop with count
            Dim items As New List(Of String)()
            items.AddRange({"A", "B", "C", "D"})
            
            For i As Integer = 0 To items.Count - 1
                If items(i) = "B" Then
                    items.Remove(items(i)) ' BAD: Changing count during loop
                End If
            Next
        End Sub
        
        Sub BadForLoopWithAddition()
            ' BAD: Adding items during for loop with count
            Dim numbers As New List(Of Integer)()
            numbers.AddRange({1, 2, 3})
            
            For i As Integer = 0 To numbers.Count - 1
                If numbers(i) < 3 Then
                    numbers.Add(numbers(i) + 10) ' BAD: Adding changes count
                End If
            Next
        End Sub
        
        Sub BadWhileLoopModification()
            ' BAD: Modifying collection during while loop with enumerator
            Dim items As New List(Of String)()
            items.AddRange({"X", "Y", "Z"})
            
            Dim enumerator As IEnumerator(Of String) = items.GetEnumerator()
            While enumerator.MoveNext()
                Dim current As String = enumerator.Current
                If current = "Y" Then
                    items.Remove(current) ' BAD: Modifying during enumeration
                End If
            End While
        End Sub
        
        Sub BadDoWhileModification()
            ' BAD: Modifying collection during do-while with enumerator
            Dim data As New List(Of Integer)()
            data.AddRange({100, 200, 300})
            
            Dim enumerator As IEnumerator(Of Integer) = data.GetEnumerator()
            Do While enumerator.MoveNext()
                Dim current As Integer = enumerator.Current
                If current = 200 Then
                    data.Clear() ' BAD: Clearing during enumeration
                End If
            Loop
        End Sub
        
        Sub BadNestedIterationModification()
            ' BAD: Modifying outer collection during nested iteration
            Dim outerList As New List(Of List(Of String))()
            outerList.Add(New List(Of String)({"a1", "a2"}))
            outerList.Add(New List(Of String)({"b1", "b2"}))
            
            For Each innerList In outerList
                For Each item In innerList
                    If item = "a2" Then
                        outerList.Remove(innerList) ' BAD: Modifying outer during inner iteration
                    End If
                Next
            Next
        End Sub
        
        Sub BadDictionaryModification()
            ' BAD: Modifying dictionary during iteration
            Dim dict As New Dictionary(Of String, Integer)()
            dict.Add("key1", 1)
            dict.Add("key2", 2)
            dict.Add("key3", 3)
            
            For Each kvp In dict
                If kvp.Value = 2 Then
                    dict.Remove(kvp.Key) ' BAD: Modifying dictionary during iteration
                End If
            Next
        End Sub
        
        ' GOOD: Safe collection iteration and modification patterns
        
        Sub GoodForLoopBackwards()
            ' GOOD: Iterate backwards when removing items
            Dim items As New List(Of String)()
            items.AddRange({"item1", "item2", "item3", "item4"})
            
            For i As Integer = items.Count - 1 To 0 Step -1
                If items(i).Contains("2") Then
                    items.RemoveAt(i) ' GOOD: Safe removal when iterating backwards
                End If
            Next
        End Sub
        
        Sub GoodCopyAndIterate()
            ' GOOD: Create copy for iteration, modify original
            Dim items As New List(Of String)()
            items.AddRange({"item1", "item2", "item3", "item4"})
            
            Dim itemsCopy As New List(Of String)(items)
            For Each item In itemsCopy
                If item.Contains("2") Then
                    items.Remove(item) ' GOOD: Modifying original, iterating copy
                End If
            Next
        End Sub
        
        Sub GoodToArrayIteration()
            ' GOOD: Convert to array for safe iteration
            Dim numbers As New List(Of Integer)()
            numbers.AddRange({1, 2, 3, 4, 5})
            
            For Each number In numbers.ToArray()
                If number Mod 2 = 0 Then
                    numbers.Add(number * 10) ' GOOD: Safe to modify, iterating array
                End If
            Next
        End Sub
        
        Sub GoodCollectAndModify()
            ' GOOD: Collect items to modify, then modify separately
            Dim data As New List(Of String)()
            data.AddRange({"a", "b", "c", "d"})
            
            Dim itemsToRemove As New List(Of String)()
            For Each item In data
                If item = "b" Or item = "d" Then
                    itemsToRemove.Add(item)
                End If
            Next
            
            ' Now safely remove collected items
            For Each item In itemsToRemove
                data.Remove(item)
            Next
        End Sub
        
        Sub GoodWhereAndToList()
            ' GOOD: Use LINQ to filter instead of modifying during iteration
            Dim items As New List(Of String)()
            items.AddRange({"keep1", "remove", "keep2", "remove"})
            
            ' Create new list with filtered items
            Dim filteredItems As List(Of String) = items.Where(Function(x) Not x.Contains("remove")).ToList()
            
            ' Replace original list if needed
            items.Clear()
            items.AddRange(filteredItems)
        End Sub
        
        Sub GoodForLoopWithIndexTracking()
            ' GOOD: Use index tracking for safe modification
            Dim values As New List(Of Integer)()
            values.AddRange({10, 20, 30, 40})
            
            Dim i As Integer = 0
            While i < values.Count
                If values(i) = 20 Then
                    values.RemoveAt(i)
                    ' Don't increment i since we removed an item
                Else
                    i += 1 ' Only increment if we didn't remove
                End If
            End While
        End Sub
        
        Sub GoodDictionaryModification()
            ' GOOD: Collect keys to remove, then remove them
            Dim dict As New Dictionary(Of String, Integer)()
            dict.Add("key1", 1)
            dict.Add("key2", 2)
            dict.Add("key3", 3)
            
            Dim keysToRemove As New List(Of String)()
            For Each kvp In dict
                If kvp.Value = 2 Then
                    keysToRemove.Add(kvp.Key)
                End If
            Next
            
            ' Now safely remove the keys
            For Each key In keysToRemove
                dict.Remove(key)
            Next
        End Sub
        
        Sub GoodNestedIterationSafe()
            ' GOOD: Safe nested iteration without modification
            Dim outerList As New List(Of List(Of String))()
            outerList.Add(New List(Of String)({"a1", "a2"}))
            outerList.Add(New List(Of String)({"b1", "b2"}))
            
            Dim listsToRemove As New List(Of List(Of String))()
            
            For Each innerList In outerList
                For Each item In innerList
                    If item = "a2" Then
                        listsToRemove.Add(innerList) ' Collect for later removal
                        Exit For ' Exit inner loop
                    End If
                Next
            Next
            
            ' Now safely remove collected lists
            For Each listToRemove In listsToRemove
                outerList.Remove(listToRemove)
            Next
        End Sub
        
        Sub GoodConcurrentCollection()
            ' GOOD: Use concurrent collections for thread-safe modifications
            Dim concurrentList As New System.Collections.Concurrent.ConcurrentBag(Of String)()
            concurrentList.Add("item1")
            concurrentList.Add("item2")
            concurrentList.Add("item3")
            
            ' Safe to modify during iteration with concurrent collections
            For Each item In concurrentList
                If item.Contains("2") Then
                    concurrentList.Add(item + "_modified") ' Safe with concurrent collection
                End If
            Next
        End Sub
        
        Sub GoodImmutableCollections()
            ' GOOD: Use immutable collections
            Dim immutableList As ImmutableList(Of String) = ImmutableList.Create("a", "b", "c")
            
            For Each item In immutableList
                If item = "b" Then
                    ' Creates new immutable list, doesn't modify during iteration
                    immutableList = immutableList.Remove(item)
                End If
            Next
        End Sub
        
        Sub GoodLinqOperations()
            ' GOOD: Use LINQ for collection transformations
            Dim numbers As New List(Of Integer)()
            numbers.AddRange({1, 2, 3, 4, 5})
            
            ' Transform without modifying during iteration
            Dim evenNumbers = numbers.Where(Function(n) n Mod 2 = 0).ToList()
            Dim doubledNumbers = numbers.Select(Function(n) n * 2).ToList()
            
            ProcessResults(evenNumbers, doubledNumbers)
        End Sub
        
        Sub GoodRemoveAllMethod()
            ' GOOD: Use RemoveAll for conditional removal
            Dim items As New List(Of String)()
            items.AddRange({"keep1", "remove1", "keep2", "remove2"})
            
            ' Safe single operation to remove matching items
            items.RemoveAll(Function(item) item.Contains("remove"))
        End Sub
        
        ' Helper methods
        Sub ProcessResults(even As List(Of Integer), doubled As List(Of Integer))
        End Sub
    </script>
</body>
</html>

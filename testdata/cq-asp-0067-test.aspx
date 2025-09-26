<%@ Page Language="VB" %>
<html>
<head>
    <title>Infinite Loop Risk Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Infinite loop risks - loops with conditions that may never become false
        
        Sub BadInfiniteLoopExamples()
            ' BAD: While true loops without exit conditions
            While True ' Bad: infinite loop without break/return/exit
                ProcessData()
                ' No break, return, or exit statement
            End While
            
            ' BAD: For loops with infinite conditions
            For ; ; ' Bad: infinite for loop without exit conditions
                DoWork()
                ' No break, return, or exit statement
            Next
            
            ' BAD: Do-While loops with true condition
            Do
                PerformOperation()
                ' No break, return, or exit statement
            Loop While True ' Bad: infinite do-while loop
            
            ' BAD: While loops with conditions that never change
            Dim flag As Boolean = True
            While flag ' Bad: flag never changes in loop
                ProcessItem()
                ' flag is never set to False
            End While
            
            ' BAD: For loops with incorrect increment
            For i As Integer = 0 To 10 Step -1 ' Bad: will never reach 10
                ProcessIndex(i)
            Next
        End Sub
        
        Sub MoreBadInfiniteLoopExamples()
            ' BAD: Complex infinite loop scenarios
            Dim counter As Integer = 0
            While counter < 10 ' Bad: counter never incremented
                ProcessCounter(counter)
                ' counter is never incremented
            End While
            
            ' BAD: Nested infinite loops
            While True ' Bad: outer infinite loop
                Dim innerFlag As Boolean = True
                While innerFlag ' Bad: inner infinite loop
                    DoInnerWork()
                    ' innerFlag never changes
                End While
            End While
            
            ' BAD: Infinite loop with complex condition
            Dim value As Integer = GetInitialValue()
            While value > 0 ' Bad: value never decreases
                ProcessValue(value)
                ' value is never modified
            End While
        End Sub
        
        ' GOOD: Proper loops with exit conditions
        
        Sub GoodLoopsWithExitConditions()
            ' GOOD: While true with break statement
            While True
                ProcessData()
                If ShouldExit() Then
                    Exit While ' Good: break statement provides exit
                End If
            End While
            
            ' GOOD: While true with return statement
            While True
                DoWork()
                If IsComplete() Then
                    Return ' Good: return statement provides exit
                End If
            End While
            
            ' GOOD: While true with throw statement
            While True
                PerformOperation()
                If HasError() Then
                    Throw New Exception("Error occurred") ' Good: throw provides exit
                End If
            End While
        End Sub
        
        Sub GoodForLoopsWithExitConditions()
            ' GOOD: For loops with break statements
            For ; ;
                DoWork()
                If ShouldStop() Then
                    Exit For ' Good: break statement provides exit
                End If
            Next
            
            ' GOOD: For loops with return statements
            For ; ;
                ProcessItem()
                If IsFinished() Then
                    Return ' Good: return statement provides exit
                End If
            Next
        End Sub
        
        Sub GoodDoWhileLoopsWithExitConditions()
            ' GOOD: Do-While loops with exit conditions
            Do
                PerformOperation()
                If ShouldExit() Then
                    Exit Do ' Good: exit statement provides exit
                End If
            Loop While True
            
            ' GOOD: Do-While with return
            Do
                ProcessTask()
                If TaskComplete() Then
                    Return ' Good: return provides exit
                End If
            Loop While True
        End Sub
        
        Sub GoodFiniteLoops()
            ' GOOD: Loops with changing conditions
            Dim flag As Boolean = True
            While flag
                ProcessItem()
                flag = ShouldContinue() ' Good: flag is updated in loop
            End While
            
            ' GOOD: Counter-based loops
            Dim counter As Integer = 0
            While counter < 10
                ProcessCounter(counter)
                counter += 1 ' Good: counter is incremented
            End While
            
            ' GOOD: Standard for loops
            For i As Integer = 0 To 10
                ProcessIndex(i) ' Good: standard for loop with proper bounds
            Next
        End Sub
        
        Sub GoodLoopsWithProperConditions()
            ' GOOD: Loops with conditions that can change
            Dim items As New List(Of String)()
            PopulateItems(items)
            
            While items.Count > 0
                ProcessItem(items(0))
                items.RemoveAt(0) ' Good: condition changes (count decreases)
            End While
            
            ' GOOD: File processing loop
            Dim reader As StreamReader = GetFileReader()
            Dim line As String = reader.ReadLine()
            While line IsNot Nothing
                ProcessLine(line)
                line = reader.ReadLine() ' Good: condition can change (end of file)
            End While
        End Sub
        
        Sub GoodTimeBasedLoops()
            ' GOOD: Time-based loop with timeout
            Dim startTime As DateTime = DateTime.Now
            Dim timeout As TimeSpan = TimeSpan.FromSeconds(30)
            
            While True
                ProcessData()
                If DateTime.Now.Subtract(startTime) > timeout Then
                    Exit While ' Good: timeout provides exit condition
                End If
                If IsComplete() Then
                    Exit While ' Good: completion provides exit condition
                End If
            End While
        End Sub
        
        Sub GoodResourceBasedLoops()
            ' GOOD: Resource-based loops with proper exit conditions
            Dim queue As New Queue(Of WorkItem)()
            PopulateQueue(queue)
            
            While True
                If queue.Count = 0 Then
                    Exit While ' Good: empty queue provides exit
                End If
                
                Dim item As WorkItem = queue.Dequeue()
                ProcessWorkItem(item)
                
                If ShouldStopProcessing() Then
                    Exit While ' Good: external condition provides exit
                End If
            End While
        End Sub
        
        Sub GoodNestedLoopsWithExits()
            ' GOOD: Nested loops with proper exit conditions
            Dim outerFlag As Boolean = True
            While outerFlag
                Dim innerFlag As Boolean = True
                While innerFlag
                    DoInnerWork()
                    innerFlag = ShouldContinueInner() ' Good: inner flag changes
                End While
                outerFlag = ShouldContinueOuter() ' Good: outer flag changes
            End While
        End Sub
        
        Sub GoodConditionalLoops()
            ' GOOD: Loops with complex but changeable conditions
            Dim value As Integer = GetInitialValue()
            While value > 0
                ProcessValue(value)
                value = UpdateValue(value) ' Good: value is modified
                
                If HasReachedLimit(value) Then
                    Exit While ' Good: additional exit condition
                End If
            End While
        End Sub
        
        Sub GoodUserInteractionLoops()
            ' GOOD: User interaction loops with exit conditions
            Dim userContinue As Boolean = True
            While userContinue
                DisplayMenu()
                Dim choice As String = GetUserChoice()
                
                Select Case choice.ToUpper()
                    Case "Q", "QUIT"
                        userContinue = False ' Good: user can exit
                    Case "1"
                        ProcessOption1()
                    Case "2"
                        ProcessOption2()
                    Case Else
                        ShowInvalidOption()
                End Select
            End While
        End Sub
        
        Sub GoodRetryLoopsWithLimits()
            ' GOOD: Retry loops with maximum attempt limits
            Dim maxRetries As Integer = 3
            Dim attempt As Integer = 0
            Dim success As Boolean = False
            
            While Not success AndAlso attempt < maxRetries
                Try
                    PerformRiskyOperation()
                    success = True ' Good: success condition can change
                Catch ex As Exception
                    attempt += 1 ' Good: attempt counter increments
                    If attempt >= maxRetries Then
                        Throw New Exception("Max retries exceeded", ex)
                    End If
                    Thread.Sleep(1000) ' Wait before retry
                End Try
            End While
        End Sub
        
        ' Helper methods and classes
        Sub ProcessData()
        End Sub
        
        Sub DoWork()
        End Sub
        
        Sub PerformOperation()
        End Sub
        
        Sub ProcessItem()
        End Sub
        
        Sub ProcessIndex(index As Integer)
        End Sub
        
        Sub ProcessCounter(counter As Integer)
        End Sub
        
        Sub DoInnerWork()
        End Sub
        
        Sub ProcessValue(value As Integer)
        End Sub
        
        Sub ProcessLine(line As String)
        End Sub
        
        Sub ProcessWorkItem(item As WorkItem)
        End Sub
        
        Sub DisplayMenu()
        End Sub
        
        Sub ProcessOption1()
        End Sub
        
        Sub ProcessOption2()
        End Sub
        
        Sub ShowInvalidOption()
        End Sub
        
        Sub PerformRiskyOperation()
        End Sub
        
        Sub PopulateItems(items As List(Of String))
        End Sub
        
        Sub PopulateQueue(queue As Queue(Of WorkItem))
        End Sub
        
        Function ShouldExit() As Boolean
            Return True
        End Function
        
        Function IsComplete() As Boolean
            Return True
        End Function
        
        Function HasError() As Boolean
            Return False
        End Function
        
        Function ShouldStop() As Boolean
            Return True
        End Function
        
        Function IsFinished() As Boolean
            Return True
        End Function
        
        Function TaskComplete() As Boolean
            Return True
        End Function
        
        Function ShouldContinue() As Boolean
            Return False
        End Function
        
        Function ShouldContinueInner() As Boolean
            Return False
        End Function
        
        Function ShouldContinueOuter() As Boolean
            Return False
        End Function
        
        Function GetInitialValue() As Integer
            Return 10
        End Function
        
        Function UpdateValue(value As Integer) As Integer
            Return value - 1
        End Function
        
        Function HasReachedLimit(value As Integer) As Boolean
            Return value <= 0
        End Function
        
        Function GetFileReader() As StreamReader
            Return New StreamReader(New MemoryStream())
        End Function
        
        Function GetUserChoice() As String
            Return "Q"
        End Function
        
        Function ShouldStopProcessing() As Boolean
            Return True
        End Function
        
        Public Class WorkItem
            Public Property Id As Integer
            Public Property Data As String
        End Class
    </script>
</body>
</html>

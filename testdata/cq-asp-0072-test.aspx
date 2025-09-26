<%@ Page Language="VB" %>
<html>
<head>
    <title>Unreachable Code Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Unreachable code - code that can never be executed due to logic flow
        
        Sub BadUnreachableAfterReturn()
            ' BAD: Code after return statement
            If True Then
                Return
                ProcessData() ' Unreachable code
                Dim x As Integer = 10 ' Unreachable code
            End If
        End Sub
        
        Sub BadUnreachableAfterExit()
            ' BAD: Code after Exit Sub
            ProcessData()
            Exit Sub
            CleanupData() ' Unreachable code
            LogMessage("Done") ' Unreachable code
        End Sub
        
        Sub BadUnreachableAfterThrow()
            ' BAD: Code after throw statement
            ValidateInput()
            Throw New ArgumentException("Invalid input")
            ProcessValidInput() ' Unreachable code
            SaveData() ' Unreachable code
        End Sub
        
        Sub BadUnreachableAfterRedirect()
            ' BAD: Code after Response.Redirect
            If UserAuthorized() Then
                Response.Redirect("authorized.aspx")
                LogAccess() ' Unreachable code
                UpdateSession() ' Unreachable code
            End If
        End Sub
        
        Sub BadUnreachableAfterTransfer()
            ' BAD: Code after Server.Transfer
            ProcessRequest()
            Server.Transfer("handler.aspx")
            CleanupResources() ' Unreachable code
            LogTransfer() ' Unreachable code
        End Sub
        
        Function BadUnreachableInFunction() As String
            ' BAD: Code after return in function
            If HasData() Then
                Return "Success"
                LogSuccess() ' Unreachable code
            End If
            Return "Failure"
        End Function
        
        Sub BadUnreachableAfterThrowNew()
            ' BAD: Code after throw new exception
            Try
                PerformOperation()
            Catch ex As Exception
                throw new InvalidOperationException("Operation failed")
                LogError(ex) ' Unreachable code
                CleanupOnError() ' Unreachable code
            End Try
        End Sub
        
        Sub BadUnreachableComplexFlow()
            ' BAD: Complex unreachable code scenarios
            For i As Integer = 0 To 10
                If i = 5 Then
                    Return
                    ProcessItem(i) ' Unreachable code
                End If
            Next
        End Sub
        
        Sub BadUnreachableAfterRedirectWithQuery()
            ' BAD: Code after redirect with query string
            Dim url As String = "page.aspx?id=123"
            Response.Redirect(url)
            UpdateDatabase() ' Unreachable code
            SendEmail() ' Unreachable code
        End Sub
        
        Sub BadUnreachableNestedReturn()
            ' BAD: Unreachable code in nested blocks
            If SomeCondition() Then
                If AnotherCondition() Then
                    Return
                    ProcessNested() ' Unreachable code
                End If
                ProcessOuter() ' This is reachable
            End If
        End Sub
        
        ' GOOD: Reachable code patterns
        
        Sub GoodReachableAfterConditionalReturn()
            ' GOOD: Code after conditional return is reachable
            If ShouldReturn() Then
                Return
            End If
            ProcessData() ' Reachable - only executed if condition is false
            CleanupData() ' Reachable
        End Sub
        
        Sub GoodReachableInElseBranch()
            ' GOOD: Code in else branch is reachable
            If SomeCondition() Then
                Return
            Else
                ProcessElse() ' Reachable
                SaveData() ' Reachable
            End If
        End Sub
        
        Sub GoodReachableAfterTryReturn()
            ' GOOD: Code after try block with return in catch is reachable
            Try
                PerformOperation()
                Return ' This returns from try block
            Catch ex As Exception
                LogError(ex)
                ' No return here, so code after try/catch is reachable
            End Try
            CleanupAfterTry() ' Reachable if no exception or after catch
        End Sub
        
        Sub GoodReachableInCatchFinally()
            ' GOOD: Code in catch and finally blocks is reachable
            Try
                RiskyOperation()
                Return
            Catch ex As Exception
                HandleError(ex) ' Reachable
                Return
            Finally
                CleanupResources() ' Reachable - finally always executes
            End Try
        End Sub
        
        Sub GoodReachableAfterConditionalThrow()
            ' GOOD: Code after conditional throw is reachable
            If HasError() Then
                Throw New Exception("Error occurred")
            End If
            ProcessSuccess() ' Reachable if no error
        End Sub
        
        Function GoodReachableMultipleReturns() As String
            ' GOOD: Multiple return paths, all reachable
            If EarlyCondition() Then
                Return "Early"
            End If
            
            ProcessMiddle() ' Reachable
            
            If LateCondition() Then
                Return "Late"
            End If
            
            Return "Default" ' Reachable
        End Function
        
        Sub GoodReachableLoopWithReturn()
            ' GOOD: Code after loop with conditional return
            For i As Integer = 0 To 10
                If ShouldProcess(i) Then
                    ProcessItem(i)
                End If
                If ShouldExit(i) Then
                    Return ' Only returns if condition is met
                End If
            Next
            FinalizeProcessing() ' Reachable if loop completes without return
        End Sub
        
        Sub GoodReachableAfterRedirectInCondition()
            ' GOOD: Code after conditional redirect is reachable
            If UserNeedsRedirect() Then
                Response.Redirect("other.aspx")
            End If
            ProcessCurrentPage() ' Reachable if no redirect
        End Sub
        
        Sub GoodReachableInSwitchCases()
            ' GOOD: Each case is reachable
            Dim value As Integer = GetValue()
            Select Case value
                Case 1
                    ProcessCase1()
                    Return
                Case 2
                    ProcessCase2() ' Reachable
                    Return
                Case Else
                    ProcessDefault() ' Reachable
            End Select
        End Sub
        
        Sub GoodReachableAfterConditionalTransfer()
            ' GOOD: Code after conditional transfer
            If ShouldTransfer() Then
                Server.Transfer("handler.aspx")
            End If
            ProcessLocally() ' Reachable if no transfer
        End Sub
        
        ' Helper methods and functions
        Sub ProcessData()
        End Sub
        
        Sub CleanupData()
        End Sub
        
        Sub LogMessage(message As String)
        End Sub
        
        Sub ValidateInput()
        End Sub
        
        Sub ProcessValidInput()
        End Sub
        
        Sub SaveData()
        End Sub
        
        Sub LogAccess()
        End Sub
        
        Sub UpdateSession()
        End Sub
        
        Sub ProcessRequest()
        End Sub
        
        Sub CleanupResources()
        End Sub
        
        Sub LogTransfer()
        End Sub
        
        Sub LogSuccess()
        End Sub
        
        Sub LogError(ex As Exception)
        End Sub
        
        Sub CleanupOnError()
        End Sub
        
        Sub ProcessItem(index As Integer)
        End Sub
        
        Sub UpdateDatabase()
        End Sub
        
        Sub SendEmail()
        End Sub
        
        Sub ProcessNested()
        End Sub
        
        Sub ProcessOuter()
        End Sub
        
        Sub ProcessElse()
        End Sub
        
        Sub CleanupAfterTry()
        End Sub
        
        Sub PerformOperation()
        End Sub
        
        Sub RiskyOperation()
        End Sub
        
        Sub HandleError(ex As Exception)
        End Sub
        
        Sub ProcessSuccess()
        End Sub
        
        Sub ProcessMiddle()
        End Sub
        
        Sub FinalizeProcessing()
        End Sub
        
        Sub ProcessCurrentPage()
        End Sub
        
        Sub ProcessCase1()
        End Sub
        
        Sub ProcessCase2()
        End Sub
        
        Sub ProcessDefault()
        End Sub
        
        Sub ProcessLocally()
        End Sub
        
        Function UserAuthorized() As Boolean
            Return True
        End Function
        
        Function HasData() As Boolean
            Return True
        End Function
        
        Function SomeCondition() As Boolean
            Return True
        End Function
        
        Function AnotherCondition() As Boolean
            Return False
        End Function
        
        Function ShouldReturn() As Boolean
            Return False
        End Function
        
        Function HasError() As Boolean
            Return False
        End Function
        
        Function EarlyCondition() As Boolean
            Return False
        End Function
        
        Function LateCondition() As Boolean
            Return False
        End Function
        
        Function ShouldProcess(index As Integer) As Boolean
            Return True
        End Function
        
        Function ShouldExit(index As Integer) As Boolean
            Return False
        End Function
        
        Function UserNeedsRedirect() As Boolean
            Return False
        End Function
        
        Function GetValue() As Integer
            Return 1
        End Function
        
        Function ShouldTransfer() As Boolean
            Return False
        End Function
    </script>
</body>
</html>

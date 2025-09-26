<%@ Page Language="VB" %>
<html>
<head>
    <title>Nested Method Complexity Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Nested method complexity - deeply nested methods with multiple levels of conditions
        
        Sub BadDeeplyNestedMethod()
            ' BAD: Multiple levels of nested if statements
            If condition1 Then
                If condition2 Then
                    If condition3 Then
                        If condition4 Then
                            ProcessData()
                        End If
                    End If
                End If
            End If
        End Sub
        
        Function BadComplexNestedFunction() As String
            ' BAD: Nested conditions with loops
            For i As Integer = 0 To 10
                If i > 5 Then
                    While condition1
                        If condition2 Then
                            If condition3 Then
                                Return "Complex"
                            End If
                        End If
                    End While
                End If
            Next
            Return "Default"
        End Function
        
        Sub BadNestedTryCatchWithConditions()
            ' BAD: Try-catch with nested conditions
            Try
                If condition1 Then
                    If condition2 Then
                        If condition3 Then
                            RiskyOperation()
                        End If
                    End If
                End If
            Catch ex As Exception
                If ex.GetType() = GetType(ArgumentException) Then
                    If ex.Message.Contains("invalid") Then
                        HandleError()
                    End If
                End If
            End Try
        End Sub
        
        Sub BadSelectCaseWithNestedIfs()
            ' BAD: Select case with nested conditions
            Select Case userRole
                Case "Admin"
                    If hasPermission Then
                        If isActive Then
                            If validSession Then
                                GrantAccess()
                            End If
                        End If
                    End If
                Case "User"
                    If hasBasicPermission Then
                        If isActive Then
                            GrantBasicAccess()
                        End If
                    End If
            End Select
        End Sub
        
        Function BadNestedLoopsWithConditions() As Boolean
            ' BAD: Nested loops with multiple conditions
            For i As Integer = 0 To 10
                For j As Integer = 0 To 5
                    While condition1
                        If condition2 Then
                            If condition3 Then
                                Return True
                            End If
                        End If
                    End While
                Next
            Next
            Return False
        End Function
        
        Sub BadComplexBusinessLogic()
            ' BAD: Complex business logic with deep nesting
            If userType = "Premium" Then
                If accountStatus = "Active" Then
                    If paymentStatus = "Current" Then
                        If accessLevel >= 3 Then
                            If featureEnabled Then
                                EnablePremiumFeatures()
                            End If
                        End If
                    End If
                End If
            End If
        End Sub
        
        Function BadNestedValidation() As Boolean
            ' BAD: Deeply nested validation logic
            If Not String.IsNullOrEmpty(input1) Then
                If IsValid(input1) Then
                    If Not String.IsNullOrEmpty(input2) Then
                        If IsValid(input2) Then
                            If CompareInputs(input1, input2) Then
                                If CheckBusinessRules() Then
                                    Return True
                                End If
                            End If
                        End If
                    End If
                End If
            End If
            Return False
        End Function
        
        Sub BadErrorHandlingWithNesting()
            ' BAD: Error handling with deep nesting
            Try
                If connectionAvailable Then
                    If databaseOnline Then
                        While hasMoreData
                            If ProcessRecord() Then
                                If ValidateRecord() Then
                                    SaveRecord()
                                End If
                            End If
                        End While
                    End If
                End If
            Catch ex As Exception
                If ex.GetType() = GetType(SqlException) Then
                    If ex.Number = 2 Then
                        HandleTimeout()
                    End If
                End If
            End Try
        End Sub
        
        ' GOOD: Well-structured methods with reasonable nesting
        
        Sub GoodSimpleMethod()
            ' GOOD: Simple method with minimal nesting
            If condition1 Then
                ProcessData()
            Else
                ProcessAlternative()
            End If
        End Sub
        
        Function GoodEarlyReturn() As String
            ' GOOD: Early return pattern to avoid deep nesting
            If Not condition1 Then Return "Invalid"
            If Not condition2 Then Return "Error"
            If Not condition3 Then Return "Failed"
            
            ProcessData()
            Return "Success"
        End Function
        
        Sub GoodExtractedMethods()
            ' GOOD: Complex logic extracted into separate methods
            If IsValidUser() Then
                ProcessUserRequest()
            Else
                HandleInvalidUser()
            End If
        End Sub
        
        Function GoodValidationWithGuardClauses() As Boolean
            ' GOOD: Guard clauses instead of deep nesting
            If String.IsNullOrEmpty(input1) Then Return False
            If Not IsValid(input1) Then Return False
            If String.IsNullOrEmpty(input2) Then Return False
            If Not IsValid(input2) Then Return False
            
            Return CompareInputs(input1, input2) AndAlso CheckBusinessRules()
        End Function
        
        Sub GoodSeparateErrorHandling()
            ' GOOD: Separate error handling methods
            Try
                ProcessMainLogic()
            Catch ex As Exception
                HandleException(ex)
            End Try
        End Sub
        
        Function GoodSelectCaseWithMethods() As String
            ' GOOD: Select case delegating to separate methods
            Select Case userRole
                Case "Admin"
                    Return ProcessAdminRequest()
                Case "User"
                    Return ProcessUserRequest()
                Case Else
                    Return ProcessGuestRequest()
            End Select
        End Function
        
        Sub GoodLoopWithExtractedLogic()
            ' GOOD: Loop with extracted processing logic
            For Each item In items
                ProcessItem(item)
            Next
        End Sub
        
        Function GoodBusinessLogicExtraction() As Boolean
            ' GOOD: Business logic extracted into separate methods
            If Not IsPremiumUser() Then Return False
            If Not IsAccountActive() Then Return False
            If Not IsPaymentCurrent() Then Return False
            
            Return HasRequiredAccessLevel() AndAlso IsFeatureEnabled()
        End Function
        
        Sub GoodStrategyPattern()
            ' GOOD: Using strategy pattern instead of complex conditions
            Dim processor As IRequestProcessor = GetProcessor(userType)
            processor.ProcessRequest(request)
        End Sub
        
        Function GoodPolymorphicApproach() As String
            ' GOOD: Polymorphic approach instead of nested conditions
            Dim handler As IUserHandler = UserHandlerFactory.Create(userType)
            Return handler.HandleRequest()
        End Function
        
        ' Helper methods for good examples
        Function IsValidUser() As Boolean
            Return Not String.IsNullOrEmpty(userName) AndAlso IsAuthenticated()
        End Function
        
        Sub ProcessUserRequest()
            ' Process user request logic
        End Sub
        
        Sub HandleInvalidUser()
            ' Handle invalid user logic
        End Sub
        
        Function IsValid(input As String) As Boolean
            Return input.Length > 0 AndAlso Not input.Contains("invalid")
        End Function
        
        Function CompareInputs(input1 As String, input2 As String) As Boolean
            Return String.Compare(input1, input2) = 0
        End Function
        
        Function CheckBusinessRules() As Boolean
            Return True ' Business rule validation
        End Function
        
        Sub ProcessMainLogic()
            ' Main processing logic
        End Sub
        
        Sub HandleException(ex As Exception)
            ' Exception handling logic
        End Sub
        
        Function ProcessAdminRequest() As String
            Return "Admin processed"
        End Function
        
        Function ProcessUserRequest() As String
            Return "User processed"
        End Function
        
        Function ProcessGuestRequest() As String
            Return "Guest processed"
        End Function
        
        Sub ProcessItem(item As Object)
            ' Process individual item
        End Sub
        
        Function IsPremiumUser() As Boolean
            Return userType = "Premium"
        End Function
        
        Function IsAccountActive() As Boolean
            Return accountStatus = "Active"
        End Function
        
        Function IsPaymentCurrent() As Boolean
            Return paymentStatus = "Current"
        End Function
        
        Function HasRequiredAccessLevel() As Boolean
            Return accessLevel >= 3
        End Function
        
        Function IsFeatureEnabled() As Boolean
            Return featureEnabled
        End Function
        
        Function IsAuthenticated() As Boolean
            Return True
        End Function
        
        ' Properties and fields for examples
        Private condition1 As Boolean = True
        Private condition2 As Boolean = True
        Private condition3 As Boolean = True
        Private condition4 As Boolean = True
        Private userRole As String = "User"
        Private hasPermission As Boolean = True
        Private isActive As Boolean = True
        Private validSession As Boolean = True
        Private hasBasicPermission As Boolean = True
        Private userType As String = "Premium"
        Private accountStatus As String = "Active"
        Private paymentStatus As String = "Current"
        Private accessLevel As Integer = 5
        Private featureEnabled As Boolean = True
        Private input1 As String = "test1"
        Private input2 As String = "test2"
        Private connectionAvailable As Boolean = True
        Private databaseOnline As Boolean = True
        Private hasMoreData As Boolean = False
        Private userName As String = "testuser"
        Private items As New List(Of Object)()
        Private request As Object = Nothing
        
        ' Interface definitions for good examples
        Interface IRequestProcessor
            Sub ProcessRequest(request As Object)
        End Interface
        
        Interface IUserHandler
            Function HandleRequest() As String
        End Interface
        
        ' Factory for good examples
        Class UserHandlerFactory
            Shared Function Create(userType As String) As IUserHandler
                Return Nothing ' Implementation would return appropriate handler
            End Function
        End Class
        
        Function GetProcessor(userType As String) As IRequestProcessor
            Return Nothing ' Implementation would return appropriate processor
        End Function
        
        ' Stub methods
        Sub ProcessData()
        End Sub
        
        Sub ProcessAlternative()
        End Sub
        
        Sub RiskyOperation()
        End Sub
        
        Sub HandleError()
        End Sub
        
        Sub GrantAccess()
        End Sub
        
        Sub GrantBasicAccess()
        End Sub
        
        Sub EnablePremiumFeatures()
        End Sub
        
        Function ProcessRecord() As Boolean
            Return True
        End Function
        
        Function ValidateRecord() As Boolean
            Return True
        End Function
        
        Sub SaveRecord()
        End Sub
        
        Sub HandleTimeout()
        End Sub
    </script>
</body>
</html>

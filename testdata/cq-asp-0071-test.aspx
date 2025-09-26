<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Return Statements Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing return statements - methods with code paths that don't return values
        
        Function BadMissingReturnExamples() As String
            ' BAD: Function with conditional paths missing return
            If True Then
                ProcessData()
                ' Missing return statement
            End If
        End Function
        
        Function BadMissingReturnWithSelect() As Integer
            ' BAD: Function with Select Case missing return in some paths
            Dim value As Integer = GetValue()
            Select Case value
                Case 1
                    ProcessCase1()
                    ' Missing return statement
                Case 2
                    ProcessCase2()
                    Return 2
                Case Else
                    ProcessDefault()
                    ' Missing return statement
            End Select
        End Function
        
        Function BadMissingReturnWithTry() As Boolean
            ' BAD: Function with try block missing return
            Try
                PerformOperation()
                ' Missing return statement
            Catch ex As Exception
                LogError(ex)
                Return False
            End Try
        End Function
        
        Function BadMissingReturnComplex() As String
            ' BAD: Complex function with missing return
            Dim result As String = ""
            If SomeCondition() Then
                If AnotherCondition() Then
                    result = "Success"
                    Return result
                Else
                    result = "Partial"
                    ' Missing return statement
                End If
            End If
        End Function
        
        Function BadMissingReturnWithLoops() As Integer
            ' BAD: Function with loops but missing return
            For i As Integer = 0 To 10
                If ProcessItem(i) Then
                    Continue For
                End If
                If ShouldExit(i) Then
                    Exit For
                End If
            Next
            ' Missing return statement
        End Function
        
        Function BadMissingReturnNested() As Double
            ' BAD: Nested conditions with missing return
            If HasData() Then
                Try
                    Dim data As Double = CalculateValue()
                    If data > 0 Then
                        ProcessPositive(data)
                        ' Missing return statement
                    Else
                        ProcessNegative(data)
                        Return data
                    End If
                Catch ex As Exception
                    HandleError(ex)
                    ' Missing return statement
                End Try
            End If
        End Function
        
        ' C# style functions (for mixed syntax scenarios)
        Function BadCSharpStyleMissing() As String {
            If (SomeCondition()) {
                ProcessData();
                // Missing return statement
            }
        }
        
        public Function BadPublicFunction() As Integer {
            if (HasValue()) {
                ProcessValue();
                // Missing return statement
            }
            switch (GetType()) {
                case 1:
                    return 1;
                case 2:
                    ProcessType2();
                    // Missing return statement
                default:
                    return 0;
            }
        }
        
        protected Function BadProtectedFunction() As Boolean {
            try {
                PerformTask();
                // Missing return statement
            } catch (Exception ex) {
                LogException(ex);
                return false;
            }
        }
        
        ' GOOD: Proper functions with return statements
        
        Function GoodFunctionWithReturn() As String
            ' GOOD: All paths return values
            If SomeCondition() Then
                Return "Success"
            Else
                Return "Failure"
            End If
        End Function
        
        Function GoodFunctionWithSelectReturn() As Integer
            ' GOOD: All Select Case paths return values
            Dim value As Integer = GetValue()
            Select Case value
                Case 1
                    ProcessCase1()
                    Return 1
                Case 2
                    ProcessCase2()
                    Return 2
                Case Else
                    ProcessDefault()
                    Return 0
            End Select
        End Function
        
        Function GoodFunctionWithTryReturn() As Boolean
            ' GOOD: All try/catch paths return values
            Try
                PerformOperation()
                Return True
            Catch ex As Exception
                LogError(ex)
                Return False
            End Try
        End Function
        
        Function GoodFunctionSimpleReturn() As String
            ' GOOD: Simple function with return
            Dim result As String = ProcessData()
            Return result
        End Function
        
        Function GoodFunctionComplexReturn() As Double
            ' GOOD: Complex function with proper returns
            If HasData() Then
                Try
                    Dim data As Double = CalculateValue()
                    If data > 0 Then
                        ProcessPositive(data)
                        Return data
                    Else
                        ProcessNegative(data)
                        Return data * -1
                    End If
                Catch ex As Exception
                    HandleError(ex)
                    Return 0.0
                End Try
            Else
                Return -1.0
            End If
        End Function
        
        ' GOOD: Sub procedures don't need return statements
        Sub GoodSubProcedure()
            ProcessData()
            If SomeCondition() Then
                ProcessMore()
            End If
        End Sub
        
        Sub GoodSubWithExit()
            If ShouldExit() Then
                Exit Sub
            End If
            ProcessData()
        End Sub
        
        ' GOOD: Functions that end with End Function properly
        Function GoodFunctionWithEndFunction() As String
            ProcessData()
            Return "Complete"
        End Function
        
        Function GoodFunctionWithMultipleReturns() As Integer
            ' GOOD: Multiple return points are fine
            If EarlyExit() Then
                Return -1
            End If
            
            Dim result As Integer = ProcessData()
            If result > 100 Then
                Return 100
            End If
            
            Return result
        End Function
        
        ' Helper methods and functions
        Sub ProcessData()
        End Sub
        
        Sub ProcessCase1()
        End Sub
        
        Sub ProcessCase2()
        End Sub
        
        Sub ProcessDefault()
        End Sub
        
        Sub PerformOperation()
        End Sub
        
        Sub LogError(ex As Exception)
        End Sub
        
        Sub ProcessPositive(value As Double)
        End Sub
        
        Sub ProcessNegative(value As Double)
        End Sub
        
        Sub HandleError(ex As Exception)
        End Sub
        
        Sub ProcessMore()
        End Sub
        
        Sub ProcessValue()
        End Sub
        
        Sub ProcessType2()
        End Sub
        
        Sub PerformTask()
        End Sub
        
        Sub LogException(ex As Exception)
        End Sub
        
        Function GetValue() As Integer
            Return 1
        End Function
        
        Function SomeCondition() As Boolean
            Return True
        End Function
        
        Function AnotherCondition() As Boolean
            Return False
        End Function
        
        Function CalculateValue() As Double
            Return 10.5
        End Function
        
        Function HasData() As Boolean
            Return True
        End Function
        
        Function ShouldExit() As Boolean
            Return False
        End Function
        
        Function ProcessItem(index As Integer) As Boolean
            Return True
        End Function
        
        Function ShouldExit(index As Integer) As Boolean
            Return False
        End Function
        
        Function EarlyExit() As Boolean
            Return False
        End Function
        
        Function ProcessData() As Integer
            Return 42
        End Function
        
        Function ProcessData() As String
            Return "Data"
        End Function
        
        Function HasValue() As Boolean
            Return True
        End Function
        
        Function GetType() As Integer
            Return 1
        End Function
    </script>
</body>
</html>

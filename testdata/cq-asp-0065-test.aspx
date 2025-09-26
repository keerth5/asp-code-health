<%@ Page Language="VB" %>
<html>
<head>
    <title>Division by Zero Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Division by zero risks - mathematical operations without checking for zero divisors
        
        Sub BadDivisionByZeroExamples()
            ' BAD: Simple division without zero check
            Dim numerator As Integer = 10
            Dim denominator As Integer = GetDenominator()
            Dim result = numerator / denominator ' Bad: no zero check
            
            ' BAD: Variable division without validation
            Dim a As Double = GetValueA()
            Dim b As Double = GetValueB()
            Dim quotient = a / b ' Bad: no zero check
            
            ' BAD: User input division without validation
            Dim userInput As String = Request.Form("divisor")
            Dim divisor As Integer = Convert.ToInt32(userInput)
            Dim calculation = 100 / divisor ' Bad: no zero check
            
            ' BAD: Modulo operations without zero check
            Dim number As Integer = GetNumber()
            Dim modValue As Integer = GetModValue()
            Dim remainder = number Mod modValue ' Bad: no zero check for modulo
            
            ' BAD: Math operations without validation
            Dim dividend As Double = GetDividend()
            Dim divisorValue As Double = GetDivisorValue()
            Dim mathResult = Math.DivRem(CInt(dividend), CInt(divisorValue), Nothing) ' Bad: no zero check
        End Sub
        
        Sub MoreBadDivisionExamples()
            ' BAD: Division in expressions without checks
            Dim x As Integer = 20
            Dim y As Integer = GetY()
            Dim formula = (x + 5) / (y - 3) ' Bad: no zero check for denominator expression
            
            ' BAD: Division in loops without validation
            For i As Integer = 1 To 10
                Dim loopDivisor As Integer = GetLoopDivisor(i)
                Dim loopResult = i / loopDivisor ' Bad: no zero check in loop
                ProcessResult(loopResult)
            Next
            
            ' BAD: Property-based division without checks
            Dim config As Configuration = GetConfiguration()
            Dim ratio = config.MaxValue / config.MinValue ' Bad: no zero check for properties
            
            ' BAD: Array element division without validation
            Dim values() As Integer = GetValues()
            Dim arrayResult = values(0) / values(1) ' Bad: no zero check for array elements
        End Sub
        
        ' GOOD: Proper zero checking before division operations
        
        Sub GoodDivisionWithZeroChecks()
            ' GOOD: Simple division with zero check
            Dim numerator As Integer = 10
            Dim denominator As Integer = GetDenominator()
            If denominator <> 0 Then
                Dim result = numerator / denominator ' Good: zero check performed
                ProcessResult(result)
            End If
            
            ' GOOD: Alternative zero check syntax
            If denominator != 0 Then
                Dim result2 = numerator / denominator ' Good: C# style zero check
                ProcessResult(result2)
            End If
        End Sub
        
        Sub GoodVariableDivisionWithValidation()
            ' GOOD: Variable division with validation
            Dim a As Double = GetValueA()
            Dim b As Double = GetValueB()
            If b <> 0 Then
                Dim quotient = a / b ' Good: zero check performed
                ProcessResult(quotient)
            End If
        End Sub
        
        Sub GoodUserInputDivisionWithValidation()
            ' GOOD: User input division with validation
            Dim userInput As String = Request.Form("divisor")
            Dim divisor As Integer
            If Integer.TryParse(userInput, divisor) AndAlso divisor <> 0 Then
                Dim calculation = 100 / divisor ' Good: zero check and parse validation
                ProcessResult(calculation)
            End If
        End Sub
        
        Sub GoodModuloOperationsWithChecks()
            ' GOOD: Modulo operations with zero check
            Dim number As Integer = GetNumber()
            Dim modValue As Integer = GetModValue()
            If modValue <> 0 Then
                Dim remainder = number Mod modValue ' Good: zero check for modulo
                ProcessResult(remainder)
            End If
        End Sub
        
        Sub GoodMathOperationsWithValidation()
            ' GOOD: Math operations with validation
            Dim dividend As Double = GetDividend()
            Dim divisorValue As Double = GetDivisorValue()
            If divisorValue <> 0 Then
                Dim mathResult = Math.DivRem(CInt(dividend), CInt(divisorValue), Nothing) ' Good: zero check
                ProcessResult(mathResult)
            End If
        End Sub
        
        Sub GoodExpressionDivisionWithChecks()
            ' GOOD: Division in expressions with checks
            Dim x As Integer = 20
            Dim y As Integer = GetY()
            If (y - 3) <> 0 Then
                Dim formula = (x + 5) / (y - 3) ' Good: zero check for denominator expression
                ProcessResult(formula)
            End If
        End Sub
        
        Sub GoodLoopDivisionWithValidation()
            ' GOOD: Division in loops with validation
            For i As Integer = 1 To 10
                Dim loopDivisor As Integer = GetLoopDivisor(i)
                If loopDivisor <> 0 Then
                    Dim loopResult = i / loopDivisor ' Good: zero check in loop
                    ProcessResult(loopResult)
                End If
            Next
        End Sub
        
        Sub GoodPropertyDivisionWithChecks()
            ' GOOD: Property-based division with checks
            Dim config As Configuration = GetConfiguration()
            If config IsNot Nothing AndAlso config.MinValue <> 0 Then
                Dim ratio = config.MaxValue / config.MinValue ' Good: zero check for properties
                ProcessResult(ratio)
            End If
        End Sub
        
        Sub GoodArrayElementDivisionWithValidation()
            ' GOOD: Array element division with validation
            Dim values() As Integer = GetValues()
            If values IsNot Nothing AndAlso values.Length >= 2 AndAlso values(1) <> 0 Then
                Dim arrayResult = values(0) / values(1) ' Good: zero check for array elements
                ProcessResult(arrayResult)
            End If
        End Sub
        
        Sub GoodTryPatternForDivision()
            ' GOOD: Using try-catch for division protection
            Dim numerator As Integer = GetNumerator()
            Dim denominator As Integer = GetDenominator()
            
            Try
                Dim result = numerator / denominator ' Good: protected by try-catch
                ProcessResult(result)
            Catch ex As DivideByZeroException
                ' Handle division by zero appropriately
                LogError("Division by zero attempted")
                ProcessResult(0) ' Or appropriate default value
            End Try
        End Sub
        
        Sub GoodSafeDivisionFunction()
            ' GOOD: Safe division function
            Dim a As Double = GetValueA()
            Dim b As Double = GetValueB()
            Dim result = SafeDivide(a, b) ' Good: using safe division function
            ProcessResult(result)
        End Sub
        
        Sub GoodNullableArithmeticWithChecks()
            ' GOOD: Nullable arithmetic with proper checks
            Dim nullableA As Double? = GetNullableA()
            Dim nullableB As Double? = GetNullableB()
            
            If nullableA.HasValue AndAlso nullableB.HasValue AndAlso nullableB.Value <> 0 Then
                Dim result = nullableA.Value / nullableB.Value ' Good: null and zero checks
                ProcessResult(result)
            End If
        End Sub
        
        Sub GoodConstantDivision()
            ' GOOD: Division by non-zero constants is safe
            Dim value As Integer = GetValue()
            Dim result1 = value / 2 ' Good: division by non-zero constant
            Dim result2 = value / 10 ' Good: division by non-zero constant
            Dim result3 = value / Math.PI ' Good: division by mathematical constant
            
            ProcessResult(result1)
            ProcessResult(result2)
            ProcessResult(result3)
        End Sub
        
        Function SafeDivide(numerator As Double, denominator As Double) As Double
            ' GOOD: Safe division utility function
            If denominator = 0 Then
                Return 0 ' Or throw appropriate exception
            Else
                Return numerator / denominator ' Good: zero check performed
            End If
        End Function
        
        Function SafeDivideWithDefault(numerator As Double, denominator As Double, defaultValue As Double) As Double
            ' GOOD: Safe division with default value
            If denominator = 0 Then
                Return defaultValue ' Good: return default instead of error
            Else
                Return numerator / denominator ' Good: zero check performed
            End If
        End Function
        
        ' Helper methods and classes
        Function GetDenominator() As Integer
            Return 5
        End Function
        
        Function GetValueA() As Double
            Return 10.5
        End Function
        
        Function GetValueB() As Double
            Return 2.0
        End Function
        
        Function GetNumber() As Integer
            Return 15
        End Function
        
        Function GetModValue() As Integer
            Return 4
        End Function
        
        Function GetDividend() As Double
            Return 20.0
        End Function
        
        Function GetDivisorValue() As Double
            Return 4.0
        End Function
        
        Function GetY() As Integer
            Return 8
        End Function
        
        Function GetLoopDivisor(index As Integer) As Integer
            Return index
        End Function
        
        Function GetConfiguration() As Configuration
            Return New Configuration()
        End Function
        
        Function GetValues() As Integer()
            Return New Integer() {10, 5, 2}
        End Function
        
        Function GetNumerator() As Integer
            Return 15
        End Function
        
        Function GetNullableA() As Double?
            Return 10.0
        End Function
        
        Function GetNullableB() As Double?
            Return 2.0
        End Function
        
        Function GetValue() As Integer
            Return 100
        End Function
        
        Sub ProcessResult(result As Object)
        End Sub
        
        Sub LogError(message As String)
        End Sub
        
        Public Class Configuration
            Public Property MaxValue As Integer = 100
            Public Property MinValue As Integer = 10
        End Class
    </script>
</body>
</html>

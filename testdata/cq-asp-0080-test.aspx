<%@ Page Language="VB" %>
<html>
<head>
    <title>Implicit Type Conversions Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Implicit type conversions - relying on implicit conversions that may cause data loss
        
        Sub BadImplicitNarrowingConversions()
            ' BAD: Double to Integer - potential data loss
            Dim doubleValue As Double = 123.456
            Dim intValue As Integer = doubleValue ' Implicit narrowing conversion
            ProcessInteger(intValue)
            
            ' BAD: Decimal to Integer - precision loss
            Dim decimalValue As Decimal = 999.99D
            Dim intFromDecimal As Integer = decimalValue ' Data loss
            CalculateTotal(intFromDecimal)
            
            ' BAD: Long to Integer - potential overflow
            Dim longValue As Long = 2147483648L ' Exceeds Integer.MaxValue
            Dim intFromLong As Integer = longValue ' Overflow risk
            ProcessValue(intFromLong)
        End Sub
        
        Sub BadImplicitWideningThenNarrowing()
            ' BAD: Single to Double then back to Integer
            Dim singleValue As Single = 123.45F
            Dim doubleFromSingle As Double = singleValue ' Widening OK
            Dim intFromDouble As Integer = doubleFromSingle ' BAD: Narrowing without explicit conversion
            HandleNumber(intFromDouble)
            
            ' BAD: Integer to Long then to Integer
            Dim originalInt As Integer = 42
            Dim longFromInt As Long = originalInt ' Widening OK
            Dim backToInt As Integer = longFromInt ' BAD: Implicit narrowing
            ProcessResult(backToInt)
        End Sub
        
        Sub BadStringConversions()
            ' BAD: Numeric to String without explicit conversion
            Dim intValue As Integer = 123
            Dim stringFromInt As String = intValue ' Implicit conversion
            DisplayMessage(stringFromInt)
            
            ' BAD: Double to String without ToString
            Dim doubleValue As Double = 456.789
            Dim stringFromDouble As String = doubleValue ' Implicit conversion
            LogValue(stringFromDouble)
            
            ' BAD: Boolean to String without explicit conversion
            Dim boolValue As Boolean = True
            Dim stringFromBool As String = boolValue ' Implicit conversion
            SaveFlag(stringFromBool)
            
            ' BAD: Decimal to String without formatting control
            Dim decimalValue As Decimal = 999.99D
            Dim stringFromDecimal As String = decimalValue ' No format control
            FormatCurrency(stringFromDecimal)
        End Sub
        
        Sub BadMixedTypeOperations()
            ' BAD: Mixed type arithmetic with implicit conversions
            Dim intValue As Integer = 10
            Dim doubleValue As Double = 3.14
            Dim result As Integer = intValue + doubleValue ' BAD: Double to Integer conversion
            ProcessCalculation(result)
            
            ' BAD: Decimal and Integer mixing
            Dim decimalAmount As Decimal = 100.50D
            Dim intQuantity As Integer = 3
            Dim total As Integer = decimalAmount * intQuantity ' BAD: Decimal to Integer
            CalculateTotal(total)
        End Sub
        
        Sub BadObjectConversions()
            ' BAD: Object to specific type without explicit casting
            Dim objValue As Object = 123.45
            Dim doubleFromObj As Double = objValue ' Implicit conversion
            ProcessDouble(doubleFromObj)
            
            ' BAD: Object to Integer
            Dim objInt As Object = GetObjectValue()
            Dim intFromObj As Integer = objInt ' BAD: No type checking
            HandleInteger(intFromObj)
        End Sub
        
        Sub BadVariantTypeConversions()
            ' BAD: Using Variant-style conversions (VB.NET legacy)
            Dim varValue As Object = "123"
            Dim intFromVar As Integer = varValue ' BAD: String to Integer implicit
            ProcessNumber(intFromVar)
            
            ' BAD: Mixed types in calculations
            Dim value1 As Object = 10
            Dim value2 As Object = "20"
            Dim result As Integer = value1 + value2 ' BAD: String concatenation then to Integer
            CalculateSum(result)
        End Sub
        
        ' BAD: C# style implicit conversions
        void BadCSharpImplicitConversions() {
            // BAD: Double to int without explicit cast
            double doubleVal = 123.456;
            int intVal = doubleVal; // Implicit narrowing
            
            // BAD: Long to int
            long longVal = 2147483648L;
            int intFromLong = longVal; // Potential overflow
            
            // BAD: Decimal to int
            decimal decimalVal = 999.99m;
            int intFromDecimal = decimalVal; // Data loss
        }
        
        ' GOOD: Explicit type conversions with proper handling
        
        Sub GoodExplicitConversions()
            ' GOOD: Explicit conversion with Convert methods
            Dim doubleValue As Double = 123.456
            Dim intValue As Integer = Convert.ToInt32(doubleValue) ' Explicit conversion
            ProcessInteger(intValue)
            
            ' GOOD: Explicit casting with CType
            Dim decimalValue As Decimal = 999.99D
            Dim intFromDecimal As Integer = CType(decimalValue, Integer) ' Explicit cast
            CalculateTotal(intFromDecimal)
            
            ' GOOD: Explicit conversion with range checking
            Dim longValue As Long = 2147483648L
            If longValue <= Integer.MaxValue AndAlso longValue >= Integer.MinValue Then
                Dim intFromLong As Integer = CType(longValue, Integer)
                ProcessValue(intFromLong)
            Else
                HandleOverflow()
            End If
        End Sub
        
        Sub GoodStringConversions()
            ' GOOD: Explicit ToString with formatting
            Dim intValue As Integer = 123
            Dim stringFromInt As String = intValue.ToString() ' Explicit conversion
            DisplayMessage(stringFromInt)
            
            ' GOOD: ToString with format specifier
            Dim doubleValue As Double = 456.789
            Dim stringFromDouble As String = doubleValue.ToString("F2") ' Formatted conversion
            LogValue(stringFromDouble)
            
            ' GOOD: Boolean ToString
            Dim boolValue As Boolean = True
            Dim stringFromBool As String = boolValue.ToString() ' Explicit conversion
            SaveFlag(stringFromBool)
            
            ' GOOD: Decimal with currency formatting
            Dim decimalValue As Decimal = 999.99D
            Dim stringFromDecimal As String = decimalValue.ToString("C") ' Currency format
            FormatCurrency(stringFromDecimal)
        End Sub
        
        Sub GoodMixedTypeOperations()
            ' GOOD: Explicit conversions in mixed operations
            Dim intValue As Integer = 10
            Dim doubleValue As Double = 3.14
            Dim result As Integer = intValue + Convert.ToInt32(doubleValue) ' Explicit conversion
            ProcessCalculation(result)
            
            ' GOOD: Convert to common type for operations
            Dim decimalAmount As Decimal = 100.50D
            Dim intQuantity As Integer = 3
            Dim total As Decimal = decimalAmount * Convert.ToDecimal(intQuantity) ' Explicit conversion
            ProcessDecimalTotal(total)
        End Sub
        
        Sub GoodObjectConversions()
            ' GOOD: Safe casting with type checking
            Dim objValue As Object = 123.45
            If TypeOf objValue Is Double Then
                Dim doubleFromObj As Double = CType(objValue, Double)
                ProcessDouble(doubleFromObj)
            End If
            
            ' GOOD: TryCast for reference types
            Dim objInt As Object = GetObjectValue()
            If objInt IsNot Nothing AndAlso IsNumeric(objInt) Then
                Dim intFromObj As Integer = Convert.ToInt32(objInt)
                HandleInteger(intFromObj)
            End If
        End Sub
        
        Sub GoodTryParseConversions()
            ' GOOD: Use TryParse for safe string conversions
            Dim stringValue As String = "123"
            Dim intResult As Integer
            If Integer.TryParse(stringValue, intResult) Then
                ProcessNumber(intResult)
            Else
                HandleInvalidNumber()
            End If
            
            ' GOOD: TryParse with culture info
            Dim doubleString As String = "123.45"
            Dim doubleResult As Double
            If Double.TryParse(doubleString, NumberStyles.Float, CultureInfo.InvariantCulture, doubleResult) Then
                ProcessDouble(doubleResult)
            End If
        End Sub
        
        Sub GoodValidatedConversions()
            ' GOOD: Validate before conversion
            Dim sourceValue As Object = GetDynamicValue()
            
            Select Case True
                Case TypeOf sourceValue Is Integer
                    Dim intVal As Integer = CType(sourceValue, Integer)
                    ProcessInteger(intVal)
                Case TypeOf sourceValue Is Double
                    Dim dblVal As Double = CType(sourceValue, Double)
                    ProcessDouble(dblVal)
                Case TypeOf sourceValue Is String
                    Dim strVal As String = CType(sourceValue, String)
                    ProcessString(strVal)
                Case Else
                    HandleUnknownType()
            End Select
        End Sub
        
        ' GOOD: C# style explicit conversions
        void GoodCSharpExplicitConversions() {
            // GOOD: Explicit cast with Convert
            double doubleVal = 123.456;
            int intVal = Convert.ToInt32(doubleVal);
            
            // GOOD: Explicit cast with range check
            long longVal = 2147483648L;
            if (longVal <= int.MaxValue && longVal >= int.MinValue) {
                int intFromLong = (int)longVal;
            }
            
            // GOOD: Explicit cast with CType equivalent
            decimal decimalVal = 999.99m;
            int intFromDecimal = (int)decimalVal; // Explicit cast
        }
        
        Sub GoodGenericConversions(Of T)()
            ' GOOD: Generic type conversions with constraints
            Dim value As T = GetGenericValue(Of T)()
            Dim result As String = value.ToString() ' Safe conversion to string
            ProcessGenericResult(result)
        End Sub
        
        Function GoodSafeConversion(Of TSource, TTarget)(source As TSource) As TTarget?
            ' GOOD: Generic safe conversion method
            Try
                If GetType(TTarget) = GetType(String) Then
                    Return CType(CObj(source.ToString()), TTarget)
                ElseIf IsNumeric(source) Then
                    Return CType(Convert.ChangeType(source, GetType(TTarget)), TTarget)
                Else
                    Return Nothing
                End If
            Catch
                Return Nothing
            End Try
        End Function
        
        Sub GoodNullableConversions()
            ' GOOD: Working with nullable types
            Dim nullableInt As Integer? = GetNullableInteger()
            If nullableInt.HasValue Then
                Dim stringValue As String = nullableInt.Value.ToString()
                ProcessString(stringValue)
            End If
            
            ' GOOD: Safe conversion with null checking
            Dim nullableDouble As Double? = GetNullableDouble()
            Dim result As String = If(nullableDouble?.ToString(), "N/A")
            DisplayResult(result)
        End Sub
        
        ' Helper methods
        Sub ProcessInteger(value As Integer)
        End Sub
        
        Sub CalculateTotal(value As Integer)
        End Sub
        
        Sub ProcessValue(value As Integer)
        End Sub
        
        Sub HandleNumber(value As Integer)
        End Sub
        
        Sub ProcessResult(value As Integer)
        End Sub
        
        Sub DisplayMessage(message As String)
        End Sub
        
        Sub LogValue(value As String)
        End Sub
        
        Sub SaveFlag(flag As String)
        End Sub
        
        Sub FormatCurrency(currency As String)
        End Sub
        
        Sub ProcessCalculation(result As Integer)
        End Sub
        
        Sub ProcessDecimalTotal(total As Decimal)
        End Sub
        
        Sub ProcessDouble(value As Double)
        End Sub
        
        Sub HandleInteger(value As Integer)
        End Sub
        
        Sub ProcessNumber(value As Integer)
        End Sub
        
        Sub CalculateSum(sum As Integer)
        End Sub
        
        Sub HandleOverflow()
        End Sub
        
        Sub HandleInvalidNumber()
        End Sub
        
        Sub ProcessString(value As String)
        End Sub
        
        Sub HandleUnknownType()
        End Sub
        
        Sub ProcessGenericResult(result As String)
        End Sub
        
        Sub DisplayResult(result As String)
        End Sub
        
        Function GetObjectValue() As Object
            Return 42
        End Function
        
        Function GetDynamicValue() As Object
            Return "123"
        End Function
        
        Function GetGenericValue(Of T)() As T
            Return Nothing
        End Function
        
        Function GetNullableInteger() As Integer?
            Return 42
        End Function
        
        Function GetNullableDouble() As Double?
            Return 3.14
        End Function
    </script>
</body>
</html>

<%@ Page Language="VB" %>
<html>
<head>
    <title>Type Casting Issues Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Unsafe type casting without proper validation
        
        Sub BadTypeCastingExamples()
            ' BAD: Direct casting without type checking
            Dim obj As Object = GetObject()
            Dim str As String = CType(obj, String) ' Bad: no type validation
            Dim num As Integer = CType(obj, Integer) ' Bad: no type validation
            Dim customer As Customer = CType(obj, Customer) ' Bad: no type validation
            
            ' BAD: C# style casting without validation
            Dim objValue As Object = GetValue()
            Dim intValue As Integer = CInt(objValue) ' Bad: no validation
            Dim stringValue As String = CStr(objValue) ' Bad: no validation
            Dim dateValue As Date = CDate(objValue) ' Bad: no validation
            
            ' BAD: Convert methods without validation
            Dim userInput As String = GetUserInput()
            Dim convertedInt = Convert.ToInt32(userInput) ' Bad: no validation
            Dim convertedDouble = Convert.ToDouble(userInput) ' Bad: no validation
            Dim convertedDate = Convert.ToDateTime(userInput) ' Bad: no validation
            Dim convertedBool = Convert.ToBoolean(userInput) ' Bad: no validation
        End Sub
        
        Sub MoreBadCastingExamples()
            ' BAD: Array element casting without validation
            Dim objects() As Object = GetObjectArray()
            Dim firstString = CType(objects(0), String) ' Bad: no type check
            Dim secondInt = CType(objects(1), Integer) ' Bad: no type check
            
            ' BAD: Collection casting without validation
            Dim list As ArrayList = GetArrayList()
            For Each item As Object In list
                Dim typedItem = CType(item, String) ' Bad: no type validation in loop
                ProcessString(typedItem)
            Next
            
            ' BAD: Session/ViewState casting without validation
            Dim sessionObj = Session("UserData")
            Dim userData = CType(sessionObj, UserData) ' Bad: no type check
            
            Dim viewStateObj = ViewState("Settings")
            Dim settings = CType(viewStateObj, Settings) ' Bad: no type check
        End Sub
        
        ' GOOD: Safe type casting with proper validation
        
        Sub GoodTypeCastingExamples()
            ' GOOD: Type checking before casting
            Dim obj As Object = GetObject()
            If TypeOf obj Is String Then
                Dim str As String = CType(obj, String) ' Good: type check performed
            End If
            
            If TypeOf obj Is Integer Then
                Dim num As Integer = CType(obj, Integer) ' Good: type check performed
            End If
            
            If TypeOf obj Is Customer Then
                Dim customer As Customer = CType(obj, Customer) ' Good: type check performed
            End If
        End Sub
        
        Sub GoodConvertMethodsWithValidation()
            ' GOOD: Using TryParse methods
            Dim userInput As String = GetUserInput()
            Dim intResult As Integer
            If Integer.TryParse(userInput, intResult) Then
                ' Use intResult safely - Good: TryParse used
                ProcessInteger(intResult)
            End If
            
            Dim doubleResult As Double
            If Double.TryParse(userInput, doubleResult) Then
                ' Use doubleResult safely - Good: TryParse used
                ProcessDouble(doubleResult)
            End If
            
            Dim dateResult As Date
            If Date.TryParse(userInput, dateResult) Then
                ' Use dateResult safely - Good: TryParse used
                ProcessDate(dateResult)
            End If
        End Sub
        
        Sub GoodValidationBeforeConvert()
            ' GOOD: Validation before Convert methods
            Dim userInput As String = GetUserInput()
            
            If IsNumeric(userInput) Then
                Dim convertedInt = Convert.ToInt32(userInput) ' Good: IsNumeric check
                ProcessInteger(convertedInt)
            End If
            
            If IsDate(userInput) Then
                Dim convertedDate = Convert.ToDateTime(userInput) ' Good: IsDate check
                ProcessDate(convertedDate)
            End If
        End Sub
        
        Sub GoodTryCatchForCasting()
            ' GOOD: Using try-catch for type conversion protection
            Dim obj As Object = GetObject()
            Try
                Dim customer As Customer = CType(obj, Customer) ' Good: protected by try-catch
                ProcessCustomer(customer)
            Catch ex As InvalidCastException
                ' Handle cast exception appropriately
                LogError("Invalid cast attempted")
            End Try
        End Sub
        
        Sub GoodArrayAndCollectionCasting()
            ' GOOD: Safe array element casting
            Dim objects() As Object = GetObjectArray()
            For i As Integer = 0 To objects.Length - 1
                If TypeOf objects(i) Is String Then
                    Dim stringItem = CType(objects(i), String) ' Good: type check performed
                    ProcessString(stringItem)
                End If
            Next
            
            ' GOOD: Safe collection casting
            Dim list As ArrayList = GetArrayList()
            For Each item As Object In list
                If TypeOf item Is String Then
                    Dim typedItem = CType(item, String) ' Good: type validation in loop
                    ProcessString(typedItem)
                End If
            Next
        End Sub
        
        Sub GoodSessionAndViewStateCasting()
            ' GOOD: Session/ViewState casting with validation
            Dim sessionObj = Session("UserData")
            If sessionObj IsNot Nothing AndAlso TypeOf sessionObj Is UserData Then
                Dim userData = CType(sessionObj, UserData) ' Good: type check performed
                ProcessUserData(userData)
            End If
            
            Dim viewStateObj = ViewState("Settings")
            If viewStateObj IsNot Nothing AndAlso TypeOf viewStateObj Is Settings Then
                Dim settings = CType(viewStateObj, Settings) ' Good: type check performed
                ProcessSettings(settings)
            End If
        End Sub
        
        Sub GoodGetTypeValidation()
            ' GOOD: Using GetType for validation
            Dim obj As Object = GetObject()
            If obj.GetType() Is GetType(String) Then
                Dim str = CType(obj, String) ' Good: GetType validation
                ProcessString(str)
            End If
            
            If obj.GetType().Equals(GetType(Integer)) Then
                Dim num = CType(obj, Integer) ' Good: GetType validation
                ProcessInteger(num)
            End If
        End Sub
        
        Sub GoodAsOperatorPattern()
            ' GOOD: Using TryCast (VB.NET equivalent of C# 'as' operator)
            Dim obj As Object = GetObject()
            Dim customer As Customer = TryCast(obj, Customer)
            If customer IsNot Nothing Then
                ' Safe to use customer - Good: TryCast used
                ProcessCustomer(customer)
            End If
            
            Dim stringValue As String = TryCast(obj, String)
            If stringValue IsNot Nothing Then
                ' Safe to use stringValue - Good: TryCast used
                ProcessString(stringValue)
            End If
        End Sub
        
        Sub GoodDirectCastWithValidation()
            ' GOOD: DirectCast with prior validation
            Dim obj As Object = GetObject()
            If obj IsNot Nothing AndAlso obj.GetType() Is GetType(Customer) Then
                Dim customer As Customer = DirectCast(obj, Customer) ' Good: type validated
                ProcessCustomer(customer)
            End If
        End Sub
        
        Sub GoodGenericCasting()
            ' GOOD: Generic type casting with validation
            Dim genericObj As Object = GetGenericObject()
            If TypeOf genericObj Is List(Of String) Then
                Dim stringList = CType(genericObj, List(Of String)) ' Good: type check
                ProcessStringList(stringList)
            End If
        End Sub
        
        ' Helper methods and classes
        Function GetObject() As Object
            Return "test string"
        End Function
        
        Function GetValue() As Object
            Return 42
        End Function
        
        Function GetUserInput() As String
            Return "123"
        End Function
        
        Function GetObjectArray() As Object()
            Return New Object() {"string", 42, New Customer()}
        End Function
        
        Function GetArrayList() As ArrayList
            Dim list As New ArrayList()
            list.Add("item1")
            list.Add("item2")
            Return list
        End Function
        
        Function GetGenericObject() As Object
            Return New List(Of String)()
        End Function
        
        Sub ProcessString(str As String)
        End Sub
        
        Sub ProcessInteger(num As Integer)
        End Sub
        
        Sub ProcessDouble(dbl As Double)
        End Sub
        
        Sub ProcessDate(dt As Date)
        End Sub
        
        Sub ProcessCustomer(customer As Customer)
        End Sub
        
        Sub ProcessUserData(userData As UserData)
        End Sub
        
        Sub ProcessSettings(settings As Settings)
        End Sub
        
        Sub ProcessStringList(list As List(Of String))
        End Sub
        
        Sub LogError(message As String)
        End Sub
        
        ' Helper classes
        Public Class Customer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Public Class UserData
            Public Property UserId As Integer
            Public Property UserName As String
        End Class
        
        Public Class Settings
            Public Property Theme As String
            Public Property Language As String
        End Class
    </script>
</body>
</html>

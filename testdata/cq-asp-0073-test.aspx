<%@ Page Language="VB" %>
<html>
<head>
    <title>Variable Shadowing Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Variable shadowing - local variables hiding class-level or outer scope variables
        
        Private memberVariable As String = "Member"
        Protected protectedValue As Integer = 100
        Public publicData As Boolean = True
        
        Sub BadShadowingInMethod()
            ' BAD: Local variable shadows member variable
            Dim memberVariable As String = "Local" ' Shadows class member
            ProcessData(memberVariable)
            
            ' BAD: Another local variable shadows protected member
            Dim protectedValue As Integer = 200 ' Shadows protected member
            Calculate(protectedValue)
            
            ' BAD: Local variable shadows public member
            Dim publicData As Boolean = False ' Shadows public member
            ValidateData(publicData)
        End Sub
        
        Function BadShadowingInFunction() As String
            ' BAD: Function parameter shadows member
            Dim memberVariable As String = "Function Local" ' Shadows member
            Return memberVariable
        End Function
        
        Sub BadShadowingInForLoop()
            ' BAD: For loop variable shadows member, then local variable shadows loop variable
            For memberVariable As Integer = 0 To 10 ' Shadows member (if member was Integer)
                ProcessItem(memberVariable)
                
                ' BAD: Inner scope variable shadows loop variable
                If memberVariable > 5 Then
                    Dim memberVariable As String = "Inner" ' Shadows loop variable
                    LogMessage(memberVariable)
                End If
            Next
        End Sub
        
        Sub BadShadowingInForEach()
            ' BAD: ForEach variable shadows member, then nested variable shadows it
            Dim items As New List(Of String)()
            For Each memberVariable In items ' Shadows member variable
                ProcessString(memberVariable)
                
                ' BAD: Nested variable shadows foreach variable
                If memberVariable.Length > 0 Then
                    Dim memberVariable As Integer = memberVariable.Length ' Shadows foreach var
                    ProcessLength(memberVariable)
                End If
            Next
        End Sub
        
        Sub BadNestedShadowing()
            ' BAD: Multiple levels of shadowing
            Dim value As String = "Outer"
            
            If True Then
                Dim value As String = "Middle" ' Shadows outer variable
                ProcessValue(value)
                
                If True Then
                    Dim value As Integer = 42 ' Shadows middle variable
                    ProcessNumber(value)
                End If
            End If
        End Sub
        
        Class BadShadowingClass
            Private classField As String = "Class Field"
            Protected baseValue As Integer = 50
            
            Sub BadMethodShadowing()
                ' BAD: Local variable shadows class field
                Dim classField As String = "Method Local" ' Shadows class field
                UseField(classField)
                
                ' BAD: Local variable shadows base value
                Dim baseValue As Double = 75.5 ' Shadows base value
                ProcessBase(baseValue)
            End Sub
            
            Function BadFunctionShadowing() As String
                ' BAD: Function local shadows class field
                Dim classField As Integer = 123 ' Shadows class field (different type)
                Return classField.ToString()
            End Function
            
            Sub BadParameterShadowing(classField As String) ' BAD: Parameter shadows class field
                ProcessParameter(classField)
                
                ' BAD: Local variable also shadows the parameter and class field
                Dim classField As Boolean = True ' Shadows parameter and class field
                ValidateFlag(classField)
            End Sub
        End Class
        
        ' More complex shadowing scenarios
        
        Sub BadComplexShadowing()
            Dim counter As Integer = 0
            
            ' BAD: For loop variable shadows outer variable
            For counter As Integer = 1 To 10 ' Shadows outer counter
                ProcessCount(counter)
                
                ' BAD: Nested loop also shadows
                For counter As Integer = 1 To 5 ' Shadows both outer and loop counter
                    ProcessNestedCount(counter)
                Next
            Next
        End Sub
        
        Sub BadShadowingWithDifferentTypes()
            ' BAD: Shadowing with different types
            Dim data As String = "Original"
            
            If True Then
                Dim data As Integer = 42 ' Shadows string with integer
                ProcessNumber(data)
                
                If True Then
                    Dim data As Boolean = False ' Shadows integer with boolean
                    ProcessFlag(data)
                End If
            End If
        End Sub
        
        ' GOOD: No variable shadowing
        
        Sub GoodNoShadowing()
            ' GOOD: Using different variable names
            Dim localMember As String = "Local"
            Dim localProtected As Integer = 200
            Dim localPublic As Boolean = False
            
            ProcessData(localMember)
            Calculate(localProtected)
            ValidateData(localPublic)
        End Sub
        
        Sub GoodUsingMemberDirectly()
            ' GOOD: Using member variables directly
            ProcessData(memberVariable)
            Calculate(protectedValue)
            ValidateData(publicData)
        End Sub
        
        Sub GoodQualifiedMemberAccess()
            ' GOOD: Using qualified access to avoid confusion
            Dim localValue As String = "Local"
            ProcessData(Me.memberVariable) ' Qualified access to member
            ProcessData(localValue) ' Local variable
        End Sub
        
        Sub GoodScopedVariables()
            ' GOOD: Variables in different scopes with different names
            Dim outerValue As String = "Outer"
            
            If True Then
                Dim innerValue As String = "Inner" ' Different name
                ProcessValue(outerValue) ' Access outer scope
                ProcessValue(innerValue) ' Access inner scope
            End If
        End Sub
        
        Sub GoodForLoopVariables()
            ' GOOD: Loop variables with unique names
            For outerIndex As Integer = 0 To 10
                ProcessItem(outerIndex)
                
                For innerIndex As Integer = 0 To 5 ' Different name
                    ProcessNestedItem(innerIndex)
                Next
            Next
        End Sub
        
        Function GoodFunctionWithUniqueLocals() As String
            ' GOOD: Function locals with unique names
            Dim functionLocal As String = "Function"
            Dim anotherLocal As Integer = 42
            Return functionLocal & anotherLocal.ToString()
        End Function
        
        Class GoodNoShadowingClass
            Private classData As String = "Class"
            Protected baseNumber As Integer = 100
            
            Sub GoodMethodWithUniqueNames()
                ' GOOD: Method locals with unique names
                Dim methodData As String = "Method" ' Different from classData
                Dim methodNumber As Integer = 200 ' Different from baseNumber
                
                UseData(classData, methodData) ' Can access both
                UseNumbers(baseNumber, methodNumber) ' Can access both
            End Sub
            
            Sub GoodParameterNames(inputData As String, inputNumber As Integer)
                ' GOOD: Parameters with unique names
                ProcessInput(inputData, inputNumber)
                ProcessClass(classData, baseNumber)
            End Sub
            
            Function GoodFunctionAccess() As String
                ' GOOD: Accessing class members and locals with different names
                Dim result As String = classData & "_processed"
                Return result
            End Function
        End Class
        
        Sub GoodNestedScopesWithUniqueNames()
            ' GOOD: Nested scopes with unique variable names
            Dim level1 As String = "Level 1"
            
            If True Then
                Dim level2 As String = "Level 2"
                
                If True Then
                    Dim level3 As String = "Level 3"
                    ProcessLevels(level1, level2, level3) ' All accessible
                End If
            End If
        End Sub
        
        ' Helper methods
        Sub ProcessData(data As String)
        End Sub
        
        Sub Calculate(value As Integer)
        End Sub
        
        Sub ValidateData(flag As Boolean)
        End Sub
        
        Sub ProcessItem(index As Integer)
        End Sub
        
        Sub LogMessage(message As String)
        End Sub
        
        Sub ProcessString(text As String)
        End Sub
        
        Sub ProcessLength(length As Integer)
        End Sub
        
        Sub ProcessValue(value As String)
        End Sub
        
        Sub ProcessNumber(number As Integer)
        End Sub
        
        Sub UseField(field As String)
        End Sub
        
        Sub ProcessBase(value As Double)
        End Sub
        
        Sub ProcessParameter(param As String)
        End Sub
        
        Sub ValidateFlag(flag As Boolean)
        End Sub
        
        Sub ProcessCount(count As Integer)
        End Sub
        
        Sub ProcessNestedCount(count As Integer)
        End Sub
        
        Sub ProcessFlag(flag As Boolean)
        End Sub
        
        Sub ProcessNestedItem(index As Integer)
        End Sub
        
        Sub UseData(class As String, method As String)
        End Sub
        
        Sub UseNumbers(base As Integer, method As Integer)
        End Sub
        
        Sub ProcessInput(data As String, number As Integer)
        End Sub
        
        Sub ProcessClass(data As String, number As Integer)
        End Sub
        
        Sub ProcessLevels(l1 As String, l2 As String, l3 As String)
        End Sub
    </script>
</body>
</html>

<%@ Page Language="VB" %>
<html>
<head>
    <title>High Cyclomatic Complexity Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: High cyclomatic complexity method
        Sub BadComplexMethod(value As Integer)
            If value > 0 Then
                If value < 10 Then
                    If value = 1 Then
                        Response.Write("One")
                    ElseIf value = 2 Then
                        Response.Write("Two")
                    ElseIf value = 3 Then
                        Response.Write("Three")
                    End If
                End If
            End If
            
            For i As Integer = 1 To 10
                If i Mod 2 = 0 Then
                    Response.Write("Even")
                Else
                    Response.Write("Odd")
                End If
            Next
            
            Select Case value
                Case 1
                    Response.Write("Case 1")
                Case 2
                    Response.Write("Case 2")
                Case 3
                    Response.Write("Case 3")
                Case 4
                    Response.Write("Case 4")
                Case 5
                    Response.Write("Case 5")
            End Select
            
            While value > 0
                value = value - 1
                If value = 5 Then
                    Exit While
                End If
            End While
        End Sub
        
        ' GOOD: Low cyclomatic complexity method
        Sub GoodSimpleMethod(value As Integer)
            If value > 0 Then
                Response.Write(value.ToString())
            End If
        End Sub
        
        Function BadComplexFunction(input As String) As String
            If input IsNot Nothing Then
                If input.Length > 0 Then
                    If input.Contains("test") Then
                        If input.StartsWith("a") Then
                            If input.EndsWith("z") Then
                                Return "Valid"
                            End If
                        End If
                    End If
                End If
            End If
            
            Try
                Dim num As Integer = Integer.Parse(input)
                If num > 100 Then
                    Return "Large"
                ElseIf num > 50 Then
                    Return "Medium"
                ElseIf num > 10 Then
                    Return "Small"
                End If
            Catch ex As Exception
                Return "Error"
            End Try
            
            Return "Unknown"
        End Function
    </script>
</body>
</html>

<%@ Page Language="VB" %>
<html>
<head>
    <title>Large Class Size Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Large class with many methods (over 20)
        Public Class BadLargeClass
            Sub Method1()
            End Sub
            
            Sub Method2()
            End Sub
            
            Sub Method3()
            End Sub
            
            Function Method4() As String
                Return ""
            End Function
            
            Function Method5() As String
                Return ""
            End Function
            
            Property Property1 As String
            
            Property Property2 As Integer
            
            Sub Method6()
            End Sub
            
            Sub Method7()
            End Sub
            
            Sub Method8()
            End Sub
            
            Function Method9() As Boolean
                Return False
            End Function
            
            Function Method10() As Boolean
                Return True
            End Function
            
            Sub Method11()
            End Sub
            
            Sub Method12()
            End Sub
            
            Sub Method13()
            End Sub
            
            Function Method14() As String
                Return ""
            End Function
            
            Function Method15() As String
                Return ""
            End Function
            
            Property Property3 As Double
            
            Property Property4 As Date
            
            Sub Method16()
            End Sub
            
            Sub Method17()
            End Sub
            
            Sub Method18()
            End Sub
            
            Function Method19() As Object
                Return Nothing
            End Function
            
            Function Method20() As Object
                Return Nothing
            End Function
            
            Sub Method21()
            End Sub
            
            Sub Method22()
            End Sub
        End Class
        
        ' GOOD: Small class with few methods
        Public Class GoodSmallClass
            Sub Method1()
            End Sub
            
            Function Method2() As String
                Return ""
            End Function
            
            Property Property1 As String
        End Class
        
        ' BAD: Another large class example
        Partial Class AnotherBadLargeClass
            Sub ProcessData1()
            End Sub
            
            Sub ProcessData2()
            End Sub
            
            Sub ProcessData3()
            End Sub
            
            Sub ProcessData4()
            End Sub
            
            Sub ProcessData5()
            End Sub
            
            Function ValidateData1() As Boolean
                Return True
            End Function
            
            Function ValidateData2() As Boolean
                Return True
            End Function
            
            Function ValidateData3() As Boolean
                Return True
            End Function
            
            Function ValidateData4() As Boolean
                Return True
            End Function
            
            Function ValidateData5() As Boolean
                Return True
            End Function
            
            Property Data1 As String
            Property Data2 As String
            Property Data3 As String
            Property Data4 As String
            Property Data5 As String
            
            Sub SaveData1()
            End Sub
            
            Sub SaveData2()
            End Sub
            
            Sub SaveData3()
            End Sub
            
            Sub SaveData4()
            End Sub
            
            Sub SaveData5()
            End Sub
            
            Sub LoadData1()
            End Sub
            
            Sub LoadData2()
            End Sub
        End Class
    </script>
</body>
</html>

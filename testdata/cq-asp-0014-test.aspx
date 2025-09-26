<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Code Formatting Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing spaces around operators and braces
        Dim result=5+3*2 ' No spaces around operators
        Dim name="John" ' No spaces around assignment
        Dim flag=True ' No spaces around assignment
        
        Sub BadFormattingMethod(){  ' Bad brace placement
            If(condition){ ' No space after If, bad brace
                Response.Write("Bad")
            }Else{ ' Bad brace placement
                Response.Write("Also bad")
            }
            
            While(counter<10){ ' No spaces, bad braces
                counter=counter+1
            }
            
            For i=1 To 10{ ' Bad assignment and brace
                Response.Write(i)
            }
        }
        
        Function BadFunction()As String{ ' Bad spacing and brace
            Return"value" ' No space
        }
        
        ' BAD: More formatting issues
        Dim x=y+z ' No spaces
        If condition Then result=true ' No spaces around assignment
        
        ' GOOD: Proper formatting with spaces
        Dim GoodResult = 5 + 3 * 2 ' Spaces around operators
        Dim GoodName = "John" ' Spaces around assignment
        Dim GoodFlag = True ' Spaces around assignment
        
        Sub GoodFormattingMethod()
            If condition Then ' Proper spacing
                Response.Write("Good")
            Else
                Response.Write("Also good")
            End If
            
            While counter < 10 ' Proper spacing
                counter = counter + 1
            End While
            
            For i = 1 To 10 ' Proper spacing
                Response.Write(i)
            Next
        End Sub
        
        Function GoodFunction() As String ' Proper spacing
            Return "value" ' Proper spacing
        End Function
        
        ' GOOD: Consistent formatting
        Dim x = y + z ' Proper spaces
        If condition Then
            result = True ' Proper spaces
        End If
    </script>
</body>
</html>

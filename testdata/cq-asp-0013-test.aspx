<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Indentation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Mixed tabs and spaces
		    Dim badIndentation1 As String ' Tab then spaces
        	Dim badIndentation2 As String ' Spaces then tab
        
        ' BAD: Inconsistent space indentation
   Dim badSpacing1 As String ' 3 spaces
     Dim badSpacing2 As String ' 5 spaces
           Dim badSpacing3 As String ' 11 spaces
  Dim badSpacing4 As String ' 2 spaces
        
        ' BAD: More mixed indentation examples
			Dim anotherBad1 As String ' Multiple tabs then space
        		Dim anotherBad2 As String ' Spaces then multiple tabs
        
        Sub BadIndentationMethod()
		    If True Then ' Tab then spaces
        	    Response.Write("Bad") ' Spaces then tab
           Response.Write("Inconsistent") ' Odd number of spaces
        End If
        End Sub
        
        ' GOOD: Consistent indentation (4 spaces)
        Dim GoodIndentation1 As String
        Dim GoodIndentation2 As String
        
        Sub GoodIndentationMethod()
            If True Then
                Response.Write("Good")
                Response.Write("Consistent")
            End If
        End Sub
        
        ' GOOD: Consistent indentation (tabs)
	Dim TabIndentation1 As String
	Dim TabIndentation2 As String
	
	Sub TabIndentationMethod()
		If True Then
			Response.Write("Tab consistent")
		End If
	End Sub
    </script>
</body>
</html>

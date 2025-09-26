<%@ Page Language="VB" %>
<html>
<head>
    <title>Large Method Size Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Large method with more than 50 lines
        Sub BadLargeMethod()
            Dim line1 As String = "Line 1"
            Dim line2 As String = "Line 2"
            Dim line3 As String = "Line 3"
            Dim line4 As String = "Line 4"
            Dim line5 As String = "Line 5"
            Dim line6 As String = "Line 6"
            Dim line7 As String = "Line 7"
            Dim line8 As String = "Line 8"
            Dim line9 As String = "Line 9"
            Dim line10 As String = "Line 10"
            Dim line11 As String = "Line 11"
            Dim line12 As String = "Line 12"
            Dim line13 As String = "Line 13"
            Dim line14 As String = "Line 14"
            Dim line15 As String = "Line 15"
            Dim line16 As String = "Line 16"
            Dim line17 As String = "Line 17"
            Dim line18 As String = "Line 18"
            Dim line19 As String = "Line 19"
            Dim line20 As String = "Line 20"
            Dim line21 As String = "Line 21"
            Dim line22 As String = "Line 22"
            Dim line23 As String = "Line 23"
            Dim line24 As String = "Line 24"
            Dim line25 As String = "Line 25"
            Dim line26 As String = "Line 26"
            Dim line27 As String = "Line 27"
            Dim line28 As String = "Line 28"
            Dim line29 As String = "Line 29"
            Dim line30 As String = "Line 30"
            Dim line31 As String = "Line 31"
            Dim line32 As String = "Line 32"
            Dim line33 As String = "Line 33"
            Dim line34 As String = "Line 34"
            Dim line35 As String = "Line 35"
            Dim line36 As String = "Line 36"
            Dim line37 As String = "Line 37"
            Dim line38 As String = "Line 38"
            Dim line39 As String = "Line 39"
            Dim line40 As String = "Line 40"
            Dim line41 As String = "Line 41"
            Dim line42 As String = "Line 42"
            Dim line43 As String = "Line 43"
            Dim line44 As String = "Line 44"
            Dim line45 As String = "Line 45"
            Dim line46 As String = "Line 46"
            Dim line47 As String = "Line 47"
            Dim line48 As String = "Line 48"
            Dim line49 As String = "Line 49"
            Dim line50 As String = "Line 50"
            Dim line51 As String = "Line 51"
            Dim line52 As String = "Line 52"
        End Sub
        
        ' GOOD: Small method with fewer than 50 lines
        Sub GoodSmallMethod()
            Dim message As String = "Hello World"
            Response.Write(message)
        End Sub
        
        Function BadLargeFunction() As String
            Dim result As String = ""
            result += "Line 1" + vbCrLf
            result += "Line 2" + vbCrLf
            result += "Line 3" + vbCrLf
            result += "Line 4" + vbCrLf
            result += "Line 5" + vbCrLf
            result += "Line 6" + vbCrLf
            result += "Line 7" + vbCrLf
            result += "Line 8" + vbCrLf
            result += "Line 9" + vbCrLf
            result += "Line 10" + vbCrLf
            result += "Line 11" + vbCrLf
            result += "Line 12" + vbCrLf
            result += "Line 13" + vbCrLf
            result += "Line 14" + vbCrLf
            result += "Line 15" + vbCrLf
            result += "Line 16" + vbCrLf
            result += "Line 17" + vbCrLf
            result += "Line 18" + vbCrLf
            result += "Line 19" + vbCrLf
            result += "Line 20" + vbCrLf
            result += "Line 21" + vbCrLf
            result += "Line 22" + vbCrLf
            result += "Line 23" + vbCrLf
            result += "Line 24" + vbCrLf
            result += "Line 25" + vbCrLf
            result += "Line 26" + vbCrLf
            result += "Line 27" + vbCrLf
            result += "Line 28" + vbCrLf
            result += "Line 29" + vbCrLf
            result += "Line 30" + vbCrLf
            result += "Line 31" + vbCrLf
            result += "Line 32" + vbCrLf
            result += "Line 33" + vbCrLf
            result += "Line 34" + vbCrLf
            result += "Line 35" + vbCrLf
            result += "Line 36" + vbCrLf
            result += "Line 37" + vbCrLf
            result += "Line 38" + vbCrLf
            result += "Line 39" + vbCrLf
            result += "Line 40" + vbCrLf
            result += "Line 41" + vbCrLf
            result += "Line 42" + vbCrLf
            result += "Line 43" + vbCrLf
            result += "Line 44" + vbCrLf
            result += "Line 45" + vbCrLf
            result += "Line 46" + vbCrLf
            result += "Line 47" + vbCrLf
            result += "Line 48" + vbCrLf
            result += "Line 49" + vbCrLf
            result += "Line 50" + vbCrLf
            result += "Line 51" + vbCrLf
            result += "Line 52" + vbCrLf
            Return result
        End Function
    </script>
</body>
</html>

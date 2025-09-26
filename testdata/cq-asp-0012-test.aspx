<%@ Page Language="VB" %>
<html>
<head>
    <title>Hungarian Notation Usage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Hungarian notation usage
        Dim strUserName As String ' String prefix
        Private intCounter As Integer ' Integer prefix
        Public lngFileSize As Long ' Long prefix
        Dim sngRatio As Single ' Single prefix
        Private dblPrice As Double ' Double prefix
        Public blnIsActive As Boolean ' Boolean prefix
        Dim objConnection As Object ' Object prefix
        Private arrItems As Array ' Array prefix
        Public colUsers As Collection ' Collection prefix
        Dim dicSettings As Dictionary ' Dictionary prefix
        
        ' BAD: Short Hungarian notation
        Dim szBuffer As String ' sz prefix
        Private nCount As Integer ' n prefix
        Public fFlag As Boolean ' f prefix
        Dim bEnabled As Boolean ' b prefix
        Private oInstance As Object ' o prefix
        Public aValues As Array ' a prefix
        Dim cItems As Collection ' c prefix
        Private dData As Dictionary ' d prefix
        
        ' BAD: Legacy Hungarian notation
        Dim lpszMessage As String ' lpsz prefix
        Private lpPointer As Long ' lp prefix
        Public hHandle As Integer ' h prefix
        Dim m_Value As String ' m_ prefix
        
        ' GOOD: Modern naming conventions
        Dim UserName As String ' No prefix
        Private Counter As Integer ' No prefix
        Public FileSize As Long ' No prefix
        Dim Ratio As Single ' No prefix
        Private Price As Double ' No prefix
        Public IsActive As Boolean ' No prefix
        Dim Connection As Object ' No prefix
        Private Items As Array ' No prefix
        Public Users As Collection ' No prefix
        Dim Settings As Dictionary ' No prefix
        
        ' GOOD: Descriptive names without prefixes
        Dim CurrentUser As String
        Private TotalCount As Integer
        Public MaximumSize As Long
        Dim CalculatedRatio As Single
        Private UnitPrice As Double
        Public EnabledFlag As Boolean
    </script>
</body>
</html>

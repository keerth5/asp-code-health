<%@ Page Language="VB" %>
<%@ Import Namespace="MyCustom.Library" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Another.Custom.Namespace" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="ZCustom.Library" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="BCustom.Library" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="ACustom.Library" %>
<html>
<head>
    <title>Improper Using Statement Ordering Test</title>
</head>
<body>
    <script runat="server">
        ' This file demonstrates improper ordering of import statements
        ' BAD: Non-system imports before system imports (lines 2-9)
        ' BAD: Non-alphabetical ordering within groups
        
        Sub TestMethod()
            ' Using some of the imported namespaces
            Dim data As New DataTable() ' System.Data
            Dim list As New ArrayList() ' System.Collections
            Dim file As New FileInfo("test.txt") ' System.IO
            Response.Write("Test") ' System.Web
        End Sub
        
        ' Examples of what the ordering should be:
        ' GOOD ordering would be:
        ' <%@ Import Namespace="System.Collections" %>
        ' <%@ Import Namespace="System.Data" %>
        ' <%@ Import Namespace="System.IO" %>
        ' <%@ Import Namespace="System.Web" %>
        ' <%@ Import Namespace="ACustom.Library" %>
        ' <%@ Import Namespace="Another.Custom.Namespace" %>
        ' <%@ Import Namespace="BCustom.Library" %>
        ' <%@ Import Namespace="MyCustom.Library" %>
        ' <%@ Import Namespace="ZCustom.Library" %>
    </script>
</body>
</html>

<%@ Page Language="VB" %>
<html>
<head>
    <title>Improper String Comparison Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Improper string comparison without culture awareness
        Sub BadStringComparisonMethod()
            Dim userName As String = "Admin"
            Dim inputName As String = Request.Form("name")
            
            If userName.Equals(inputName) Then ' No culture specification
                Response.Write("Access granted")
            End If
            
            Dim result = String.Compare(userName, inputName) ' No StringComparison parameter
            If result = 0 Then
                Response.Write("Match found")
            End If
            
            Dim category As String = "electronics"
            If category == "Electronics" Then ' Case-sensitive comparison without culture handling
                ProcessCategory()
            End If
            
            Dim status = GetStatus()
            If status.Equals("active") Then ' No culture specification
                ActivateUser()
            End If
            
            Dim productType = "SOFTWARE"
            If productType.Compare("software") = 0 Then ' Improper comparison
                ProcessSoftware()
            End If
        End Sub
        
        Function BadComparisonFunction(value1 As String, value2 As String) As Boolean
            Return String.Compare(value1, value2) = 0 ' Missing StringComparison
        End Function
        
        Sub BadCaseComparisonMethod()
            Dim userRole = "Administrator"
            If userRole == "administrator" Then ' Case-sensitive without proper handling
                GrantAdminAccess()
            End If
            
            Dim department = Request.QueryString("dept")
            If department.Equals("IT") Then ' No culture specification
                ShowITDashboard()
            End If
        End Sub
        
        ' GOOD: Proper string comparison with culture awareness
        Sub GoodStringComparisonMethod()
            Dim userName As String = "Admin"
            Dim inputName As String = Request.Form("name")
            
            If userName.Equals(inputName, StringComparison.OrdinalIgnoreCase) Then
                Response.Write("Access granted")
            End If
            
            Dim result = String.Compare(userName, inputName, StringComparison.OrdinalIgnoreCase)
            If result = 0 Then
                Response.Write("Match found")
            End If
            
            Dim category As String = "electronics"
            If String.Equals(category, "Electronics", StringComparison.OrdinalIgnoreCase) Then
                ProcessCategory()
            End If
            
            Dim status = GetStatus()
            If status.Equals("active", StringComparison.OrdinalIgnoreCase) Then
                ActivateUser()
            End If
        End Sub
        
        Function GoodComparisonFunction(value1 As String, value2 As String) As Boolean
            Return String.Compare(value1, value2, StringComparison.OrdinalIgnoreCase) = 0
        End Function
        
        Sub GoodCaseComparisonMethod()
            Dim userRole = "Administrator"
            If userRole.ToLower() = "administrator" Then ' Explicit case handling
                GrantAdminAccess()
            End If
            
            Dim department = Request.QueryString("dept")
            If department.ToUpper() = "IT" Then ' Explicit case handling
                ShowITDashboard()
            End If
            
            ' Alternative approach with culture-aware comparison
            Dim productName = "Software License"
            If String.Compare(productName, "SOFTWARE LICENSE", StringComparison.CurrentCultureIgnoreCase) = 0 Then
                ProcessLicense()
            End If
        End Sub
        
        ' Good: Using invariant culture for specific scenarios
        Sub GoodInvariantCultureMethod()
            Dim configValue = GetConfigValue()
            If String.Compare(configValue, "enabled", StringComparison.InvariantCultureIgnoreCase) = 0 Then
                EnableFeature()
            End If
        End Sub
        
        ' Helper methods
        Function GetStatus() As String
            Return "Active"
        End Function
        
        Function GetConfigValue() As String
            Return "Enabled"
        End Function
        
        Sub ProcessCategory()
        End Sub
        
        Sub ActivateUser()
        End Sub
        
        Sub GrantAdminAccess()
        End Sub
        
        Sub ShowITDashboard()
        End Sub
        
        Sub ProcessSoftware()
        End Sub
        
        Sub ProcessLicense()
        End Sub
        
        Sub EnableFeature()
        End Sub
    </script>
</body>
</html>

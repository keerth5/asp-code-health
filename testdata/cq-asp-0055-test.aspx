<%@ Page Language="VB" %>
<html>
<head>
    <title>Insufficient Authorization Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Insufficient authorization - authentication without proper role checks
        
        Sub BadInsufficientAuthorization()
            ' BAD: Authentication check without role verification
            If User.Identity.IsAuthenticated Then ' Bad: only checks authentication, not authorization
                ProcessSensitiveData() ' Bad: no role check
                AccessConfidentialInfo() ' Bad: no role check
                ModifyPrivateSettings() ' Bad: no role check
            End If
            
            ' BAD: Accessing sensitive resources without authorization
            DisplaySensitiveReport() ' Bad: no authorization check
            ShowConfidentialData() ' Bad: no authorization check
            AccessPrivateDocuments() ' Bad: no authorization check
            
            ' BAD: Admin functions without proper role checks
            ManageAdminPanel() ' Bad: no role check
            ConfigureManagerSettings() ' Bad: no role check
            AccessSupervisorTools() ' Bad: no role check
        End Sub
        
        Sub BadWeakAuthorizationChecks()
            ' BAD: Weak authorization patterns
            If User.Identity.IsAuthenticated Then
                ' Bad: No role or permission verification
                DeleteUserData(Request.Form("userId")) ' Bad: insufficient authorization
                ModifySystemConfig() ' Bad: insufficient authorization
                AccessFinancialData() ' Bad: insufficient authorization
            End If
            
            ' BAD: Client-side authorization (easily bypassed)
            If Request.Form("isAdmin") = "true" Then ' Bad: client-controlled authorization
                PerformAdminAction() ' Bad: insufficient authorization
            End If
        End Sub
        
        ' GOOD: Proper authorization with role and permission checks
        
        Sub GoodRoleBasedAuthorization()
            ' GOOD: Authentication with proper role checks
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("DataManager") Then
                ProcessSensitiveData() ' Good: role-based authorization
            End If
            
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("Confidential") Then
                AccessConfidentialInfo() ' Good: role-based authorization
            End If
            
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("SystemAdmin") Then
                ModifyPrivateSettings() ' Good: role-based authorization
            End If
        End Sub
        
        Sub GoodPermissionBasedAuthorization()
            ' GOOD: Permission-based authorization
            If User.Identity.IsAuthenticated AndAlso HasPermission("ViewReports") Then
                DisplaySensitiveReport() ' Good: permission-based authorization
            End If
            
            If User.Identity.IsAuthenticated AndAlso HasPermission("AccessConfidential") Then
                ShowConfidentialData() ' Good: permission-based authorization
            End If
            
            If User.Identity.IsAuthenticated AndAlso HasPermission("ReadPrivateDocuments") Then
                AccessPrivateDocuments() ' Good: permission-based authorization
            End If
        End Sub
        
        Sub GoodHierarchicalAuthorization()
            ' GOOD: Hierarchical role authorization
            If User.Identity.IsAuthenticated Then
                If User.IsInRole("Administrator") Then
                    ManageAdminPanel() ' Good: admin role authorization
                ElseIf User.IsInRole("Manager") Then
                    ConfigureManagerSettings() ' Good: manager role authorization
                ElseIf User.IsInRole("Supervisor") Then
                    AccessSupervisorTools() ' Good: supervisor role authorization
                Else
                    Response.Redirect("~/unauthorized.aspx")
                End If
            End If
        End Sub
        
        Sub GoodResourceBasedAuthorization()
            ' GOOD: Resource-based authorization
            Dim requestedUserId As String = Request.Form("userId")
            Dim currentUserId As String = GetCurrentUserId()
            
            If User.Identity.IsAuthenticated Then
                ' Users can only access their own data unless they're admin
                If requestedUserId = currentUserId OrElse User.IsInRole("Admin") Then
                    DeleteUserData(requestedUserId) ' Good: resource-based authorization
                Else
                    Response.StatusCode = 403
                    Response.Write("Forbidden: Access denied")
                End If
            End If
        End Sub
        
        Sub GoodMultiLevelAuthorization()
            ' GOOD: Multi-level authorization checks
            If Not User.Identity.IsAuthenticated Then
                Response.Redirect("~/login.aspx")
                Return
            End If
            
            If Not User.IsInRole("SystemAdmin") Then
                Response.StatusCode = 403
                Response.Write("Insufficient privileges")
                Return
            End If
            
            If Not HasPermission("ModifySystemConfig") Then
                Response.StatusCode = 403
                Response.Write("Permission denied")
                Return
            End If
            
            ' All authorization checks passed
            ModifySystemConfig() ' Good: multi-level authorization
        End Sub
        
        Sub GoodClaimsBasedAuthorization()
            ' GOOD: Claims-based authorization
            Dim identity = DirectCast(User.Identity, ClaimsIdentity)
            
            If identity.HasClaim("Department", "Finance") Then
                AccessFinancialData() ' Good: claims-based authorization
            End If
            
            If identity.HasClaim("Clearance", "TopSecret") Then
                AccessClassifiedInfo() ' Good: claims-based authorization
            End If
            
            If identity.HasClaim("Action", "Delete") AndAlso identity.HasClaim("Resource", "Users") Then
                DeleteUserAccount() ' Good: action and resource claims
            End If
        End Sub
        
        Sub GoodTimeBasedAuthorization()
            ' GOOD: Time-based authorization
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("Admin") Then
                Dim currentHour As Integer = DateTime.Now.Hour
                
                ' Admin operations only allowed during business hours
                If currentHour >= 9 AndAlso currentHour <= 17 Then
                    PerformAdminAction() ' Good: time-based authorization
                Else
                    Response.Write("Admin operations only allowed during business hours")
                End If
            End If
        End Sub
        
        Sub GoodIPBasedAuthorization()
            ' GOOD: IP-based authorization for sensitive operations
            Dim clientIP As String = Request.UserHostAddress
            Dim allowedIPs As String() = {"192.168.1.100", "10.0.0.50", "172.16.0.25"}
            
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("SuperAdmin") Then
                If allowedIPs.Contains(clientIP) Then
                    PerformCriticalOperation() ' Good: IP-based authorization
                Else
                    LogSecurityEvent("Unauthorized IP access attempt", clientIP)
                    Response.StatusCode = 403
                    Response.Write("Access denied from this location")
                End If
            End If
        End Sub
        
        Function HasPermission(permission As String) As Boolean
            ' Check if user has specific permission
            Return User.IsInRole(permission) ' Simplified example
        End Function
        
        Function GetCurrentUserId() As String
            Return User.Identity.Name
        End Function
        
        Sub LogSecurityEvent(message As String, details As String)
            ' Log security-related events
        End Sub
        
        ' Helper methods and fields
        Sub ProcessSensitiveData()
        End Sub
        
        Sub AccessConfidentialInfo()
        End Sub
        
        Sub ModifyPrivateSettings()
        End Sub
        
        Sub DisplaySensitiveReport()
        End Sub
        
        Sub ShowConfidentialData()
        End Sub
        
        Sub AccessPrivateDocuments()
        End Sub
        
        Sub ManageAdminPanel()
        End Sub
        
        Sub ConfigureManagerSettings()
        End Sub
        
        Sub AccessSupervisorTools()
        End Sub
        
        Sub DeleteUserData(userId As String)
        End Sub
        
        Sub ModifySystemConfig()
        End Sub
        
        Sub AccessFinancialData()
        End Sub
        
        Sub PerformAdminAction()
        End Sub
        
        Sub AccessClassifiedInfo()
        End Sub
        
        Sub DeleteUserAccount()
        End Sub
        
        Sub PerformCriticalOperation()
        End Sub
    </script>
</body>
</html>

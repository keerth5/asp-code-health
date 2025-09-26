<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Authentication Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing authentication for sensitive operations
        
        Sub BadMissingAuthentication()
            ' BAD: Sensitive database operations without authentication checks
            Delete From Users Where UserId = Request.Form("userId") ' Bad: no authentication
            Update Users Set Status = 'Inactive' Where Email = Request.QueryString("email") ' Bad: no authentication
            Insert Into AdminUsers (Name, Email) Values (@name, @email) ' Bad: no authentication
            
            ' BAD: File system operations without authentication
            File.Delete(Server.MapPath("~/uploads/" + Request.Form("filename"))) ' Bad: no authentication
            Directory.Create(Server.MapPath("~/temp/" + Request.QueryString("folder"))) ' Bad: no authentication
            File.Move(oldPath, newPath) ' Bad: no authentication
            
            ' BAD: Admin operations without authentication
            ProcessAdminRequest() ' Bad: no authentication check
            ManageUserAccounts() ' Bad: no authentication check
            ConfigureSystemSettings() ' Bad: no authentication check
        End Sub
        
        Sub BadAdminPageAccess()
            ' BAD: Admin pages without authentication
            ' admin.aspx - Bad: no authentication check
            ' manage.aspx - Bad: no authentication check  
            ' config.aspx - Bad: no authentication check
            
            Response.Write("Welcome to admin panel") ' Bad: no auth check
            DisplayUserManagement() ' Bad: no auth check
            ShowConfigurationOptions() ' Bad: no auth check
        End Sub
        
        Sub BadSensitiveOperations()
            ' BAD: Sensitive operations without proper authentication
            DeleteUserAccount(Request.Form("targetUserId")) ' Bad: no authentication
            UpdateAccountBalance(userId, newBalance) ' Bad: no authentication
            GrantAdminPrivileges(Request.QueryString("userId")) ' Bad: no authentication
            
            ' BAD: System modifications without authentication
            ModifySystemConfiguration() ' Bad: no authentication
            UpdateSecuritySettings() ' Bad: no authentication
            ChangeUserPermissions() ' Bad: no authentication
        End Sub
        
        ' GOOD: Proper authentication checks for sensitive operations
        
        Sub GoodAuthenticationChecks()
            ' GOOD: Check authentication before sensitive operations
            If Not User.Identity.IsAuthenticated Then
                Response.Redirect("~/login.aspx")
                Return
            End If
            
            ' GOOD: Database operations with authentication
            If User.Identity.IsAuthenticated Then
                Delete From Users Where UserId = Request.Form("userId") ' Good: authenticated
                Update Users Set Status = 'Inactive' Where Email = Request.QueryString("email") ' Good: authenticated
            End If
            
            ' GOOD: Session-based authentication check
            If Session("UserId") IsNot Nothing AndAlso Session("IsAuthenticated") = True Then
                Insert Into AdminUsers (Name, Email) Values (@name, @email) ' Good: session authenticated
            End If
        End Sub
        
        Sub GoodFileOperationsWithAuth()
            ' GOOD: File operations with authentication
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("Admin") Then
                File.Delete(Server.MapPath("~/uploads/" + Request.Form("filename"))) ' Good: authenticated and authorized
                Directory.Create(Server.MapPath("~/temp/" + Request.QueryString("folder"))) ' Good: authenticated
            End If
            
            ' GOOD: Check user identity before file operations
            If HttpContext.Current.User.Identity.IsAuthenticated Then
                File.Move(oldPath, newPath) ' Good: authenticated
            End If
        End Sub
        
        Sub GoodAdminOperations()
            ' GOOD: Admin operations with proper authentication
            If User.Identity.IsAuthenticated AndAlso User.IsInRole("Administrator") Then
                ProcessAdminRequest() ' Good: authenticated and authorized
                ManageUserAccounts() ' Good: authenticated and authorized
                ConfigureSystemSettings() ' Good: authenticated and authorized
            Else
                Response.Redirect("~/unauthorized.aspx")
            End If
        End Sub
        
        Sub GoodPageLevelAuthentication()
            ' GOOD: Page-level authentication check
            If Not User.Identity.IsAuthenticated Then
                Response.Redirect("~/login.aspx?returnUrl=" + Request.RawUrl)
                Return
            End If
            
            ' GOOD: Role-based access control
            If Not User.IsInRole("Admin") Then
                Response.Redirect("~/accessdenied.aspx")
                Return
            End If
            
            ' Safe to display admin content
            Response.Write("Welcome to authenticated admin panel") ' Good: authenticated
            DisplayUserManagement() ' Good: authenticated
            ShowConfigurationOptions() ' Good: authenticated
        End Sub
        
        Sub GoodSensitiveOperationsWithAuth()
            ' GOOD: Sensitive operations with proper authentication and authorization
            If User.Identity.IsAuthenticated Then
                If User.IsInRole("UserManager") Then
                    DeleteUserAccount(Request.Form("targetUserId")) ' Good: authenticated and authorized
                End If
                
                If User.IsInRole("FinanceManager") Then
                    UpdateAccountBalance(userId, newBalance) ' Good: authenticated and authorized
                End If
                
                If User.IsInRole("SuperAdmin") Then
                    GrantAdminPrivileges(Request.QueryString("userId")) ' Good: authenticated and authorized
                End If
            End If
        End Sub
        
        Sub GoodMultiFactorAuthentication()
            ' GOOD: Multi-factor authentication check
            If Not User.Identity.IsAuthenticated Then
                Response.Redirect("~/login.aspx")
                Return
            End If
            
            If Session("MFAVerified") IsNot True Then
                Response.Redirect("~/mfa-verify.aspx")
                Return
            End If
            
            ' Safe to perform sensitive operations after MFA
            ModifySystemConfiguration() ' Good: MFA authenticated
            UpdateSecuritySettings() ' Good: MFA authenticated
            ChangeUserPermissions() ' Good: MFA authenticated
        End Sub
        
        Sub GoodTokenBasedAuth()
            ' GOOD: Token-based authentication
            Dim authToken As String = Request.Headers("Authorization")
            
            If String.IsNullOrEmpty(authToken) OrElse Not ValidateAuthToken(authToken) Then
                Response.StatusCode = 401
                Response.Write("Unauthorized")
                Return
            End If
            
            ' Token is valid, proceed with operation
            ProcessSecureRequest() ' Good: token authenticated
        End Sub
        
        Function ValidateAuthToken(token As String) As Boolean
            ' Validate JWT or other auth token
            Return True ' Simplified for example
        End Function
        
        ' Helper methods and fields
        Private userId As String = "user123"
        Private newBalance As Decimal = 1000D
        Private oldPath As String = "old.txt"
        Private newPath As String = "new.txt"
        
        Sub ProcessAdminRequest()
        End Sub
        
        Sub ManageUserAccounts()
        End Sub
        
        Sub ConfigureSystemSettings()
        End Sub
        
        Sub DisplayUserManagement()
        End Sub
        
        Sub ShowConfigurationOptions()
        End Sub
        
        Sub DeleteUserAccount(userId As String)
        End Sub
        
        Sub UpdateAccountBalance(userId As String, balance As Decimal)
        End Sub
        
        Sub GrantAdminPrivileges(userId As String)
        End Sub
        
        Sub ModifySystemConfiguration()
        End Sub
        
        Sub UpdateSecuritySettings()
        End Sub
        
        Sub ChangeUserPermissions()
        End Sub
        
        Sub ProcessSecureRequest()
        End Sub
    </script>
</body>
</html>

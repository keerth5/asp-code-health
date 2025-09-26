<%@ Page Language="VB" %>
<html>
<head>
    <title>Insecure Password Storage Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Insecure password storage - weak hashing and plain text storage
        
        Sub BadPasswordStorage()
            ' BAD: Direct password assignment from request
            Dim password = Request.Form("password") ' Bad: no hashing
            Dim userPassword = Request.QueryString("pwd") ' Bad: no hashing
            
            ' BAD: Storing passwords in plain text
            Dim plainPassword As String = "user123password" ' Bad: hardcoded plain text
            Dim userPwd As String = txtPassword.Text ' Bad: no hashing before storage
            
            ' BAD: Weak hashing algorithms without salt
            Dim hashedPassword1 = MD5(password) ' Bad: MD5 without salt
            Dim hashedPassword2 = SHA1(userPassword) ' Bad: SHA1 without salt
            Dim weakHash = ComputeMD5Hash(Request.Form("password")) ' Bad: MD5 without salt
            
            ' BAD: Simple hashing without salt
            Dim md5Hash = MD5.Create().ComputeHash(Encoding.UTF8.GetBytes(password)) ' Bad: no salt
            Dim sha1Hash = SHA1.Create().ComputeHash(Encoding.UTF8.GetBytes(password)) ' Bad: no salt
            
            ' Store in database (insecure)
            SavePassword(userId, password) ' Bad: plain text storage
            UpdateUserPassword(username, hashedPassword1) ' Bad: weak hash
        End Sub
        
        Sub BadPasswordComparison()
            ' BAD: Plain text password comparison
            Dim inputPassword = Request.Form("password")
            Dim storedPassword = GetStoredPassword(userId)
            
            If inputPassword = storedPassword Then ' Bad: plain text comparison
                AuthenticateUser(userId)
            End If
            
            ' BAD: Weak hash comparison
            Dim inputHash = MD5(inputPassword) ' Bad: MD5
            Dim storedHash = GetStoredPasswordHash(userId)
            
            If inputHash = storedHash Then ' Bad: weak hash comparison
                LoginUser(userId)
            End If
        End Sub
        
        ' GOOD: Secure password storage with proper hashing and salt
        
        Sub GoodPasswordStorage()
            ' GOOD: Using BCrypt for password hashing
            Dim password = Request.Form("password")
            Dim hashedPassword = BCrypt.Net.BCrypt.HashPassword(password) ' Good: BCrypt with salt
            
            ' Store securely hashed password
            SavePasswordHash(userId, hashedPassword) ' Good: secure storage
            
            ' GOOD: Using PBKDF2
            Dim salt As Byte() = GenerateRandomSalt()
            Dim pbkdf2Hash = PBKDF2(password, salt, 10000) ' Good: PBKDF2 with salt and iterations
            
            ' GOOD: Using Scrypt
            Dim scryptHash = Scrypt.Net.ScryptEncoder.Encode(password) ' Good: Scrypt
            
            ' GOOD: Using Argon2
            Dim argon2Hash = Argon2.Hash(password) ' Good: Argon2
        End Sub
        
        Sub GoodPasswordVerification()
            ' GOOD: Secure password verification
            Dim inputPassword = Request.Form("password")
            Dim storedHash = GetStoredPasswordHash(userId)
            
            ' BCrypt verification
            If BCrypt.Net.BCrypt.Verify(inputPassword, storedHash) Then ' Good: secure verification
                AuthenticateUser(userId)
            End If
            
            ' PBKDF2 verification
            If VerifyPBKDF2Password(inputPassword, storedHash) Then ' Good: secure verification
                LoginUser(userId)
            End If
        End Sub
        
        Sub GoodSaltGeneration()
            ' GOOD: Generating cryptographically secure salt
            Dim rng As New RNGCryptoServiceProvider()
            Dim salt(31) As Byte ' 32 bytes = 256 bits
            rng.GetBytes(salt)
            
            ' Use salt with hashing
            Dim password = Request.Form("password")
            Dim saltedPassword = password + Convert.ToBase64String(salt)
            Dim hash = SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(saltedPassword)) ' Good: with salt
            
            ' Store both hash and salt
            SavePasswordWithSalt(userId, Convert.ToBase64String(hash), Convert.ToBase64String(salt))
        End Sub
        
        Sub GoodPasswordPolicy()
            ' GOOD: Password strength validation
            Dim password = Request.Form("password")
            
            If Not IsStrongPassword(password) Then
                Throw New ArgumentException("Password does not meet security requirements")
            End If
            
            ' Hash strong password
            Dim hashedPassword = BCrypt.Net.BCrypt.HashPassword(password, 12) ' Good: BCrypt with cost factor
            SavePasswordHash(userId, hashedPassword)
        End Sub
        
        Function IsStrongPassword(password As String) As Boolean
            ' Check password strength
            If password.Length < 8 Then Return False
            If Not Regex.IsMatch(password, "[A-Z]") Then Return False ' Uppercase
            If Not Regex.IsMatch(password, "[a-z]") Then Return False ' Lowercase
            If Not Regex.IsMatch(password, "[0-9]") Then Return False ' Digit
            If Not Regex.IsMatch(password, "[^a-zA-Z0-9]") Then Return False ' Special char
            
            Return True
        End Function
        
        Function GenerateRandomSalt() As Byte()
            Dim salt(31) As Byte
            Using rng As New RNGCryptoServiceProvider()
                rng.GetBytes(salt)
            End Using
            Return salt
        End Function
        
        Function PBKDF2(password As String, salt As Byte(), iterations As Integer) As String
            Using pbkdf2 As New Rfc2898DeriveBytes(password, salt, iterations)
                Dim hash As Byte() = pbkdf2.GetBytes(32) ' 256 bits
                Return Convert.ToBase64String(hash)
            End Using
        End Function
        
        Function VerifyPBKDF2Password(password As String, storedHash As String) As Boolean
            ' Implementation would extract salt and verify hash
            Return True ' Simplified for example
        End Function
        
        ' Helper methods and fields
        Private userId As String = "user123"
        Private username As String = "testuser"
        Private txtPassword As TextBox
        
        Function MD5(input As String) As String
            Return "weak_hash"
        End Function
        
        Function SHA1(input As String) As String
            Return "weak_hash"
        End Function
        
        Function ComputeMD5Hash(input As String) As String
            Return "weak_hash"
        End Function
        
        Sub SavePassword(userId As String, password As String)
        End Sub
        
        Sub UpdateUserPassword(username As String, hash As String)
        End Sub
        
        Sub SavePasswordHash(userId As String, hash As String)
        End Sub
        
        Sub SavePasswordWithSalt(userId As String, hash As String, salt As String)
        End Sub
        
        Function GetStoredPassword(userId As String) As String
            Return "stored_password"
        End Function
        
        Function GetStoredPasswordHash(userId As String) As String
            Return "stored_hash"
        End Function
        
        Sub AuthenticateUser(userId As String)
        End Sub
        
        Sub LoginUser(userId As String)
        End Sub
    </script>
</body>
</html>

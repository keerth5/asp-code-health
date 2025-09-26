<%@ Page Language="VB" %>
<html>
<head>
    <title>Insecure Random Generation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Insecure random generation for security purposes
        
        Sub BadRandomGeneration()
            ' BAD: Using System.Random for security-sensitive operations
            Dim rnd As New Random() ' Bad: not cryptographically secure
            Dim randomPassword = rnd.Next(100000, 999999).ToString() ' Bad: weak password generation
            Dim sessionToken = rnd.Next().ToString() ' Bad: predictable session token
            Dim apiKey = "key_" + rnd.Next(1000, 9999).ToString() ' Bad: weak API key
            Dim salt = rnd.Next().ToString() ' Bad: weak salt generation
            Dim nonce = rnd.Next(1000000, 9999999).ToString() ' Bad: weak nonce
            
            ' BAD: Random.Next for security purposes
            Dim securityCode = Random.Next(100000, 999999) ' Bad: weak security code
            Dim verificationToken = Random.Next().ToString() ' Bad: weak verification token
            Dim resetKey = Random.Next(10000, 99999).ToString() ' Bad: weak reset key
        End Sub
        
        Sub BadGuidGeneration()
            ' BAD: Using GUID.NewGuid for security tokens
            Dim passwordResetToken = Guid.NewGuid().ToString() ' Bad: GUID for password reset
            Dim sessionToken = Guid.NewGuid().ToString() ' Bad: GUID for session
            Dim apiKey = Guid.NewGuid().ToString() ' Bad: GUID for API key
            Dim authToken = Guid.NewGuid().ToString() ' Bad: GUID for authentication
            
            ' BAD: DateTime.Now.Ticks for security
            Dim ticksPassword = DateTime.Now.Ticks.ToString() ' Bad: predictable password
            Dim ticksToken = DateTime.Now.Ticks.ToString() ' Bad: predictable token
            Dim ticksKey = DateTime.Now.Ticks.ToString() ' Bad: predictable key
            Dim ticksSession = DateTime.Now.Ticks.ToString() ' Bad: predictable session ID
        End Sub
        
        Sub BadMathRandom()
            ' BAD: Using Math.Random for security purposes
            Dim securityValue = Math.Random() * 1000000 ' Bad: weak security value
            Dim cryptoSeed = Math.Random() ' Bad: weak crypto seed
            Dim authCode = CInt(Math.Random() * 999999) ' Bad: weak auth code
            
            ' BAD: Random.NextDouble for security
            Dim rnd As New Random()
            Dim securityRatio = rnd.NextDouble() ' Bad: weak security ratio
            Dim cryptoFactor = rnd.NextDouble() * 100 ' Bad: weak crypto factor
            Dim authMultiplier = rnd.NextDouble() ' Bad: weak auth multiplier
        End Sub
        
        Sub BadWeakRandomPatterns()
            ' BAD: Weak random patterns for security
            Dim rnd As New Random(DateTime.Now.Millisecond) ' Bad: weak seed
            Dim weakToken = rnd.Next().ToString() + DateTime.Now.Ticks.ToString() ' Bad: combination of weak randoms
            
            ' BAD: Predictable patterns
            Dim predictableKey = Environment.TickCount.ToString() ' Bad: predictable
            Dim weakSalt = DateTime.Now.ToString("yyyyMMddHHmmss") ' Bad: time-based salt
        End Sub
        
        ' GOOD: Cryptographically secure random generation
        
        Sub GoodCryptographicRandom()
            ' GOOD: Using RNGCryptoServiceProvider
            Using rng As New RNGCryptoServiceProvider()
                Dim randomBytes(31) As Byte ' 32 bytes = 256 bits
                rng.GetBytes(randomBytes)
                Dim securePassword = Convert.ToBase64String(randomBytes) ' Good: cryptographically secure
                
                Dim tokenBytes(15) As Byte ' 16 bytes = 128 bits
                rng.GetBytes(tokenBytes)
                Dim sessionToken = Convert.ToBase64String(tokenBytes) ' Good: secure session token
                
                Dim keyBytes(31) As Byte
                rng.GetBytes(keyBytes)
                Dim apiKey = Convert.ToBase64String(keyBytes) ' Good: secure API key
            End Using
        End Sub
        
        Sub GoodSecureRandomGeneration()
            ' GOOD: Using RandomNumberGenerator
            Using rng As RandomNumberGenerator = RandomNumberGenerator.Create()
                Dim saltBytes(15) As Byte
                rng.GetBytes(saltBytes)
                Dim salt = Convert.ToBase64String(saltBytes) ' Good: secure salt
                
                Dim nonceBytes(11) As Byte ' 12 bytes for nonce
                rng.GetBytes(nonceBytes)
                Dim nonce = Convert.ToBase64String(nonceBytes) ' Good: secure nonce
                
                Dim codeBytes(3) As Byte ' 4 bytes
                rng.GetBytes(codeBytes)
                Dim securityCode = BitConverter.ToUInt32(codeBytes, 0) Mod 1000000 ' Good: secure code
            End Using
        End Sub
        
        Sub GoodSecureTokenGeneration()
            ' GOOD: Secure token generation
            Dim resetToken = GenerateSecureToken(32) ' Good: secure password reset token
            Dim authToken = GenerateSecureToken(16) ' Good: secure auth token
            Dim verificationToken = GenerateSecureToken(24) ' Good: secure verification token
            
            ' GOOD: Secure session ID generation
            Dim sessionId = GenerateSecureSessionId() ' Good: secure session
        End Sub
        
        Sub GoodCryptographicKeys()
            ' GOOD: Secure cryptographic key generation
            Dim encryptionKey = GenerateSecureKey(256) ' Good: 256-bit encryption key
            Dim signingKey = GenerateSecureKey(256) ' Good: 256-bit signing key
            Dim hmacKey = GenerateSecureKey(256) ' Good: 256-bit HMAC key
            
            ' GOOD: Secure IV generation
            Dim iv = GenerateSecureIV(16) ' Good: secure initialization vector
        End Sub
        
        Sub GoodSecurePasswordGeneration()
            ' GOOD: Secure password generation with character sets
            Dim securePassword = GenerateSecurePassword(12, True, True, True, True) ' Good: secure password
            Dim tempPassword = GenerateSecurePassword(8, True, True, True, False) ' Good: temporary password
        End Sub
        
        Function GenerateSecureToken(lengthInBytes As Integer) As String
            ' GOOD: Secure token generation function
            Using rng As New RNGCryptoServiceProvider()
                Dim tokenBytes(lengthInBytes - 1) As Byte
                rng.GetBytes(tokenBytes)
                Return Convert.ToBase64String(tokenBytes)
            End Using
        End Function
        
        Function GenerateSecureSessionId() As String
            ' GOOD: Secure session ID generation
            Using rng As New RNGCryptoServiceProvider()
                Dim sessionBytes(31) As Byte ' 32 bytes
                rng.GetBytes(sessionBytes)
                Return Convert.ToBase64String(sessionBytes).Replace("+", "-").Replace("/", "_").TrimEnd("="c)
            End Using
        End Function
        
        Function GenerateSecureKey(keyLengthInBits As Integer) As Byte()
            ' GOOD: Secure key generation
            Dim keyLengthInBytes As Integer = keyLengthInBits \ 8
            Dim keyBytes(keyLengthInBytes - 1) As Byte
            
            Using rng As New RNGCryptoServiceProvider()
                rng.GetBytes(keyBytes)
            End Using
            
            Return keyBytes
        End Function
        
        Function GenerateSecureIV(lengthInBytes As Integer) As Byte()
            ' GOOD: Secure IV generation
            Dim ivBytes(lengthInBytes - 1) As Byte
            
            Using rng As New RNGCryptoServiceProvider()
                rng.GetBytes(ivBytes)
            End Using
            
            Return ivBytes
        End Function
        
        Function GenerateSecurePassword(length As Integer, uppercase As Boolean, lowercase As Boolean, digits As Boolean, symbols As Boolean) As String
            ' GOOD: Secure password generation with character sets
            Dim chars As String = ""
            If uppercase Then chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            If lowercase Then chars += "abcdefghijklmnopqrstuvwxyz"
            If digits Then chars += "0123456789"
            If symbols Then chars += "!@#$%^&*"
            
            If String.IsNullOrEmpty(chars) Then
                Throw New ArgumentException("At least one character set must be enabled")
            End If
            
            Dim password As New StringBuilder()
            Using rng As New RNGCryptoServiceProvider()
                Dim randomBytes(length - 1) As Byte
                rng.GetBytes(randomBytes)
                
                For i As Integer = 0 To length - 1
                    Dim index As Integer = randomBytes(i) Mod chars.Length
                    password.Append(chars(index))
                Next
            End Using
            
            Return password.ToString()
        End Function
        
        Sub GoodSecureSeedGeneration()
            ' GOOD: Using secure random for seeding other operations
            Using rng As New RNGCryptoServiceProvider()
                Dim seedBytes(7) As Byte ' 8 bytes
                rng.GetBytes(seedBytes)
                Dim secureSeed = BitConverter.ToInt64(seedBytes, 0)
                
                ' Use secure seed for non-cryptographic operations that need randomness
                ProcessWithSecureSeed(secureSeed) ' Good: secure seed
            End Using
        End Sub
        
        Sub GoodRandomWithValidation()
            ' GOOD: Secure random with validation
            Dim attempts As Integer = 0
            Dim maxAttempts As Integer = 10
            Dim token As String = Nothing
            
            Do While attempts < maxAttempts
                token = GenerateSecureToken(16)
                If ValidateTokenUniqueness(token) Then
                    Exit Do
                End If
                attempts += 1
            Loop
            
            If attempts >= maxAttempts Then
                Throw New InvalidOperationException("Failed to generate unique token")
            End If
            
            ' Use validated secure token
            UseSecureToken(token) ' Good: validated secure token
        End Sub
        
        Function ValidateTokenUniqueness(token As String) As Boolean
            ' Check if token is unique in system
            Return True ' Simplified for example
        End Function
        
        Sub ProcessWithSecureSeed(seed As Long)
            ' Process with secure seed
        End Sub
        
        Sub UseSecureToken(token As String)
            ' Use the secure token
        End Sub
        
        ' Helper fields for bad examples
        Private Random As New Random()
    </script>
</body>
</html>

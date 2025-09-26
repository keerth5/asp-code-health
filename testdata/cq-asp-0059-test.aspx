<%@ Page Language="VB" %>
<html>
<head>
    <title>Weak Cryptographic Algorithms Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Weak cryptographic algorithms and key sizes
        
        Sub BadWeakEncryption()
            ' BAD: DES encryption (weak)
            Dim des As DESCryptoServiceProvider = New DESCryptoServiceProvider() ' Bad: DES is weak
            Dim desManaged As New DESCryptoServiceProvider() ' Bad: DES managed
            Dim desAlgorithm As DES = DES.Create() ' Bad: DES algorithm
            
            ' BAD: 3DES encryption (weak)
            Dim tripleDes As New TripleDESCryptoServiceProvider() ' Bad: 3DES is weak
            Dim threeDes As TripleDES = TripleDES.Create() ' Bad: 3DES algorithm
            Dim tripleDESManaged As New TripleDESCryptoServiceProvider() ' Bad: 3DES managed
            
            ' BAD: RC4 encryption (weak)
            Dim rc4 As New RC4CryptoServiceProvider() ' Bad: RC4 is weak
            Dim rc4Algorithm As RC4 = RC4.Create() ' Bad: RC4 algorithm
        End Sub
        
        Sub BadWeakHashing()
            ' BAD: MD5 hashing (weak)
            Dim md5 As MD5CryptoServiceProvider = New MD5CryptoServiceProvider() ' Bad: MD5 is weak
            Dim md5Managed As New MD5CryptoServiceProvider() ' Bad: MD5 managed
            Dim md5Algorithm As MD5 = MD5.Create() ' Bad: MD5 algorithm
            
            ' BAD: SHA1 hashing (weak)
            Dim sha1 As SHA1CryptoServiceProvider = New SHA1CryptoServiceProvider() ' Bad: SHA1 is weak
            Dim sha1Managed As New SHA1Managed() ' Bad: SHA1 managed
            Dim sha1Algorithm As SHA1 = SHA1.Create() ' Bad: SHA1 algorithm
        End Sub
        
        Sub BadWeakRijndaelAES()
            ' BAD: Rijndael without specifying strong parameters
            Dim rijndael As Rijndael = Rijndael.Create() ' Bad: default Rijndael settings
            Dim rijndaelManaged As New RijndaelManaged() ' Bad: managed without strong settings
            
            ' BAD: AES without specifying key size or mode
            Dim aes As Aes = Aes.Create() ' Bad: default AES settings (may be weak)
            Dim aesManaged As New AesCryptoServiceProvider() ' Bad: without specifying strong parameters
        End Sub
        
        Sub BadWeakAsymmetricCrypto()
            ' BAD: RSA without sufficient key size
            Dim rsa As RSA = RSA.Create() ' Bad: default RSA key size may be weak
            Dim rsaCsp As New RSACryptoServiceProvider() ' Bad: default key size
            Dim rsaManaged As New RSACryptoServiceProvider(1024) ' Bad: 1024-bit key is weak
            
            ' BAD: DSA without sufficient key size
            Dim dsa As DSA = DSA.Create() ' Bad: default DSA key size may be weak
            Dim dsaCsp As New DSACryptoServiceProvider() ' Bad: default key size
            Dim dsaManaged As New DSACryptoServiceProvider(1024) ' Bad: 1024-bit key is weak
        End Sub
        
        Sub BadWeakRandomAlgorithms()
            ' BAD: Weak random number generators for crypto
            Dim weakRandom As New Random() ' Bad: not cryptographically secure
            Dim cryptoKey = weakRandom.Next().ToString() ' Bad: weak key generation
        End Sub
        
        ' GOOD: Strong cryptographic algorithms and key sizes
        
        Sub GoodStrongEncryption()
            ' GOOD: AES with 256-bit key
            Dim aes256 As Aes = Aes.Create()
            aes256.KeySize = 256 ' Good: 256-bit AES
            aes256.Mode = CipherMode.CBC ' Good: CBC mode
            aes256.Padding = PaddingMode.PKCS7 ' Good: proper padding
            
            ' GOOD: AES-GCM for authenticated encryption
            Dim aesGcm As New AesCcm(New Byte(31) {}) ' Good: AES-GCM with 256-bit key
            Dim aesGcmAlgorithm As Aes = Aes.Create()
            aesGcmAlgorithm.Mode = CipherMode.GCM ' Good: GCM mode
            aesGcmAlgorithm.KeySize = 256 ' Good: 256-bit key
        End Sub
        
        Sub GoodStrongHashing()
            ' GOOD: SHA-256 hashing
            Dim sha256 As SHA256 = SHA256.Create() ' Good: SHA-256
            Dim sha256Managed As New SHA256Managed() ' Good: SHA-256 managed
            Dim sha256Csp As New SHA256CryptoServiceProvider() ' Good: SHA-256 CSP
            
            ' GOOD: SHA-384 hashing
            Dim sha384 As SHA384 = SHA384.Create() ' Good: SHA-384
            Dim sha384Managed As New SHA384Managed() ' Good: SHA-384 managed
            
            ' GOOD: SHA-512 hashing
            Dim sha512 As SHA512 = SHA512.Create() ' Good: SHA-512
            Dim sha512Managed As New SHA512Managed() ' Good: SHA-512 managed
        End Sub
        
        Sub GoodStrongAsymmetricCrypto()
            ' GOOD: RSA with sufficient key size
            Dim rsa2048 As RSA = RSA.Create(2048) ' Good: 2048-bit RSA
            Dim rsa4096 As New RSACryptoServiceProvider(4096) ' Good: 4096-bit RSA
            
            ' GOOD: RSA with OAEP padding
            Dim rsaOaep As RSA = RSA.Create(2048)
            rsaOaep.Encrypt(data, RSAEncryptionPadding.OaepSHA256) ' Good: OAEP padding
            
            ' GOOD: RSA with PSS padding for signatures
            Dim rsaPss As RSA = RSA.Create(2048)
            rsaPss.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pss) ' Good: PSS padding
            
            ' GOOD: DSA with sufficient key size
            Dim dsa2048 As New DSACryptoServiceProvider(2048) ' Good: 2048-bit DSA
            Dim dsa3072 As DSA = DSA.Create()
            dsa3072.KeySize = 3072 ' Good: 3072-bit DSA
        End Sub
        
        Sub GoodEllipticCurveCrypto()
            ' GOOD: Elliptic Curve Cryptography
            Dim ecdsa As ECDsa = ECDsa.Create() ' Good: ECDSA
            ecdsa.KeySize = 256 ' Good: P-256 curve
            
            Dim ecdh As ECDiffieHellman = ECDiffieHellman.Create() ' Good: ECDH
            ecdh.KeySize = 384 ' Good: P-384 curve
            
            ' GOOD: Named curves
            Dim ecdsaP521 As ECDsa = ECDsa.Create(ECCurve.NamedCurves.nistP521) ' Good: P-521 curve
        End Sub
        
        Sub GoodSecureRandomGeneration()
            ' GOOD: Cryptographically secure random
            Dim rng As New RNGCryptoServiceProvider() ' Good: crypto-secure RNG
            Dim randomBytes(31) As Byte
            rng.GetBytes(randomBytes) ' Good: secure random bytes
            
            Dim secureRandom As RandomNumberGenerator = RandomNumberGenerator.Create() ' Good: secure RNG
            secureRandom.GetBytes(randomBytes) ' Good: secure random generation
        End Sub
        
        Sub GoodHMACImplementation()
            ' GOOD: HMAC with strong hash algorithms
            Dim hmacSha256 As New HMACSHA256() ' Good: HMAC-SHA256
            Dim hmacSha384 As New HMACSHA384() ' Good: HMAC-SHA384
            Dim hmacSha512 As New HMACSHA512() ' Good: HMAC-SHA512
            
            ' GOOD: HMAC with custom key
            Dim key(31) As Byte ' 256-bit key
            Using rng As New RNGCryptoServiceProvider()
                rng.GetBytes(key)
            End Using
            
            Dim hmac As New HMACSHA256(key) ' Good: HMAC with secure key
        End Sub
        
        Sub GoodPasswordBasedCrypto()
            ' GOOD: PBKDF2 for password-based key derivation
            Dim pbkdf2 As New Rfc2898DeriveBytes("password", salt, 100000) ' Good: PBKDF2 with high iterations
            Dim derivedKey = pbkdf2.GetBytes(32) ' Good: 256-bit derived key
            
            ' GOOD: Scrypt for password hashing
            Dim scryptHash = SCrypt.ComputeDerivedKey(passwordBytes, saltBytes, 16384, 8, 1, Nothing, 32) ' Good: Scrypt
            
            ' GOOD: Argon2 for password hashing
            Dim argon2Hash = Argon2.Hash("password", "salt", 3, 65536, 4, 32, Argon2Type.Argon2id) ' Good: Argon2
        End Sub
        
        Sub GoodKeyManagement()
            ' GOOD: Proper key sizes and generation
            Dim aesKey(31) As Byte ' 256-bit AES key
            Dim hmacKey(31) As Byte ' 256-bit HMAC key
            Dim iv(15) As Byte ' 128-bit IV
            
            Using rng As New RNGCryptoServiceProvider()
                rng.GetBytes(aesKey) ' Good: secure key generation
                rng.GetBytes(hmacKey) ' Good: secure key generation
                rng.GetBytes(iv) ' Good: secure IV generation
            End Using
        End Sub
        
        Sub GoodCertificateValidation()
            ' GOOD: Strong certificate validation
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 Or SecurityProtocolType.Tls13 ' Good: strong TLS
            ServicePointManager.ServerCertificateValidationCallback = AddressOf ValidateServerCertificate ' Good: certificate validation
        End Sub
        
        Function ValidateServerCertificate(sender As Object, certificate As X509Certificate, chain As X509Chain, sslPolicyErrors As SslPolicyErrors) As Boolean
            ' GOOD: Proper certificate validation logic
            If sslPolicyErrors = SslPolicyErrors.None Then
                Return True
            End If
            
            ' Log and reject invalid certificates
            LogSecurityEvent("Invalid certificate", sslPolicyErrors.ToString())
            Return False ' Good: reject invalid certificates
        End Function
        
        Sub LogSecurityEvent(eventType As String, details As String)
            ' Security event logging
        End Sub
        
        ' Helper fields and methods
        Private data As Byte() = New Byte() {1, 2, 3, 4, 5}
        Private salt As Byte() = New Byte() {1, 2, 3, 4, 5, 6, 7, 8}
        Private passwordBytes As Byte() = System.Text.Encoding.UTF8.GetBytes("password")
        Private saltBytes As Byte() = New Byte() {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
        
        ' Mock classes for examples (these would be real implementations)
        Public Class RC4CryptoServiceProvider
        End Class
        
        Public Class RC4
            Public Shared Function Create() As RC4
                Return New RC4()
            End Function
        End Class
        
        Public Class AesCcm
            Public Sub New(key As Byte())
            End Sub
        End Class
        
        Public Class SCrypt
            Public Shared Function ComputeDerivedKey(password As Byte(), salt As Byte(), N As Integer, r As Integer, p As Integer, dkLen As Integer?, dkLenBytes As Integer) As Byte()
                Return New Byte(dkLenBytes - 1) {}
            End Function
        End Class
        
        Public Class Argon2
            Public Shared Function Hash(password As String, salt As String, timeCost As Integer, memoryCost As Integer, parallelism As Integer, hashLength As Integer, type As Argon2Type) As Byte()
                Return New Byte(hashLength - 1) {}
            End Function
        End Class
        
        Public Enum Argon2Type
            Argon2d
            Argon2i
            Argon2id
        End Enum
    </script>
</body>
</html>

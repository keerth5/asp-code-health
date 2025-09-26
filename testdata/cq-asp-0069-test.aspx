<%@ Page Language="VB" %>
<html>
<head>
    <title>Configuration Errors Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Configuration errors - missing or incorrect configuration settings
        
        Sub BadConfigurationExamples()
            ' BAD: Configuration access without null checks
            Dim connectionString = ConfigurationManager.ConnectionStrings("DefaultConnection") ' Bad: no null check
            Dim appSetting = ConfigurationManager.AppSettings("ApiKey") ' Bad: no null check
            Dim mailServer = ConfigurationManager.AppSettings("MailServer") ' Bad: no null check
            
            ' BAD: Using configuration values directly without validation
            Dim dbConnection = connectionString.ConnectionString ' Bad: no validation
            Dim apiEndpoint = ConfigurationManager.AppSettings("ApiEndpoint") ' Bad: no validation
            Dim maxRetries = ConfigurationManager.AppSettings("MaxRetries") ' Bad: no validation
            
            ' BAD: Debug mode in production (simulated web.config references)
            ' web.config debug="true" ' Bad: debug mode enabled
            ' compilation debug="true" ' Bad: compilation debug enabled
            ProcessWithDebugMode() ' Simulating debug mode usage
            
            ' BAD: Production connection strings pointing to localhost/development
            Dim localConnectionString = "Server=localhost;Database=MyApp;Trusted_Connection=true" ' Bad: localhost in production
            Dim devConnectionString = "Server=127.0.0.1;Database=MyApp;Uid=sa;Pwd=password;" ' Bad: 127.0.0.1 in production
            Dim sqlExpressConnection = "Server=.\\SQLEXPRESS;Database=MyApp;Trusted_Connection=true" ' Bad: SQL Express in production
        End Sub
        
        Sub MoreBadConfigurationExamples()
            ' BAD: Missing configuration validation
            Dim timeout = ConfigurationManager.AppSettings("RequestTimeout") ' Bad: no validation
            Dim bufferSize = ConfigurationManager.AppSettings("BufferSize") ' Bad: no validation
            
            ' BAD: Hardcoded development settings
            Dim isDevelopment = True ' Bad: hardcoded development flag
            Dim debugLogging = True ' Bad: hardcoded debug setting
            
            ' BAD: Insecure default configurations
            Dim enableTracing = True ' Bad: tracing enabled by default
            Dim allowAnonymous = True ' Bad: anonymous access allowed
        End Sub
        
        ' GOOD: Proper configuration management with validation
        
        Sub GoodConfigurationExamples()
            ' GOOD: Configuration access with null checks
            Dim connectionStringSetting = ConfigurationManager.ConnectionStrings("DefaultConnection")
            If connectionStringSetting IsNot Nothing Then
                Dim connectionString = connectionStringSetting.ConnectionString ' Good: null check performed
                UseConnectionString(connectionString)
            Else
                LogError("Connection string 'DefaultConnection' not found")
            End If
            
            ' GOOD: App settings with null checks
            Dim apiKeySetting = ConfigurationManager.AppSettings("ApiKey")
            If apiKeySetting IsNot Nothing Then
                Dim apiKey = apiKeySetting ' Good: null check performed
                UseApiKey(apiKey)
            Else
                LogError("App setting 'ApiKey' not found")
            End If
        End Sub
        
        Sub GoodConfigurationValidation()
            ' GOOD: Configuration validation with defaults
            Dim maxRetriesSetting = ConfigurationManager.AppSettings("MaxRetries")
            Dim maxRetries As Integer = 3 ' Default value
            
            If maxRetriesSetting IsNot Nothing Then
                If Integer.TryParse(maxRetriesSetting, maxRetries) Then ' Good: validation with TryParse
                    If maxRetries < 1 OrElse maxRetries > 10 Then
                        maxRetries = 3 ' Reset to default if out of range
                        LogWarning("MaxRetries out of range, using default: 3")
                    End If
                Else
                    LogWarning("Invalid MaxRetries value, using default: 3")
                End If
            End If
            
            UseMaxRetries(maxRetries)
        End Sub
        
        Sub GoodConfigurationWithHasValue()
            ' GOOD: Using HasValue pattern for configuration
            Dim timeoutSetting = ConfigurationManager.AppSettings("RequestTimeout")
            If Not String.IsNullOrEmpty(timeoutSetting) Then ' Good: HasValue-like check
                Dim timeout As Integer
                If Integer.TryParse(timeoutSetting, timeout) Then
                    UseTimeout(timeout) ' Good: validated configuration
                End If
            End If
        End Sub
        
        Sub GoodConfigurationFactory()
            ' GOOD: Configuration factory pattern
            Dim config = CreateConfigurationSettings() ' Good: factory validates all settings
            UseConfiguration(config)
        End Sub
        
        Sub GoodEnvironmentBasedConfiguration()
            ' GOOD: Environment-based configuration
            Dim environment = ConfigurationManager.AppSettings("Environment")
            If String.IsNullOrEmpty(environment) Then
                environment = "Production" ' Good: default to production
            End If
            
            Select Case environment.ToLower()
                Case "development"
                    LoadDevelopmentConfig() ' Good: environment-specific config
                Case "test"
                    LoadTestConfig() ' Good: environment-specific config
                Case "production"
                    LoadProductionConfig() ' Good: environment-specific config
                Case Else
                    LoadProductionConfig() ' Good: default to production
                    LogWarning("Unknown environment, defaulting to production")
            End Select
        End Sub
        
        Sub GoodSecureConnectionStrings()
            ' GOOD: Secure connection string validation
            Dim connectionString = GetSecureConnectionString()
            If ValidateConnectionString(connectionString) Then
                UseConnectionString(connectionString) ' Good: validated connection string
            Else
                LogError("Invalid or insecure connection string")
                Throw New ConfigurationErrorsException("Database configuration error")
            End If
        End Sub
        
        Function GetSecureConnectionString() As String
            ' GOOD: Secure connection string retrieval
            Dim connectionStringSetting = ConfigurationManager.ConnectionStrings("DefaultConnection")
            If connectionStringSetting IsNot Nothing Then
                Return connectionStringSetting.ConnectionString ' Good: null check performed
            Else
                Throw New ConfigurationErrorsException("Connection string not found") ' Good: explicit error
            End If
        End Function
        
        Function ValidateConnectionString(connectionString As String) As Boolean
            ' GOOD: Connection string validation
            If String.IsNullOrEmpty(connectionString) Then
                Return False
            End If
            
            ' Check for development/localhost indicators
            If connectionString.ToLower().Contains("localhost") OrElse
               connectionString.ToLower().Contains("127.0.0.1") OrElse
               connectionString.ToLower().Contains("sqlexpress") Then
                
                Dim environment = ConfigurationManager.AppSettings("Environment")
                If environment IsNot Nothing AndAlso environment.ToLower() <> "development" Then
                    LogWarning("Development connection string detected in non-development environment") ' Good: validation
                    Return False
                End If
            End If
            
            Return True ' Good: validation passed
        End Function
        
        Sub GoodConfigurationEncryption()
            ' GOOD: Configuration encryption handling
            Try
                Dim encryptedSetting = ConfigurationManager.AppSettings("EncryptedApiKey")
                If encryptedSetting IsNot Nothing Then
                    Dim decryptedValue = DecryptConfigValue(encryptedSetting) ' Good: encrypted config
                    UseApiKey(decryptedValue)
                End If
            Catch ex As CryptographicException
                LogError("Configuration decryption failed: " & ex.Message)
            End Try
        End Sub
        
        Sub GoodConfigurationCaching()
            ' GOOD: Configuration caching for performance
            Static cachedConfig As Dictionary(Of String, String) = Nothing
            
            If cachedConfig Is Nothing Then
                cachedConfig = New Dictionary(Of String, String)()
                LoadConfigurationCache(cachedConfig) ' Good: cache configuration
            End If
            
            If cachedConfig.ContainsKey("ApiEndpoint") Then
                Dim apiEndpoint = cachedConfig("ApiEndpoint") ' Good: cached access
                UseApiEndpoint(apiEndpoint)
            End If
        End Sub
        
        Sub GoodConfigurationMonitoring()
            ' GOOD: Configuration change monitoring
            AddHandler ConfigurationManager.RefreshSection, AddressOf OnConfigurationChanged ' Good: monitor changes
            
            ' Validate critical settings
            ValidateAllCriticalSettings() ' Good: comprehensive validation
        End Sub
        
        Sub ValidateAllCriticalSettings()
            ' GOOD: Comprehensive configuration validation
            Dim errors As New List(Of String)()
            
            ' Validate connection strings
            If ConfigurationManager.ConnectionStrings("DefaultConnection") Is Nothing Then
                errors.Add("Missing DefaultConnection connection string")
            End If
            
            ' Validate required app settings
            Dim requiredSettings As String() = {"ApiKey", "MailServer", "MaxRetries", "RequestTimeout"}
            For Each setting In requiredSettings
                If String.IsNullOrEmpty(ConfigurationManager.AppSettings(setting)) Then
                    errors.Add($"Missing required app setting: {setting}") ' Good: validation
                End If
            Next
            
            If errors.Count > 0 Then
                Dim errorMessage = "Configuration errors: " & String.Join(", ", errors)
                LogError(errorMessage)
                Throw New ConfigurationErrorsException(errorMessage) ' Good: fail fast on config errors
            End If
        End Sub
        
        Function CreateConfigurationSettings() As AppConfiguration
            ' GOOD: Configuration factory with validation
            Dim config As New AppConfiguration()
            
            ' Load and validate each setting
            config.ApiKey = GetRequiredSetting("ApiKey") ' Good: required setting validation
            config.MailServer = GetRequiredSetting("MailServer")
            config.MaxRetries = GetIntSetting("MaxRetries", 3, 1, 10) ' Good: range validation
            config.RequestTimeout = GetIntSetting("RequestTimeout", 30, 5, 300)
            config.EnableDebug = GetBoolSetting("EnableDebug", False) ' Good: default to false
            
            Return config ' Good: fully validated configuration
        End Function
        
        Function GetRequiredSetting(key As String) As String
            ' GOOD: Required setting helper
            Dim value = ConfigurationManager.AppSettings(key)
            If String.IsNullOrEmpty(value) Then
                Throw New ConfigurationErrorsException($"Required setting '{key}' is missing") ' Good: explicit error
            End If
            Return value ' Good: validated setting
        End Function
        
        Function GetIntSetting(key As String, defaultValue As Integer, minValue As Integer, maxValue As Integer) As Integer
            ' GOOD: Integer setting with range validation
            Dim strValue = ConfigurationManager.AppSettings(key)
            If String.IsNullOrEmpty(strValue) Then
                Return defaultValue ' Good: default value
            End If
            
            Dim intValue As Integer
            If Integer.TryParse(strValue, intValue) Then
                If intValue >= minValue AndAlso intValue <= maxValue Then
                    Return intValue ' Good: validated value
                Else
                    LogWarning($"Setting '{key}' value {intValue} out of range [{minValue}-{maxValue}], using default: {defaultValue}")
                    Return defaultValue ' Good: range validation
                End If
            Else
                LogWarning($"Setting '{key}' value '{strValue}' is not a valid integer, using default: {defaultValue}")
                Return defaultValue ' Good: parse validation
            End If
        End Function
        
        Function GetBoolSetting(key As String, defaultValue As Boolean) As Boolean
            ' GOOD: Boolean setting helper
            Dim strValue = ConfigurationManager.AppSettings(key)
            If String.IsNullOrEmpty(strValue) Then
                Return defaultValue ' Good: default value
            End If
            
            Dim boolValue As Boolean
            If Boolean.TryParse(strValue, boolValue) Then
                Return boolValue ' Good: validated boolean
            Else
                LogWarning($"Setting '{key}' value '{strValue}' is not a valid boolean, using default: {defaultValue}")
                Return defaultValue ' Good: validation with fallback
            End If
        End Function
        
        ' Helper methods and classes
        Sub ProcessWithDebugMode()
        End Sub
        
        Sub UseConnectionString(connectionString As String)
        End Sub
        
        Sub UseApiKey(apiKey As String)
        End Sub
        
        Sub UseMaxRetries(maxRetries As Integer)
        End Sub
        
        Sub UseTimeout(timeout As Integer)
        End Sub
        
        Sub UseConfiguration(config As AppConfiguration)
        End Sub
        
        Sub UseApiEndpoint(endpoint As String)
        End Sub
        
        Sub LoadDevelopmentConfig()
        End Sub
        
        Sub LoadTestConfig()
        End Sub
        
        Sub LoadProductionConfig()
        End Sub
        
        Sub LoadConfigurationCache(cache As Dictionary(Of String, String))
        End Sub
        
        Sub OnConfigurationChanged()
        End Sub
        
        Function DecryptConfigValue(encryptedValue As String) As String
            Return encryptedValue ' Simplified
        End Function
        
        Sub LogError(message As String)
        End Sub
        
        Sub LogWarning(message As String)
        End Sub
        
        Public Class AppConfiguration
            Public Property ApiKey As String
            Public Property MailServer As String
            Public Property MaxRetries As Integer
            Public Property RequestTimeout As Integer
            Public Property EnableDebug As Boolean
        End Class
    </script>
</body>
</html>

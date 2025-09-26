<%@ Page Language="VB" %>
<html>
<head>
    <title>Unhandled Exceptions Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Unhandled exceptions - exception-throwing code without proper try-catch blocks
        
        Sub BadUnhandledExceptionExamples()
            ' BAD: Convert/Parse operations without try-catch
            Dim userInput As String = Request.Form("number")
            Dim number = Convert.ToInt32(userInput) ' Bad: can throw FormatException
            Dim decimal1 = Convert.ToDecimal(userInput) ' Bad: can throw FormatException
            Dim date1 = Convert.ToDateTime(userInput) ' Bad: can throw FormatException
            
            ' BAD: Parse operations without exception handling
            Dim intValue = Integer.Parse(userInput) ' Bad: can throw FormatException
            Dim doubleValue = Double.Parse(userInput) ' Bad: can throw FormatException
            Dim dateValue = Date.Parse(userInput) ' Bad: can throw FormatException
            Dim boolValue = Boolean.Parse(userInput) ' Bad: can throw FormatException
            
            ' BAD: ParseExact operations without exception handling
            Dim exactDate = Date.ParseExact(userInput, "yyyy-MM-dd", Nothing) ' Bad: can throw FormatException
            Dim exactTime = TimeSpan.ParseExact(userInput, "hh\:mm\:ss", Nothing) ' Bad: can throw FormatException
        End Sub
        
        Sub BadFileOperationsWithoutTryCatch()
            ' BAD: File operations without exception handling
            Dim filename As String = Request.QueryString("file")
            File.Delete(filename) ' Bad: can throw UnauthorizedAccessException, FileNotFoundException
            File.Move("old.txt", "new.txt") ' Bad: can throw IOException, UnauthorizedAccessException
            File.Copy("source.txt", "dest.txt") ' Bad: can throw IOException, UnauthorizedAccessException
            File.Create("newfile.txt") ' Bad: can throw UnauthorizedAccessException, DirectoryNotFoundException
            
            ' BAD: Directory operations without exception handling
            Directory.Delete("temp") ' Bad: can throw DirectoryNotFoundException, IOException
            Directory.Move("olddir", "newdir") ' Bad: can throw IOException, UnauthorizedAccessException
            Directory.Create("newdir") ' Bad: can throw IOException, UnauthorizedAccessException
        End Sub
        
        Sub BadDatabaseOperationsWithoutTryCatch()
            ' BAD: Database operations without exception handling
            Dim connectionString As String = GetConnectionString()
            Dim connection As New SqlConnection(connectionString) ' Bad: constructor can throw
            connection.Open() ' Bad: can throw SqlException, InvalidOperationException
            
            Dim command As New SqlCommand("SELECT * FROM Users", connection) ' Bad: can throw
            Dim reader = command.ExecuteReader() ' Bad: can throw SqlException
            Dim result = command.ExecuteScalar() ' Bad: can throw SqlException
            command.ExecuteNonQuery() ' Bad: can throw SqlException
        End Sub
        
        Sub MoreBadUnhandledExceptions()
            ' BAD: Network operations without exception handling
            Dim client As New WebClient()
            Dim data = client.DownloadString("http://example.com") ' Bad: can throw WebException
            
            ' BAD: Array access without bounds checking
            Dim array(5) As Integer
            Dim index As Integer = GetIndex()
            array(index) = 100 ' Bad: can throw IndexOutOfRangeException
            
            ' BAD: Null reference operations
            Dim obj As Object = GetObject()
            obj.ToString() ' Bad: can throw NullReferenceException
        End Sub
        
        ' GOOD: Proper exception handling with try-catch blocks
        
        Sub GoodConvertOperationsWithTryCatch()
            ' GOOD: Convert/Parse operations with try-catch
            Dim userInput As String = Request.Form("number")
            Try
                Dim number = Convert.ToInt32(userInput) ' Good: protected by try-catch
                ProcessNumber(number)
            Catch ex As FormatException
                LogError("Invalid number format: " & userInput)
            Catch ex As OverflowException
                LogError("Number out of range: " & userInput)
            End Try
        End Sub
        
        Sub GoodTryParseOperations()
            ' GOOD: Using TryParse methods instead of Parse
            Dim userInput As String = Request.Form("number")
            Dim intResult As Integer
            If Integer.TryParse(userInput, intResult) Then ' Good: TryParse used
                ProcessNumber(intResult)
            Else
                LogError("Invalid integer: " & userInput)
            End If
            
            Dim doubleResult As Double
            If Double.TryParse(userInput, doubleResult) Then ' Good: TryParse used
                ProcessDouble(doubleResult)
            End If
            
            Dim dateResult As Date
            If Date.TryParse(userInput, dateResult) Then ' Good: TryParse used
                ProcessDate(dateResult)
            End If
        End Sub
        
        Sub GoodFileOperationsWithTryCatch()
            ' GOOD: File operations with exception handling
            Dim filename As String = Request.QueryString("file")
            Try
                File.Delete(filename) ' Good: protected by try-catch
            Catch ex As UnauthorizedAccessException
                LogError("Access denied: " & filename)
            Catch ex As FileNotFoundException
                LogError("File not found: " & filename)
            Catch ex As IOException
                LogError("IO error: " & ex.Message)
            End Try
        End Sub
        
        Sub GoodFileOperationsWithExistsCheck()
            ' GOOD: File operations with existence checks
            Dim filename As String = "test.txt"
            If File.Exists(filename) Then ' Good: exists check before operation
                Try
                    File.Delete(filename) ' Good: protected by try-catch and exists check
                Catch ex As Exception
                    LogError("Error deleting file: " & ex.Message)
                End Try
            End If
        End Sub
        
        Sub GoodDatabaseOperationsWithTryCatch()
            ' GOOD: Database operations with exception handling
            Dim connectionString As String = GetConnectionString()
            Try
                Using connection As New SqlConnection(connectionString) ' Good: using statement and try-catch
                    connection.Open() ' Good: protected by try-catch
                    
                    Using command As New SqlCommand("SELECT * FROM Users", connection)
                        Using reader = command.ExecuteReader() ' Good: protected by try-catch
                            While reader.Read()
                                ProcessData(reader)
                            End While
                        End Using
                    End Using
                End Using
            Catch ex As SqlException
                LogError("Database error: " & ex.Message)
            Catch ex As InvalidOperationException
                LogError("Invalid operation: " & ex.Message)
            End Try
        End Sub
        
        Sub GoodNetworkOperationsWithTryCatch()
            ' GOOD: Network operations with exception handling
            Try
                Dim client As New WebClient()
                Dim data = client.DownloadString("http://example.com") ' Good: protected by try-catch
                ProcessData(data)
            Catch ex As WebException
                LogError("Network error: " & ex.Message)
            Catch ex As UriFormatException
                LogError("Invalid URL format")
            End Try
        End Sub
        
        Sub GoodArrayAccessWithValidation()
            ' GOOD: Array access with bounds checking
            Dim array(5) As Integer
            Dim index As Integer = GetIndex()
            
            If index >= 0 AndAlso index < array.Length Then
                array(index) = 100 ' Good: bounds check performed
            Else
                LogError("Index out of bounds: " & index.ToString())
            End If
        End Sub
        
        Sub GoodNullReferenceHandling()
            ' GOOD: Null reference protection
            Dim obj As Object = GetObject()
            If obj IsNot Nothing Then
                obj.ToString() ' Good: null check performed
            End If
            
            ' Alternative with try-catch
            Try
                Dim result = obj.ToString() ' Good: protected by try-catch
                ProcessResult(result)
            Catch ex As NullReferenceException
                LogError("Null reference encountered")
            End Try
        End Sub
        
        Sub GoodMultipleExceptionHandling()
            ' GOOD: Handling multiple exception types
            Dim userInput As String = Request.Form("data")
            Try
                Dim number = Convert.ToInt32(userInput) ' Good: multiple exceptions handled
                Dim result = 100 / number
                ProcessResult(result)
            Catch ex As FormatException
                LogError("Invalid format: " & userInput)
            Catch ex As OverflowException
                LogError("Number overflow: " & userInput)
            Catch ex As DivideByZeroException
                LogError("Division by zero")
            Catch ex As Exception
                LogError("Unexpected error: " & ex.Message)
            End Try
        End Sub
        
        Sub GoodFinallyBlockUsage()
            ' GOOD: Using finally block for cleanup
            Dim resource As IDisposable = Nothing
            Try
                resource = CreateResource() ' Good: resource creation protected
                UseResource(resource)
            Catch ex As Exception
                LogError("Error using resource: " & ex.Message)
            Finally
                If resource IsNot Nothing Then
                    resource.Dispose() ' Good: cleanup in finally block
                End If
            End Try
        End Sub
        
        Sub GoodCustomExceptionHandling()
            ' GOOD: Custom exception handling
            Try
                PerformBusinessOperation() ' Good: business logic protected
            Catch ex As BusinessException
                HandleBusinessException(ex)
            Catch ex As ValidationException
                HandleValidationException(ex)
            Catch ex As Exception
                LogError("Unexpected error: " & ex.Message)
                Throw ' Re-throw if not handled
            End Try
        End Sub
        
        Sub GoodAsyncExceptionHandling()
            ' GOOD: Async operation exception handling
            Try
                Dim task = PerformAsyncOperation()
                task.Wait() ' Good: wait protected by try-catch
            Catch ex As AggregateException
                For Each innerEx In ex.InnerExceptions
                    LogError("Async error: " & innerEx.Message)
                Next
            End Try
        End Sub
        
        ' Helper methods and classes
        Function GetConnectionString() As String
            Return "Server=localhost;Database=TestDB;Trusted_Connection=true"
        End Function
        
        Function GetIndex() As Integer
            Return 3
        End Function
        
        Function GetObject() As Object
            Return "test"
        End Function
        
        Function CreateResource() As IDisposable
            Return New MemoryStream()
        End Function
        
        Sub ProcessNumber(number As Integer)
        End Sub
        
        Sub ProcessDouble(value As Double)
        End Sub
        
        Sub ProcessDate(dateValue As Date)
        End Sub
        
        Sub ProcessData(data As Object)
        End Sub
        
        Sub ProcessResult(result As Object)
        End Sub
        
        Sub UseResource(resource As IDisposable)
        End Sub
        
        Sub PerformBusinessOperation()
        End Sub
        
        Sub HandleBusinessException(ex As Exception)
        End Sub
        
        Sub HandleValidationException(ex As Exception)
        End Sub
        
        Function PerformAsyncOperation() As Task
            Return Task.CompletedTask
        End Function
        
        Sub LogError(message As String)
        End Sub
        
        ' Custom exception classes
        Public Class BusinessException
            Inherits Exception
            
            Public Sub New(message As String)
                MyBase.New(message)
            End Sub
        End Class
        
        Public Class ValidationException
            Inherits Exception
            
            Public Sub New(message As String)
                MyBase.New(message)
            End Sub
        End Class
    </script>
</body>
</html>

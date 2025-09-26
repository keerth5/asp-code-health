<%@ Page Language="VB" %>
<html>
<head>
    <title>Resource Disposal Issues Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Not disposing resources properly
        Sub BadResourceDisposalMethod()
            Dim connection As New SqlConnection(connectionString) ' No dispose
            connection.Open()
            
            Set command = New SqlCommand("SELECT * FROM users", connection) ' No dispose
            Dim reader = command.ExecuteReader() ' No dispose
            
            Dim fileStream As New FileStream("data.txt", FileMode.Open) ' No dispose
            Dim streamReader As New StreamReader(fileStream) ' No dispose
            Dim content = streamReader.ReadToEnd()
            
            Dim writer As New StreamWriter("output.txt") ' No dispose
            writer.WriteLine("Data processed")
        End Sub
        
        ' BAD: Improper using statement
        Sub BadUsingStatement()
            Using connection As New SqlConnection(connectionString) ' Missing proper block
            
            Using reader As StreamReader ' Incomplete using
        End Sub
        
        ' BAD: Class implementing IDisposable without proper pattern
        Public Class BadDisposableClass
            Private connection As SqlConnection
            Private fileStream As FileStream
            Private streamReader As StreamReader ' Not implementing IDisposable
            
            Sub New()
                connection = New SqlConnection()
                fileStream = New FileStream("temp.txt", FileMode.Create)
                streamReader = New StreamReader(fileStream)
            End Sub
        End Class
        
        ' GOOD: Proper resource disposal with Using statements
        Sub GoodResourceDisposalMethod()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                
                Using command As New SqlCommand("SELECT * FROM users", connection)
                    Using reader = command.ExecuteReader()
                        While reader.Read()
                            ProcessRecord(reader)
                        End While
                    End Using
                End Using
            End Using
            
            Using fileStream As New FileStream("data.txt", FileMode.Open)
                Using streamReader As New StreamReader(fileStream)
                    Dim content = streamReader.ReadToEnd()
                    ProcessContent(content)
                End Using
            End Using
        End Sub
        
        ' GOOD: Manual disposal with try-finally
        Sub GoodManualDisposalMethod()
            Dim connection As SqlConnection = Nothing
            Dim command As SqlCommand = Nothing
            
            Try
                connection = New SqlConnection(connectionString)
                connection.Open()
                
                command = New SqlCommand("SELECT * FROM users", connection)
                Dim result = command.ExecuteScalar()
            Finally
                If command IsNot Nothing Then
                    command.Dispose()
                End If
                
                If connection IsNot Nothing Then
                    connection.Dispose()
                End If
            End Try
        End Sub
        
        ' GOOD: Class implementing IDisposable properly
        Public Class GoodDisposableClass
            Implements IDisposable
            
            Private connection As SqlConnection
            Private fileStream As FileStream
            Private disposed As Boolean = False
            
            Sub New()
                connection = New SqlConnection()
                fileStream = New FileStream("temp.txt", FileMode.Create)
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                GC.SuppressFinalize(Me)
            End Sub
            
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        If connection IsNot Nothing Then
                            connection.Dispose()
                        End If
                        
                        If fileStream IsNot Nothing Then
                            fileStream.Dispose()
                        End If
                    End If
                    
                    disposed = True
                End If
            End Sub
        End Class
        
        ' Helper methods
        Sub ProcessRecord(reader As SqlDataReader)
        End Sub
        
        Sub ProcessContent(content As String)
        End Sub
    </script>
</body>
</html>

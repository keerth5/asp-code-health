<%@ Page Language="VB" %>
<html>
<head>
    <title>Resource Leaks Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Resource leaks - resources not properly disposed or closed
        
        Sub BadResourceLeakExamples()
            ' BAD: File operations without proper disposal
            Dim fileStream As New FileStream("data.txt", FileMode.Open) ' Bad: no using or dispose
            Dim reader As New StreamReader("input.txt") ' Bad: no using or dispose
            Dim writer As New StreamWriter("output.txt") ' Bad: no using or dispose
            
            ' BAD: Database connections without proper disposal
            Dim connection As New SqlConnection(connectionString) ' Bad: no using or dispose
            Dim command As New SqlCommand("SELECT * FROM Users", connection) ' Bad: no using or dispose
            Dim dataReader = command.ExecuteReader() ' Bad: no using or dispose
            
            ' BAD: File operations without disposal
            Dim file = File.Open("test.txt", FileMode.Read) ' Bad: no using or dispose
            Dim createdFile = File.Create("new.txt") ' Bad: no using or dispose
            Dim readFile = File.OpenRead("read.txt") ' Bad: no using or dispose
            Dim writeFile = File.OpenWrite("write.txt") ' Bad: no using or dispose
            
            ' BAD: Graphics resources without disposal
            Dim graphics = Graphics.FromFile("image.png") ' Bad: no using or dispose
            Dim bitmap = Bitmap.FromFile("bitmap.bmp") ' Bad: no using or dispose
            Dim image = Image.FromStream(GetImageStream()) ' Bad: no using or dispose
        End Sub
        
        Sub MoreBadResourceExamples()
            ' BAD: Multiple resource allocations without cleanup
            Dim stream1 As New MemoryStream() ' Bad: no using or dispose
            Dim stream2 As New BufferedStream(stream1) ' Bad: no using or dispose
            
            ' BAD: Network resources without disposal
            Dim client As New WebClient() ' Bad: no using or dispose
            Dim httpClient As New HttpClient() ' Bad: no using or dispose
            
            ' BAD: Timer resources without disposal
            Dim timer As New System.Timers.Timer() ' Bad: no using or dispose
            
            ' BAD: Complex resource chains without cleanup
            Set connection = New SqlConnection(connectionString) ' Bad: using Set without disposal
            Set command = New SqlCommand("SELECT * FROM Products") ' Bad: using Set without disposal
        End Sub
        
        ' GOOD: Proper resource management with Using statements
        
        Sub GoodResourceManagementWithUsing()
            ' GOOD: File operations with Using statements
            Using fileStream As New FileStream("data.txt", FileMode.Open)
                ' Use fileStream safely - Good: Using statement ensures disposal
                Dim buffer(1024) As Byte
                fileStream.Read(buffer, 0, buffer.Length)
            End Using ' Good: Automatically disposed
            
            Using reader As New StreamReader("input.txt")
                Dim content = reader.ReadToEnd() ' Good: Using statement ensures disposal
            End Using ' Good: Automatically disposed
            
            Using writer As New StreamWriter("output.txt")
                writer.WriteLine("Hello World") ' Good: Using statement ensures disposal
            End Using ' Good: Automatically disposed
        End Sub
        
        Sub GoodDatabaseResourceManagement()
            ' GOOD: Database connections with Using statements
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Using command As New SqlCommand("SELECT * FROM Users", connection)
                    Using dataReader = command.ExecuteReader()
                        While dataReader.Read()
                            ProcessData(dataReader) ' Good: All resources properly managed
                        End While
                    End Using ' Good: DataReader disposed
                End Using ' Good: Command disposed
            End Using ' Good: Connection disposed
        End Sub
        
        Sub GoodFileOperationsWithUsing()
            ' GOOD: File operations with Using statements
            Using file = File.Open("test.txt", FileMode.Read)
                Dim buffer(1024) As Byte
                file.Read(buffer, 0, buffer.Length) ' Good: Using ensures disposal
            End Using ' Good: File disposed
            
            Using createdFile = File.Create("new.txt")
                Dim data As Byte() = System.Text.Encoding.UTF8.GetBytes("Hello")
                createdFile.Write(data, 0, data.Length) ' Good: Using ensures disposal
            End Using ' Good: File disposed
        End Sub
        
        Sub GoodGraphicsResourceManagement()
            ' GOOD: Graphics resources with Using statements
            Using graphics = Graphics.FromFile("image.png")
                graphics.DrawString("Text", New Font("Arial", 12), Brushes.Black, 0, 0) ' Good: Using ensures disposal
            End Using ' Good: Graphics disposed
            
            Using bitmap = Bitmap.FromFile("bitmap.bmp")
                ProcessBitmap(bitmap) ' Good: Using ensures disposal
            End Using ' Good: Bitmap disposed
            
            Using image = Image.FromStream(GetImageStream())
                DisplayImage(image) ' Good: Using ensures disposal
            End Using ' Good: Image disposed
        End Sub
        
        Sub GoodManualDisposal()
            ' GOOD: Manual disposal when Using is not possible
            Dim fileStream As FileStream = Nothing
            Try
                fileStream = New FileStream("data.txt", FileMode.Open)
                ' Use fileStream
                ProcessFileStream(fileStream)
            Finally
                If fileStream IsNot Nothing Then
                    fileStream.Dispose() ' Good: Manual disposal in Finally block
                End If
            End Try
        End Sub
        
        Sub GoodTryFinallyPattern()
            ' GOOD: Try-Finally pattern for resource cleanup
            Dim connection As SqlConnection = Nothing
            Dim command As SqlCommand = Nothing
            Try
                connection = New SqlConnection(connectionString)
                command = New SqlCommand("SELECT * FROM Products", connection)
                connection.Open()
                Dim result = command.ExecuteScalar()
                ProcessResult(result)
            Finally
                If command IsNot Nothing Then
                    command.Dispose() ' Good: Manual disposal
                End If
                If connection IsNot Nothing Then
                    connection.Close() ' Good: Manual close
                    connection.Dispose() ' Good: Manual disposal
                End If
            End Try
        End Sub
        
        Sub GoodNestedUsingStatements()
            ' GOOD: Nested Using statements for multiple resources
            Using outerStream As New FileStream("outer.txt", FileMode.Open)
                Using innerReader As New StreamReader(outerStream)
                    Using writer As New StringWriter()
                        Dim line As String
                        Do
                            line = innerReader.ReadLine()
                            If line IsNot Nothing Then
                                writer.WriteLine(line.ToUpper()) ' Good: All resources managed
                            End If
                        Loop While line IsNot Nothing
                    End Using ' Good: StringWriter disposed
                End Using ' Good: StreamReader disposed
            End Using ' Good: FileStream disposed
        End Sub
        
        Sub GoodResourceFactoryPattern()
            ' GOOD: Factory pattern with proper resource management
            Using resource = CreateManagedResource()
                ProcessManagedResource(resource) ' Good: Factory ensures proper disposal
            End Using ' Good: Resource disposed through factory
        End Sub
        
        Sub GoodConditionalResourceManagement()
            ' GOOD: Conditional resource creation with proper cleanup
            Dim shouldCreateFile As Boolean = ShouldCreateFile()
            If shouldCreateFile Then
                Using fileStream As New FileStream("conditional.txt", FileMode.Create)
                    WriteToFile(fileStream) ' Good: Conditional but properly managed
                End Using ' Good: File disposed
            End If
        End Sub
        
        Sub GoodResourcePooling()
            ' GOOD: Using resource pooling for expensive resources
            Dim pooledConnection = GetPooledConnection()
            Try
                UseConnection(pooledConnection) ' Good: Pooled resource management
            Finally
                ReturnToPool(pooledConnection) ' Good: Return to pool instead of dispose
            End Try
        End Sub
        
        Sub GoodWeakReferencePattern()
            ' GOOD: Weak references for optional resource cleanup
            Dim weakRef As New WeakReference(CreateExpensiveResource())
            If weakRef.IsAlive Then
                Dim resource = DirectCast(weakRef.Target, IDisposable)
                If resource IsNot Nothing Then
                    Using resource
                        ProcessResource(resource) ' Good: Weak reference with proper disposal
                    End Using ' Good: Resource disposed
                End If
            End If
        End Sub
        
        ' Helper methods and properties
        Private ReadOnly Property connectionString As String
            Get
                Return "Server=localhost;Database=TestDB;Trusted_Connection=true"
            End Get
        End Property
        
        Function GetImageStream() As Stream
            Return New MemoryStream()
        End Function
        
        Sub ProcessData(reader As SqlDataReader)
        End Sub
        
        Sub ProcessBitmap(bitmap As Bitmap)
        End Sub
        
        Sub DisplayImage(image As Image)
        End Sub
        
        Sub ProcessFileStream(stream As FileStream)
        End Sub
        
        Sub ProcessResult(result As Object)
        End Sub
        
        Function CreateManagedResource() As IDisposable
            Return New MemoryStream()
        End Function
        
        Sub ProcessManagedResource(resource As IDisposable)
        End Sub
        
        Function ShouldCreateFile() As Boolean
            Return True
        End Function
        
        Sub WriteToFile(stream As FileStream)
        End Sub
        
        Function GetPooledConnection() As IDisposable
            Return New SqlConnection(connectionString)
        End Function
        
        Sub UseConnection(connection As IDisposable)
        End Sub
        
        Sub ReturnToPool(connection As IDisposable)
        End Sub
        
        Function CreateExpensiveResource() As IDisposable
            Return New MemoryStream()
        End Function
        
        Sub ProcessResource(resource As IDisposable)
        End Sub
    </script>
</body>
</html>

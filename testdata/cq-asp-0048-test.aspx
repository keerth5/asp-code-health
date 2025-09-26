<%@ Page Language="VB" %>
<html>
<head>
    <title>Large Object Allocation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Large object allocation - allocating large objects frequently causing LOH pressure
        
        Sub BadLargeArrayAllocation()
            ' BAD: Large array allocations (>85KB go to Large Object Heap)
            Dim largeBuffer As New Byte(100000) {} ' Bad: >85KB allocation
            Dim hugeArray As New Char(200000) {} ' Bad: very large allocation
            Dim massiveData As New Integer(50000) {} ' Bad: large allocation
            
            ProcessLargeData(largeBuffer)
            ProcessCharData(hugeArray)
            ProcessIntData(massiveData)
        End Sub
        
        Sub BadLargeAllocationInLoop()
            ' BAD: Large allocations inside loops
            For i = 1 To 10
                Dim buffer As New Byte(90000) {} ' Bad: large allocation in loop
                ProcessBuffer(buffer)
            Next
            
            While hasMoreData
                Dim data As New Char(150000) {} ' Bad: large allocation in loop
                ProcessData(data)
            End While
            
            For Each item In items
                Dim workspace As New Integer(100000) {} ' Bad: large allocation in loop
                ProcessWorkspace(workspace)
            Next
        End Sub
        
        Function BadLargeObjectCreation() As Byte()
            ' BAD: Creating large objects without pooling
            Dim result As New Byte(500000) {} ' Bad: very large allocation
            Dim temp As New Byte(300000) {} ' Bad: large temporary allocation
            
            ' Process data
            Array.Copy(temp, result, temp.Length)
            Return result
        End Function
        
        Sub BadFrequentLargeStringAllocation()
            ' BAD: Large string allocations
            For i = 1 To 100
                Dim largeString As New String("x"c, 100000) ' Bad: large string in loop
                ProcessLargeString(largeString)
            Next
        End Sub
        
        Sub BadLargeCollectionAllocation()
            ' BAD: Large collection allocations without reuse
            Dim largeList As New List(Of Integer)(200000) ' Bad: large initial capacity
            Dim hugeDictionary As New Dictionary(Of String, String)(500000) ' Bad: very large capacity
            
            For i = 1 To 10
                Dim tempList As New List(Of String)(150000) ' Bad: large allocation in loop
                ProcessTempList(tempList)
            Next
        End Sub
        
        ' GOOD: Efficient large object management
        
        Sub GoodObjectPooling()
            ' GOOD: Using object pooling for large objects
            Dim bufferPool As New ObjectPool(Of Byte())(Function() New Byte(100000) {})
            
            For i = 1 To 10
                Dim buffer = bufferPool.Get() ' Get from pool
                Try
                    ProcessBuffer(buffer)
                Finally
                    bufferPool.Return(buffer) ' Return to pool
                End Try
            Next
        End Sub
        
        Sub GoodArrayPoolUsage()
            ' GOOD: Using ArrayPool for large arrays
            Dim pool = ArrayPool(Of Byte).Shared
            
            For i = 1 To 10
                Dim buffer = pool.Rent(100000) ' Rent from pool
                Try
                    ProcessBuffer(buffer)
                Finally
                    pool.Return(buffer) ' Return to pool
                End Try
            Next
        End Sub
        
        Sub GoodReusePattern()
            ' GOOD: Reusing large objects instead of creating new ones
            Dim reusableBuffer As New Byte(100000) {} ' Create once
            Dim reusableWorkspace As New Integer(50000) {} ' Create once
            
            For i = 1 To 10
                Array.Clear(reusableBuffer, 0, reusableBuffer.Length) ' Clear for reuse
                ProcessBuffer(reusableBuffer) ' Reuse existing buffer
                
                Array.Clear(reusableWorkspace, 0, reusableWorkspace.Length) ' Clear for reuse
                ProcessWorkspace(reusableWorkspace) ' Reuse existing workspace
            Next
        End Sub
        
        Function GoodStreamingProcessing() As Byte()
            ' GOOD: Streaming processing instead of large allocations
            Using memoryStream As New MemoryStream()
                ' Process data in chunks instead of large allocation
                Dim chunkSize As Integer = 8192 ' Small chunk size
                Dim chunk As New Byte(chunkSize - 1) {}
                
                While hasMoreData
                    Dim bytesRead = ReadDataChunk(chunk)
                    memoryStream.Write(chunk, 0, bytesRead)
                End While
                
                Return memoryStream.ToArray()
            End Using
        End Function
        
        Sub GoodLazyAllocation()
            ' GOOD: Lazy allocation - only allocate when needed
            Dim lazyBuffer As New Lazy(Of Byte())(Function() New Byte(100000) {})
            
            ' Only allocate if actually needed
            If needsLargeBuffer Then
                Dim buffer = lazyBuffer.Value
                ProcessBuffer(buffer)
            End If
        End Sub
        
        Sub GoodMemoryMappedFiles()
            ' GOOD: Using memory-mapped files for very large data
            Using mmf = MemoryMappedFile.CreateNew("large_data", 10000000) ' 10MB
                Using accessor = mmf.CreateViewAccessor(0, 10000000)
                    ' Work with memory-mapped data instead of large arrays
                    ProcessMemoryMappedData(accessor)
                End Using
            End Using
        End Sub
        
        Sub GoodChunkedProcessing()
            ' GOOD: Processing data in chunks to avoid large allocations
            Const chunkSize As Integer = 8192 ' 8KB chunks
            Dim totalSize As Integer = 1000000 ' 1MB total
            
            For offset = 0 To totalSize - 1 Step chunkSize
                Dim currentChunkSize = Math.Min(chunkSize, totalSize - offset)
                Dim chunk As New Byte(currentChunkSize - 1) {}
                
                ReadDataChunk(chunk, offset)
                ProcessChunk(chunk)
                ' chunk goes out of scope and can be garbage collected
            Next
        End Sub
        
        Sub GoodStringBuilderForLargeStrings()
            ' GOOD: Using StringBuilder instead of large string allocations
            Dim sb As New StringBuilder(100000) ' Pre-allocate capacity
            
            For i = 1 To 100
                sb.Append("Some text ") ' Efficient append
                sb.Append(i.ToString())
                sb.AppendLine()
            Next
            
            Dim result = sb.ToString() ' Single large string creation
            ProcessLargeString(result)
        End Sub
        
        Sub GoodWeakReferences()
            ' GOOD: Using weak references for large cached objects
            Dim weakCache As New Dictionary(Of String, WeakReference)()
            
            Dim cacheKey = "large_data"
            Dim weakRef As WeakReference = Nothing
            Dim largeData As Byte() = Nothing
            
            If weakCache.TryGetValue(cacheKey, weakRef) AndAlso weakRef.IsAlive Then
                largeData = CType(weakRef.Target, Byte())
            Else
                largeData = CreateLargeData() ' Create only if not in cache
                weakCache(cacheKey) = New WeakReference(largeData)
            End If
            
            ProcessLargeData(largeData)
        End Sub
        
        Sub GoodDisposablePattern()
            ' GOOD: Implementing IDisposable for objects with large allocations
            Using processor As New LargeDataProcessor()
                processor.ProcessData(inputData)
            End Using ' Automatically disposes and releases large allocations
        End Sub
        
        ' Helper methods and fields
        Private hasMoreData As Boolean = True
        Private items As New List(Of Object)()
        Private needsLargeBuffer As Boolean = True
        Private inputData As New List(Of Byte)()
        
        Sub ProcessLargeData(data As Byte())
        End Sub
        
        Sub ProcessCharData(data As Char())
        End Sub
        
        Sub ProcessIntData(data As Integer())
        End Sub
        
        Sub ProcessBuffer(buffer As Byte())
        End Sub
        
        Sub ProcessData(data As Char())
        End Sub
        
        Sub ProcessWorkspace(workspace As Integer())
        End Sub
        
        Sub ProcessLargeString(str As String)
        End Sub
        
        Sub ProcessTempList(list As List(Of String))
        End Sub
        
        Function ReadDataChunk(chunk As Byte()) As Integer
            Return chunk.Length
        End Function
        
        Sub ReadDataChunk(chunk As Byte(), offset As Integer)
        End Sub
        
        Sub ProcessChunk(chunk As Byte())
        End Sub
        
        Sub ProcessMemoryMappedData(accessor As MemoryMappedViewAccessor)
        End Sub
        
        Function CreateLargeData() As Byte()
            Return New Byte(100000) {}
        End Function
        
        ' Helper classes
        Public Class ObjectPool(Of T As Class)
            Private ReadOnly factory As Func(Of T)
            Private ReadOnly pool As New ConcurrentQueue(Of T)()
            
            Public Sub New(factory As Func(Of T))
                Me.factory = factory
            End Sub
            
            Public Function [Get]() As T
                Dim item As T = Nothing
                If pool.TryDequeue(item) Then
                    Return item
                End If
                Return factory()
            End Function
            
            Public Sub [Return](item As T)
                pool.Enqueue(item)
            End Sub
        End Class
        
        Public Class LargeDataProcessor
            Implements IDisposable
            
            Private largeBuffer As Byte()
            Private disposed As Boolean = False
            
            Public Sub New()
                largeBuffer = New Byte(1000000) {} ' 1MB buffer
            End Sub
            
            Public Sub ProcessData(data As List(Of Byte))
                If disposed Then Throw New ObjectDisposedException("LargeDataProcessor")
                ' Process using large buffer
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                GC.SuppressFinalize(Me)
            End Sub
            
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        largeBuffer = Nothing ' Release large allocation
                    End If
                    disposed = True
                End If
            End Sub
        End Class
    </script>
</body>
</html>

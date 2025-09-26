<%@ Page Language="VB" %>
<html>
<head>
    <title>Improper Singleton Implementation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Improper singleton implementation - singleton pattern without thread safety or proper lazy initialization
        
        ' BAD: Non-thread-safe singleton with static instance
        Class BadSingletonBasic
            Private Shared instance As BadSingletonBasic
            
            Private Sub New()
                ' Private constructor
            End Sub
            
            Public Shared Function GetInstance() As BadSingletonBasic
                ' BAD: Not thread-safe
                If instance Is Nothing Then
                    instance = New BadSingletonBasic()
                End If
                Return instance
            End Function
        End Class
        
        ' BAD: Singleton with public static field initialization
        Class BadSingletonStaticField
            ' BAD: Static initialization without thread safety consideration
            Public Shared ReadOnly Instance As BadSingletonStaticField = New BadSingletonStaticField()
            
            Private Sub New()
                ' Private constructor
            End Sub
        End Class
        
        ' BAD: Singleton without proper synchronization
        Class BadSingletonNoSync
            Private Shared _instance As BadSingletonNoSync
            
            Private Sub New()
            End Sub
            
            Public Shared Property Instance() As BadSingletonNoSync
                Get
                    ' BAD: Race condition possible
                    If _instance Is Nothing Then
                        _instance = New BadSingletonNoSync()
                    End If
                    Return _instance
                End Get
            End Property
        End Class
        
        ' BAD: Singleton with improper locking
        Class BadSingletonImproperLock
            Private Shared _instance As BadSingletonImproperLock
            Private Shared ReadOnly lockObject As New Object()
            
            Private Sub New()
            End Sub
            
            Public Shared Function GetInstance() As BadSingletonImproperLock
                ' BAD: Lock every time, not efficient
                SyncLock lockObject
                    If _instance Is Nothing Then
                        _instance = New BadSingletonImproperLock()
                    End If
                End SyncLock
                Return _instance
            End Function
        End Class
        
        ' BAD: Multiple singleton instances possible
        Class BadSingletonMultiple
            Private Shared instance1 As BadSingletonMultiple
            Private Shared instance2 As BadSingletonMultiple
            
            Private Sub New()
            End Sub
            
            ' BAD: Multiple ways to get instance
            Public Shared Function GetPrimaryInstance() As BadSingletonMultiple
                If instance1 Is Nothing Then
                    instance1 = New BadSingletonMultiple()
                End If
                Return instance1
            End Function
            
            Public Shared Function GetSecondaryInstance() As BadSingletonMultiple
                If instance2 Is Nothing Then
                    instance2 = New BadSingletonMultiple()
                End If
                Return instance2
            End Function
        End Class
        
        ' BAD: Singleton without lazy initialization consideration
        Class BadSingletonEagerInit
            ' BAD: Eager initialization might not be desired
            Private Shared ReadOnly _instance As New BadSingletonEagerInit()
            
            Private Sub New()
                ' Expensive initialization
                Thread.Sleep(1000)
                InitializeExpensiveResources()
            End Sub
            
            Public Shared ReadOnly Property Instance() As BadSingletonEagerInit
                Get
                    Return _instance
                End Get
            End Property
            
            Private Sub InitializeExpensiveResources()
                ' Expensive initialization logic
            End Sub
        End Class
        
        ' BAD: Singleton with mutable state without synchronization
        Class BadSingletonMutableState
            Private Shared _instance As BadSingletonMutableState
            Public Property Counter As Integer
            
            Private Sub New()
                Counter = 0
            End Sub
            
            Public Shared Function GetInstance() As BadSingletonMutableState
                If _instance Is Nothing Then
                    _instance = New BadSingletonMutableState()
                End If
                Return _instance
            End Function
            
            ' BAD: Mutable operations without synchronization
            Public Sub IncrementCounter()
                Counter += 1
            End Sub
            
            Public Sub DecrementCounter()
                Counter -= 1
            End Sub
        End Class
        
        ' GOOD: Thread-safe singleton implementations
        
        ' GOOD: Thread-safe singleton with double-checked locking
        Class GoodSingletonDoubleCheck
            Private Shared _instance As GoodSingletonDoubleCheck
            Private Shared ReadOnly lockObject As New Object()
            
            Private Sub New()
            End Sub
            
            Public Shared Function GetInstance() As GoodSingletonDoubleCheck
                ' GOOD: Double-checked locking pattern
                If _instance Is Nothing Then
                    SyncLock lockObject
                        If _instance Is Nothing Then
                            _instance = New GoodSingletonDoubleCheck()
                        End If
                    End SyncLock
                End If
                Return _instance
            End Function
        End Class
        
        ' GOOD: Thread-safe singleton using Lazy(Of T)
        Class GoodSingletonLazy
            Private Shared ReadOnly _lazy As New Lazy(Of GoodSingletonLazy)(Function() New GoodSingletonLazy())
            
            Private Sub New()
            End Sub
            
            Public Shared ReadOnly Property Instance() As GoodSingletonLazy
                Get
                    Return _lazy.Value
                End Get
            End Property
        End Class
        
        ' GOOD: Thread-safe singleton with static constructor
        Class GoodSingletonStatic
            Private Shared ReadOnly _instance As New GoodSingletonStatic()
            
            ' GOOD: Static constructor ensures thread safety
            Shared Sub New()
                ' Static constructor is called only once
            End Sub
            
            Private Sub New()
            End Sub
            
            Public Shared ReadOnly Property Instance() As GoodSingletonStatic
                Get
                    Return _instance
                End Get
            End Property
        End Class
        
        ' GOOD: Thread-safe singleton with concurrent collections
        Class GoodSingletonConcurrent
            Private Shared ReadOnly _instances As New ConcurrentDictionary(Of Type, Object)()
            
            Private Sub New()
            End Sub
            
            Public Shared Function GetInstance(Of T As {New, Class})() As T
                Return CType(_instances.GetOrAdd(GetType(T), Function(type) Activator.CreateInstance(type)), T)
            End Function
        End Class
        
        ' GOOD: Singleton with proper volatile field
        Class GoodSingletonVolatile
            Private Shared Volatile _instance As GoodSingletonVolatile
            Private Shared ReadOnly lockObject As New Object()
            
            Private Sub New()
            End Sub
            
            Public Shared Function GetInstance() As GoodSingletonVolatile
                If _instance Is Nothing Then
                    SyncLock lockObject
                        If _instance Is Nothing Then
                            _instance = New GoodSingletonVolatile()
                        End If
                    End SyncLock
                End If
                Return _instance
            End Function
        End Class
        
        ' GOOD: Singleton with Interlocked operations
        Class GoodSingletonInterlocked
            Private Shared _instance As GoodSingletonInterlocked
            Private Shared _initialized As Integer = 0
            
            Private Sub New()
            End Sub
            
            Public Shared Function GetInstance() As GoodSingletonInterlocked
                If Interlocked.CompareExchange(_initialized, 1, 0) = 0 Then
                    _instance = New GoodSingletonInterlocked()
                End If
                Return _instance
            End Function
        End Class
        
        ' GOOD: Generic singleton base class
        MustInherit Class GoodSingletonBase(Of T As {New, Class})
            Private Shared ReadOnly _lazy As New Lazy(Of T)(Function() Activator.CreateInstance(Of T)())
            
            Public Shared ReadOnly Property Instance() As T
                Get
                    Return _lazy.Value
                End Get
            End Property
        End Class
        
        ' GOOD: Implementation using the base class
        Class GoodSpecificSingleton
            Inherits GoodSingletonBase(Of GoodSpecificSingleton)
            
            Private Sub New()
                ' Private constructor
            End Sub
            
            Public Sub DoWork()
                ' Singleton-specific functionality
            End Sub
        End Class
        
        ' GOOD: Singleton with proper disposal
        Class GoodDisposableSingleton
            Implements IDisposable
            
            Private Shared ReadOnly _lazy As New Lazy(Of GoodDisposableSingleton)(Function() New GoodDisposableSingleton())
            Private _disposed As Boolean = False
            
            Private Sub New()
            End Sub
            
            Public Shared ReadOnly Property Instance() As GoodDisposableSingleton
                Get
                    Return _lazy.Value
                End Get
            End Property
            
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                GC.SuppressFinalize(Me)
            End Sub
            
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not _disposed Then
                    If disposing Then
                        ' Dispose managed resources
                    End If
                    _disposed = True
                End If
            End Sub
        End Class
        
        ' GOOD: Thread-safe singleton with initialization data
        Class GoodParameterizedSingleton
            Private Shared _instance As GoodParameterizedSingleton
            Private Shared ReadOnly lockObject As New Object()
            Private ReadOnly _configData As String
            
            Private Sub New(configData As String)
                _configData = configData
            End Sub
            
            Public Shared Function GetInstance(configData As String) As GoodParameterizedSingleton
                If _instance Is Nothing Then
                    SyncLock lockObject
                        If _instance Is Nothing Then
                            _instance = New GoodParameterizedSingleton(configData)
                        End If
                    End SyncLock
                End If
                Return _instance
            End Function
            
            Public ReadOnly Property ConfigData() As String
                Get
                    Return _configData
                End Get
            End Property
        End Class
        
        ' Supporting classes for examples
        Class Thread
            Public Shared Sub Sleep(milliseconds As Integer)
                ' Simulate thread sleep
            End Sub
        End Class
        
        Class ConcurrentDictionary(Of TKey, TValue)
            Public Function GetOrAdd(key As TKey, valueFactory As Func(Of TKey, TValue)) As TValue
                Return valueFactory(key)
            End Function
        End Class
        
        Class Activator
            Public Shared Function CreateInstance(type As Type) As Object
                Return Nothing
            End Function
            
            Public Shared Function CreateInstance(Of T As New)() As T
                Return New T()
            End Function
        End Class
        
        Class Interlocked
            Public Shared Function CompareExchange(ByRef location1 As Integer, value As Integer, comparand As Integer) As Integer
                Return 0
            End Function
        End Class
        
        Class GC
            Public Shared Sub SuppressFinalize(obj As Object)
            End Sub
        End Class
    </script>
</body>
</html>

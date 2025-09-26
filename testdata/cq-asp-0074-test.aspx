<%@ Page Language="VB" %>
<html>
<head>
    <title>Improper IDisposable Implementation Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Improper IDisposable implementation - incorrect implementation of IDisposable pattern
        
        ' BAD: Class implements IDisposable but missing proper Dispose implementation
        Class BadDisposableWithoutProperDispose
            Implements IDisposable
            
            Private resource As FileStream
            
            Public Sub New()
                resource = New FileStream("test.txt", FileMode.Create)
            End Sub
            
            ' BAD: Dispose method without proper implementation
            Public Sub Dispose() Implements IDisposable.Dispose
                ' Missing GC.SuppressFinalize and disposed flag
                resource.Close()
            End Sub
        End Class
        
        ' BAD: Class inherits from IDisposable but missing virtual Dispose
        Class BadDisposableWithoutVirtualDispose : IDisposable
            Private stream As MemoryStream
            
            Public Sub New()
                stream = New MemoryStream()
            End Sub
            
            ' BAD: Missing protected virtual dispose method
            Public Sub Dispose() Implements IDisposable.Dispose
                stream.Dispose()
            End Sub
        End Class
        
        ' BAD: IDisposable implementation without finalizer when needed
        Class BadDisposableWithoutFinalizer
            Implements IDisposable
            
            Private unmanagedResource As IntPtr
            Private managedResource As FileStream
            
            ' BAD: Has unmanaged resources but no finalizer
            Public Sub Dispose() Implements IDisposable.Dispose
                managedResource.Dispose()
                ' Missing finalizer for unmanaged resource
            End Sub
        End Class
        
        ' BAD: Dispose method missing GC.SuppressFinalize
        Class BadDisposableWithoutSuppressFinalize
            Implements IDisposable
            
            Private disposed As Boolean = False
            Private resource As StreamReader
            
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        resource.Dispose()
                    End If
                    disposed = True
                End If
            End Sub
            
            ' BAD: Missing GC.SuppressFinalize call
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                ' Missing: GC.SuppressFinalize(Me)
            End Sub
        End Class
        
        ' BAD: Dispose method missing disposed flag
        Class BadDisposableWithoutDisposedFlag
            Implements IDisposable
            
            Private resource As BinaryWriter
            
            ' BAD: Missing disposed flag to prevent multiple disposal
            Public Sub Dispose() Implements IDisposable.Dispose
                resource.Dispose()
                GC.SuppressFinalize(Me)
                ' Missing disposed = True
            End Sub
        End Class
        
        ' BAD: C# style improper implementation
        class BadCSharpStyleDisposable : IDisposable {
            private FileStream file;
            
            // BAD: Missing protected virtual Dispose method
            public void Dispose() {
                file.Dispose();
                // Missing GC.SuppressFinalize and virtual dispose
            }
        }
        
        class BadCSharpWithoutFinalizer : IDisposable {
            private IntPtr unmanagedHandle;
            
            // BAD: Has unmanaged resource but no finalizer
            public void Dispose() {
                ReleaseHandle(unmanagedHandle);
                GC.SuppressFinalize(this);
            }
        }
        
        ' BAD: Incomplete dispose pattern
        Class BadIncompleteDisposePattern
            Implements IDisposable
            
            Private file As FileStream
            Private buffer As Byte()
            
            ' BAD: Dispose method doesn't follow standard pattern
            Sub Dispose() Implements IDisposable.Dispose
                file.Close() ' Should use Dispose()
                buffer = Nothing ' Unnecessary for managed resources
                ' Missing GC.SuppressFinalize
            End Sub
        End Class
        
        ' BAD: Missing override in derived disposable class
        Class BadDerivedDisposableWithoutOverride
            Inherits BadDisposableWithoutProperDispose
            
            Private additionalResource As StreamWriter
            
            ' BAD: Should override Dispose(Boolean) but doesn't
            Public Sub New()
                MyBase.New()
                additionalResource = New StreamWriter("additional.txt")
            End Sub
        End Class
        
        ' GOOD: Proper IDisposable implementations
        
        ' GOOD: Complete IDisposable implementation
        Class GoodDisposableImplementation
            Implements IDisposable
            
            Private disposed As Boolean = False
            Private managedResource As FileStream
            Private anotherResource As StreamReader
            
            Public Sub New()
                managedResource = New FileStream("good.txt", FileMode.Create)
                anotherResource = New StreamReader("input.txt")
            End Sub
            
            ' GOOD: Protected virtual dispose method
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        ' Dispose managed resources
                        If managedResource IsNot Nothing Then
                            managedResource.Dispose()
                        End If
                        If anotherResource IsNot Nothing Then
                            anotherResource.Dispose()
                        End If
                    End If
                    
                    ' Free unmanaged resources here if any
                    disposed = True
                End If
            End Sub
            
            ' GOOD: Public dispose method with proper implementation
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                GC.SuppressFinalize(Me)
            End Sub
        End Class
        
        ' GOOD: IDisposable with finalizer for unmanaged resources
        Class GoodDisposableWithFinalizer
            Implements IDisposable
            
            Private disposed As Boolean = False
            Private unmanagedHandle As IntPtr
            Private managedResource As MemoryStream
            
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        ' Dispose managed resources
                        If managedResource IsNot Nothing Then
                            managedResource.Dispose()
                        End If
                    End If
                    
                    ' Free unmanaged resources
                    If unmanagedHandle <> IntPtr.Zero Then
                        ReleaseHandle(unmanagedHandle)
                        unmanagedHandle = IntPtr.Zero
                    End If
                    
                    disposed = True
                End If
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                GC.SuppressFinalize(Me)
            End Sub
            
            ' GOOD: Finalizer for unmanaged resources
            Protected Overrides Sub Finalize()
                Dispose(False)
                MyBase.Finalize()
            End Sub
        End Class
        
        ' GOOD: C# style proper implementation
        class GoodCSharpDisposable : IDisposable {
            private bool disposed = false;
            private FileStream fileResource;
            
            protected virtual void Dispose(bool disposing) {
                if (!disposed) {
                    if (disposing) {
                        fileResource?.Dispose();
                    }
                    disposed = true;
                }
            }
            
            public void Dispose() {
                Dispose(true);
                GC.SuppressFinalize(this);
            }
        }
        
        ' GOOD: Derived class with proper dispose override
        Class GoodDerivedDisposable
            Inherits GoodDisposableImplementation
            
            Private derivedResource As BinaryWriter
            Private derivedDisposed As Boolean = False
            
            Public Sub New()
                MyBase.New()
                derivedResource = New BinaryWriter(New MemoryStream())
            End Sub
            
            ' GOOD: Proper override of dispose method
            Protected Overrides Sub Dispose(disposing As Boolean)
                If Not derivedDisposed Then
                    If disposing Then
                        If derivedResource IsNot Nothing Then
                            derivedResource.Dispose()
                        End If
                    End If
                    derivedDisposed = True
                End If
                
                ' Call base class dispose
                MyBase.Dispose(disposing)
            End Sub
        End Class
        
        ' GOOD: Simple disposable with minimal resources
        Class GoodSimpleDisposable
            Implements IDisposable
            
            Private disposed As Boolean = False
            Private resource As StreamWriter
            
            Protected Overridable Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        resource?.Dispose()
                    End If
                    disposed = True
                End If
            End Sub
            
            Public Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                GC.SuppressFinalize(Me)
            End Sub
        End Class
        
        ' GOOD: Using statement ensures proper disposal
        Sub GoodUsingStatement()
            Using resource As New FileStream("temp.txt", FileMode.Create)
                ' Resource will be properly disposed automatically
                resource.WriteByte(65)
            End Using
        End Sub
        
        ' GOOD: Try-finally ensures disposal
        Sub GoodTryFinallyDisposal()
            Dim resource As FileStream = Nothing
            Try
                resource = New FileStream("temp.txt", FileMode.Create)
                resource.WriteByte(65)
            Finally
                If resource IsNot Nothing Then
                    resource.Dispose()
                End If
            End Try
        End Sub
        
        ' Helper methods
        Sub ReleaseHandle(handle As IntPtr)
            ' Simulate releasing unmanaged handle
        End Sub
    </script>
</body>
</html>

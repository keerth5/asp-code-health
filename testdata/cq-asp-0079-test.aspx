<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Base Class Calls Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing base class calls - overridden methods not calling base class implementations when required
        
        ' Base class with virtual methods that should be called by derived classes
        Class BaseClass
            Protected disposed As Boolean = False
            
            Public Overridable Sub Dispose()
                disposed = True
                ' Base cleanup logic
            End Sub
            
            Protected Overridable Sub Finalize()
                Dispose()
                MyBase.Finalize()
            End Sub
            
            Public Overridable Function ToString() As String
                Return "BaseClass"
            End Function
            
            Public Overridable Function Equals(obj As Object) As Boolean
                Return MyBase.Equals(obj)
            End Function
            
            Public Overridable Function GetHashCode() As Integer
                Return MyBase.GetHashCode()
            End Function
            
            Public Overridable Sub Initialize()
                ' Base initialization
            End Sub
        End Class
        
        ' BAD: Derived class not calling base methods
        Class BadDerivedClass
            Inherits BaseClass
            
            Private additionalResource As String
            
            ' BAD: Dispose override without calling base
            Public Overrides Sub Dispose()
                ' Missing MyBase.Dispose() call
                additionalResource = Nothing
            End Sub
            
            ' BAD: Finalize override without calling base
            Protected Overrides Sub Finalize()
                ' Missing MyBase.Finalize() call
                Dispose()
            End Sub
            
            ' BAD: ToString override without calling base when appropriate
            Public Overrides Function ToString() As String
                ' Missing MyBase.ToString() call - might want to include base info
                Return "BadDerivedClass"
            End Function
            
            ' BAD: Equals override without calling base
            Public Overrides Function Equals(obj As Object) As Boolean
                ' Missing MyBase.Equals(obj) call
                Return TypeOf obj Is BadDerivedClass
            End Function
            
            ' BAD: GetHashCode override without considering base
            Public Overrides Function GetHashCode() As Integer
                ' Missing MyBase.GetHashCode() consideration
                Return additionalResource.GetHashCode()
            End Function
            
            ' BAD: Initialize override without calling base
            Public Overrides Sub Initialize()
                ' Missing MyBase.Initialize() call
                additionalResource = "Initialized"
            End Sub
        End Class
        
        ' BAD: Constructor not calling base constructor when needed
        Class BadConstructorCalls
            Inherits BaseClass
            
            Private data As String
            
            ' BAD: Constructor without explicit base call when base has important logic
            Public Sub New(value As String)
                ' Missing MyBase.New() or MyClass.New() call
                data = value
            End Sub
            
            ' BAD: Parameterized constructor not calling base
            Public Sub New(value As String, flag As Boolean)
                ' Missing explicit base constructor call
                data = value
                If flag Then
                    Initialize()
                End If
            End Sub
        End Class
        
        ' BAD: IDisposable implementation without base calls
        Class BadDisposableImplementation
            Inherits BaseClass
            Implements IDisposable
            
            Private managedResource As FileStream
            
            ' BAD: Dispose implementation without calling base
            Public Overrides Sub Dispose() Implements IDisposable.Dispose
                ' Missing MyBase.Dispose() call
                If managedResource IsNot Nothing Then
                    managedResource.Dispose()
                    managedResource = Nothing
                End If
            End Sub
            
            ' BAD: Protected Dispose without base call
            Protected Overloads Sub Dispose(disposing As Boolean)
                ' Missing MyBase.Dispose() call
                If disposing Then
                    managedResource?.Dispose()
                End If
            End Sub
        End Class
        
        ' BAD: Event handler overrides without base calls
        Class BadEventHandlerOverrides
            Inherits System.Windows.Forms.Control
            
            ' BAD: OnPaint override without calling base
            Protected Overrides Sub OnPaint(e As PaintEventArgs)
                ' Missing MyBase.OnPaint(e) call
                ' Custom paint logic only
                e.Graphics.DrawString("Custom", SystemFonts.DefaultFont, Brushes.Black, 0, 0)
            End Sub
            
            ' BAD: OnLoad override without calling base
            Protected Overrides Sub OnLoad(e As EventArgs)
                ' Missing MyBase.OnLoad(e) call
                ' Custom load logic only
                InitializeCustomComponents()
            End Sub
        End Class
        
        ' BAD: C# style missing base calls
        class BadCSharpDerived : BaseClass {
            // BAD: Override without calling base
            public override void Dispose() {
                // Missing base.Dispose() call
                CleanupDerived();
            }
            
            // BAD: ToString without base call when appropriate
            public override string ToString() {
                // Missing base.ToString() call
                return "BadCSharpDerived";
            }
        }
        
        ' GOOD: Proper base class calls
        
        Class GoodDerivedClass
            Inherits BaseClass
            
            Private additionalResource As String
            
            ' GOOD: Dispose override with base call
            Public Overrides Sub Dispose()
                additionalResource = Nothing
                MyBase.Dispose() ' Proper base call
            End Sub
            
            ' GOOD: Finalize override with base call
            Protected Overrides Sub Finalize()
                Try
                    Dispose()
                Finally
                    MyBase.Finalize() ' Proper base call
                End Try
            End Sub
            
            ' GOOD: ToString override incorporating base
            Public Overrides Function ToString() As String
                Dim baseString As String = MyBase.ToString()
                Return $"{baseString} -> GoodDerivedClass"
            End Function
            
            ' GOOD: Equals override with base call
            Public Overrides Function Equals(obj As Object) As Boolean
                If Not MyBase.Equals(obj) Then Return False ' Check base equality first
                Dim other As GoodDerivedClass = TryCast(obj, GoodDerivedClass)
                Return other IsNot Nothing AndAlso additionalResource = other.additionalResource
            End Function
            
            ' GOOD: GetHashCode override considering base
            Public Overrides Function GetHashCode() As Integer
                Dim baseHash As Integer = MyBase.GetHashCode()
                Return HashCode.Combine(baseHash, additionalResource)
            End Function
            
            ' GOOD: Initialize override with base call
            Public Overrides Sub Initialize()
                MyBase.Initialize() ' Call base initialization first
                additionalResource = "Derived Initialized"
            End Sub
        End Class
        
        Class GoodConstructorCalls
            Inherits BaseClass
            
            Private data As String
            
            ' GOOD: Constructor with explicit base call
            Public Sub New()
                MyBase.New() ' Explicit base constructor call
                data = "Default"
            End Sub
            
            ' GOOD: Parameterized constructor calling base
            Public Sub New(value As String)
                MyBase.New() ' Call base constructor
                data = value
                Initialize() ' Can call after base construction
            End Sub
            
            ' GOOD: Constructor chaining
            Public Sub New(value As String, flag As Boolean)
                MyClass.New(value) ' Call another constructor in same class
                If flag Then
                    data = data.ToUpper()
                End If
            End Sub
        End Class
        
        Class GoodDisposableImplementation
            Inherits BaseClass
            Implements IDisposable
            
            Private managedResource As FileStream
            Private disposed As Boolean = False
            
            ' GOOD: Dispose implementation with base call
            Public Overrides Sub Dispose() Implements IDisposable.Dispose
                Dispose(True)
                MyBase.Dispose() ' Proper base call
                GC.SuppressFinalize(Me)
            End Sub
            
            ' GOOD: Protected Dispose with base consideration
            Protected Overloads Sub Dispose(disposing As Boolean)
                If Not disposed Then
                    If disposing Then
                        managedResource?.Dispose()
                    End If
                    disposed = True
                End If
                ' Note: MyBase.Dispose() called in public Dispose method
            End Sub
        End Class
        
        Class GoodEventHandlerOverrides
            Inherits System.Windows.Forms.Control
            
            ' GOOD: OnPaint override with base call
            Protected Overrides Sub OnPaint(e As PaintEventArgs)
                MyBase.OnPaint(e) ' Call base painting first
                ' Then add custom painting
                e.Graphics.DrawString("Custom", SystemFonts.DefaultFont, Brushes.Black, 0, 0)
            End Sub
            
            ' GOOD: OnLoad override with base call
            Protected Overrides Sub OnLoad(e As EventArgs)
                MyBase.OnLoad(e) ' Call base load logic first
                InitializeCustomComponents()
            End Sub
            
            ' GOOD: Conditional base call based on logic
            Protected Overrides Sub OnResize(e As EventArgs)
                If ShouldCallBaseResize() Then
                    MyBase.OnResize(e) ' Conditional but present base call
                End If
                HandleCustomResize()
            End Sub
        End Class
        
        ' GOOD: C# style proper base calls
        class GoodCSharpDerived : BaseClass {
            // GOOD: Override with proper base call
            public override void Dispose() {
                CleanupDerived();
                base.Dispose(); // Proper base call
            }
            
            // GOOD: ToString with base incorporation
            public override string ToString() {
                string baseString = base.ToString();
                return $"{baseString} -> GoodCSharpDerived";
            }
        }
        
        ' GOOD: Abstract base class implementation
        MustInherit Class AbstractBase
            Public MustOverride Sub AbstractMethod()
            
            Public Overridable Sub VirtualMethod()
                ' Base implementation
            End Sub
            
            Protected Overridable Sub ProtectedVirtual()
                ' Base implementation that derived classes should call
            End Sub
        End Class
        
        Class GoodAbstractImplementation
            Inherits AbstractBase
            
            ' GOOD: Abstract method implementation (no base call needed)
            Public Overrides Sub AbstractMethod()
                ' Implementation required, no base to call
                PerformAbstractLogic()
            End Sub
            
            ' GOOD: Virtual method override with base call
            Public Overrides Sub VirtualMethod()
                MyBase.VirtualMethod() ' Call base implementation
                PerformAdditionalLogic()
            End Sub
            
            ' GOOD: Protected virtual override with base call
            Protected Overrides Sub ProtectedVirtual()
                MyBase.ProtectedVirtual() ' Call base implementation
                PerformProtectedLogic()
            End Sub
        End Class
        
        ' GOOD: Template method pattern with proper base calls
        Class GoodTemplateImplementation
            Inherits AbstractBase
            
            Public Overrides Sub AbstractMethod()
                PreProcess()
                PerformCoreLogic()
                PostProcess()
            End Sub
            
            Public Overrides Sub VirtualMethod()
                ' Sometimes base call at beginning
                MyBase.VirtualMethod()
                CustomProcessing()
            End Sub
            
            Private Sub PreProcess()
                ' Derived-specific pre-processing
            End Sub
            
            Private Sub PerformCoreLogic()
                ' Core logic implementation
            End Sub
            
            Private Sub PostProcess()
                ' Derived-specific post-processing
            End Sub
            
            Private Sub CustomProcessing()
                ' Additional custom processing
            End Sub
        End Class
        
        ' Helper methods
        Sub CleanupDerived()
        End Sub
        
        Sub InitializeCustomComponents()
        End Sub
        
        Sub HandleCustomResize()
        End Sub
        
        Sub PerformAbstractLogic()
        End Sub
        
        Sub PerformAdditionalLogic()
        End Sub
        
        Sub PerformProtectedLogic()
        End Sub
        
        Function ShouldCallBaseResize() As Boolean
            Return True
        End Function
    </script>
</body>
</html>

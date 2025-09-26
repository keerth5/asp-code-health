<%@ Page Language="VB" %>
<html>
<head>
    <title>Missing Override Keywords Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Missing override keywords - virtual methods not properly marked with override keyword
        
        ' Base class with virtual methods
        Class BaseClass
            Public Overridable Function ToString() As String
                Return "BaseClass"
            End Function
            
            Public Overridable Function Equals(obj As Object) As Boolean
                Return MyBase.Equals(obj)
            End Function
            
            Public Overridable Function GetHashCode() As Integer
                Return MyBase.GetHashCode()
            End Function
            
            Protected Overridable Sub Finalize()
                MyBase.Finalize()
            End Sub
            
            Public Overridable Sub DoWork()
                ' Base implementation
            End Sub
        End Class
        
        ' BAD: Derived class missing override keywords
        Class BadDerivedClass
            Inherits BaseClass
            
            ' BAD: Missing Overrides keyword for ToString
            Public Function ToString() As String
                Return "BadDerivedClass"
            End Function
            
            ' BAD: Missing Overrides keyword for Equals
            Public Function Equals(obj As Object) As Boolean
                Return obj IsNot Nothing
            End Function
            
            ' BAD: Missing Overrides keyword for GetHashCode
            Public Function GetHashCode() As Integer
                Return 42
            End Function
            
            ' BAD: Missing Overrides keyword for Finalize
            Protected Sub Finalize()
                ' Cleanup
            End Sub
            
            ' BAD: Missing Overrides keyword for custom virtual method
            Public Sub DoWork()
                ' Derived implementation
            End Sub
        End Class
        
        ' BAD: C# style missing override keywords
        class BadCSharpDerived : BaseClass {
            // BAD: Missing override keyword
            public string ToString() {
                return "BadCSharpDerived";
            }
            
            // BAD: Missing override keyword
            public bool Equals(object obj) {
                return obj != null;
            }
            
            // BAD: Missing override keyword
            public int GetHashCode() {
                return 123;
            }
        }
        
        ' BAD: Another inheritance scenario
        Class AnotherBase
            Public Overridable Function Calculate(value As Integer) As Integer
                Return value * 2
            End Function
            
            Public Overridable Sub ProcessData(data As String)
                ' Base processing
            End Sub
        End Class
        
        Class BadAnotherDerived
            Inherits AnotherBase
            
            ' BAD: Missing Overrides for virtual method
            Public Function Calculate(value As Integer) As Integer
                Return value * 3
            End Function
            
            ' BAD: Missing Overrides for virtual sub
            Public Sub ProcessData(data As String)
                ' Derived processing
            End Sub
        End Class
        
        ' BAD: Complex inheritance chain
        Class MiddleClass
            Inherits BaseClass
            
            ' GOOD: Proper override
            Public Overrides Function ToString() As String
                Return "MiddleClass"
            End Function
            
            ' Add new virtual method
            Public Overridable Sub NewMethod()
                ' Middle class method
            End Sub
        End Class
        
        Class BadFinalDerived
            Inherits MiddleClass
            
            ' BAD: Missing Overrides for method from base
            Public Function Equals(obj As Object) As Boolean
                Return False
            End Function
            
            ' BAD: Missing Overrides for method from middle class
            Public Sub NewMethod()
                ' Final implementation
            End Sub
        End Class
        
        ' BAD: Interface implementation vs override confusion
        Interface IWorker
            Sub DoTask()
            Function GetResult() As String
        End Interface
        
        Class BadInterfaceImplementation
            Inherits BaseClass
            Implements IWorker
            
            ' BAD: This should override base method, not just implement interface
            Public Sub DoWork() Implements IWorker.DoTask
                ' Should use Overrides since base has DoWork
            End Sub
            
            ' GOOD: This is interface implementation (no base method)
            Public Function GetResult() As String Implements IWorker.GetResult
                Return "Result"
            End Function
        End Class
        
        ' GOOD: Proper override keyword usage
        
        Class GoodDerivedClass
            Inherits BaseClass
            
            ' GOOD: Proper Overrides keyword for ToString
            Public Overrides Function ToString() As String
                Return "GoodDerivedClass"
            End Function
            
            ' GOOD: Proper Overrides keyword for Equals
            Public Overrides Function Equals(obj As Object) As Boolean
                If obj Is Nothing Then Return False
                Return obj.GetType() = Me.GetType()
            End Function
            
            ' GOOD: Proper Overrides keyword for GetHashCode
            Public Overrides Function GetHashCode() As Integer
                Return MyBase.GetHashCode()
            End Function
            
            ' GOOD: Proper Overrides keyword for Finalize
            Protected Overrides Sub Finalize()
                Try
                    ' Cleanup code
                Finally
                    MyBase.Finalize()
                End Try
            End Sub
            
            ' GOOD: Proper Overrides keyword for custom virtual method
            Public Overrides Sub DoWork()
                MyBase.DoWork() ' Call base implementation
                ' Additional work
            End Sub
        End Class
        
        ' GOOD: C# style proper override keywords
        class GoodCSharpDerived : BaseClass {
            // GOOD: Proper override keyword
            public override string ToString() {
                return "GoodCSharpDerived";
            }
            
            // GOOD: Proper override keyword
            public override bool Equals(object obj) {
                return base.Equals(obj);
            }
            
            // GOOD: Proper override keyword
            public override int GetHashCode() {
                return base.GetHashCode();
            }
        }
        
        Class GoodAnotherDerived
            Inherits AnotherBase
            
            ' GOOD: Proper Overrides for virtual method
            Public Overrides Function Calculate(value As Integer) As Integer
                Return MyBase.Calculate(value) + 10
            End Function
            
            ' GOOD: Proper Overrides for virtual sub
            Public Overrides Sub ProcessData(data As String)
                MyBase.ProcessData(data)
                ' Additional processing
            End Sub
        End Class
        
        Class GoodFinalDerived
            Inherits MiddleClass
            
            ' GOOD: Proper Overrides for method from base
            Public Overrides Function Equals(obj As Object) As Boolean
                Return MyBase.Equals(obj)
            End Function
            
            ' GOOD: Proper Overrides for method from middle class
            Public Overrides Sub NewMethod()
                MyBase.NewMethod()
                ' Final implementation
            End Sub
        End Class
        
        ' GOOD: Proper interface implementation with base override
        Class GoodInterfaceImplementation
            Inherits BaseClass
            Implements IWorker
            
            ' GOOD: Proper override of base method that also implements interface
            Public Overrides Sub DoWork() Implements IWorker.DoTask
                MyBase.DoWork()
                ' Additional interface-specific work
            End Sub
            
            ' GOOD: Pure interface implementation (no base method)
            Public Function GetResult() As String Implements IWorker.GetResult
                Return "Good Result"
            End Function
        End Class
        
        ' GOOD: New methods don't need override
        Class GoodNewMethods
            Inherits BaseClass
            
            ' GOOD: New method (not overriding anything)
            Public Sub NewMethod()
                ' New functionality
            End Sub
            
            ' GOOD: New function (not overriding anything)
            Public Function NewFunction() As String
                Return "New"
            End Function
            
            ' GOOD: Still properly override base methods
            Public Overrides Function ToString() As String
                Return "GoodNewMethods"
            End Function
        End Class
        
        ' GOOD: Abstract base with proper overrides
        MustInherit Class AbstractBase
            Public MustOverride Sub AbstractMethod()
            Public Overridable Sub VirtualMethod()
                ' Base implementation
            End Sub
        End Class
        
        Class GoodAbstractDerived
            Inherits AbstractBase
            
            ' GOOD: Must implement abstract method (no override needed)
            Public Overrides Sub AbstractMethod()
                ' Implementation required
            End Sub
            
            ' GOOD: Optionally override virtual method
            Public Overrides Sub VirtualMethod()
                MyBase.VirtualMethod()
                ' Additional implementation
            End Sub
        End Class
        
        ' GOOD: Sealed/NotInheritable methods
        Class GoodSealedMethods
            Inherits BaseClass
            
            ' GOOD: Sealed override prevents further overriding
            Public NotOverridable Overrides Function ToString() As String
                Return "Sealed"
            End Function
            
            ' GOOD: Regular override
            Public Overrides Sub DoWork()
                ' Final implementation
            End Sub
        End Class
    </script>
</body>
</html>

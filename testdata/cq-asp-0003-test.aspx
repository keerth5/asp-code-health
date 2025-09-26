<%@ Page Language="VB" %>
<html>
<head>
    <title>Deep Inheritance Hierarchy Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Deep inheritance hierarchy (VB.NET style)
        Public Class BaseClass
        End Class
        
        Public Class Level1 
            Inherits BaseClass
        End Class
        
        Public Class Level2
            Inherits Level1
        End Class
        
        Public Class Level3
            Inherits Level2
        End Class
        
        Public Class Level4
            Inherits Level3
        End Class
        
        Public Class BadDeepClass
            Inherits Level4
        End Class
        
        ' BAD: C# style deep inheritance (multiple interfaces)
        Public Class BadCSharpStyle
            Inherits BaseClass
            Implements IDisposable, IComparable, ICloneable, IFormattable, IConvertible
            
            Public Sub Dispose() Implements IDisposable.Dispose
            End Sub
            
            Public Function CompareTo(obj As Object) As Integer Implements IComparable.CompareTo
                Return 0
            End Function
            
            Public Function Clone() As Object Implements ICloneable.Clone
                Return Nothing
            End Function
            
            Public Function ToString(format As String, formatProvider As IFormatProvider) As String Implements IFormattable.ToString
                Return ""
            End Function
            
            Public Function ToType(conversionType As Type, provider As IFormatProvider) As Object Implements IConvertible.ToType
                Return Nothing
            End Function
        End Class
        
        ' GOOD: Shallow inheritance hierarchy
        Public Class GoodBaseClass
        End Class
        
        Public Class GoodDerivedClass
            Inherits GoodBaseClass
        End Class
        
        Public Class GoodFinalClass
            Inherits GoodDerivedClass
        End Class
    </script>
</body>
</html>

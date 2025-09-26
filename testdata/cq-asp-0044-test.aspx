<%@ Page Language="VB" %>
<html>
<head>
    <title>Inefficient String Operations Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inefficient string operations - concatenation without StringBuilder
        
        Sub BadStringConcatenation()
            ' BAD: String concatenation with += operator
            Dim result As String = ""
            result += "First part" ' Bad: creates new string object
            result += "Second part" ' Bad: creates new string object
            result += "Third part" ' Bad: creates new string object
            result += "Fourth part" ' Bad: creates new string object
            
            ' BAD: More string concatenation patterns
            Dim message As String = ""
            message += "Error: " ' Bad: string concatenation
            message += "Invalid input" ' Bad: string concatenation
            message += " at line " ' Bad: string concatenation
            message += lineNumber.ToString() ' Bad: string concatenation
        End Sub
        
        Sub BadStringConcatenationInLoops()
            ' BAD: String concatenation inside loops
            Dim html As String = ""
            
            For i = 1 To 100
                html += "<tr>" ' Bad: string concatenation in loop
                html += "<td>" & i.ToString() & "</td>" ' Bad: string concatenation in loop
                html += "</tr>" ' Bad: string concatenation in loop
            Next
            
            Dim csv As String = ""
            For Each item In items
                csv += item.Name ' Bad: string concatenation in loop
                csv += "," ' Bad: string concatenation in loop
                csv += item.Value.ToString() ' Bad: string concatenation in loop
                csv += vbCrLf ' Bad: string concatenation in loop
            Next
            
            Dim log As String = ""
            While hasMoreEntries
                log += DateTime.Now.ToString() ' Bad: string concatenation in loop
                log += ": " ' Bad: string concatenation in loop
                log += GetLogEntry() ' Bad: string concatenation in loop
                log += vbCrLf ' Bad: string concatenation in loop
            End While
        End Sub
        
        Function BadMultipleStringConcatenation() As String
            ' BAD: Multiple string concatenation without StringBuilder
            Dim part1 = "Start"
            Dim part2 = "Middle"
            Dim part3 = "End"
            
            ' Bad: Multiple concatenations create multiple temporary objects
            Dim result = part1 + " - " + part2 + " - " + part3 ' Bad: multiple concatenations
            Dim another = "A" + "B" + "C" + "D" + "E" ' Bad: multiple concatenations
            Dim complex = firstName + " " + lastName + " (" + email + ")" ' Bad: multiple concatenations
            
            Return result
        End Function
        
        Sub BadStringBuilding()
            ' BAD: Building strings inefficiently
            Dim query As String = ""
            query += "SELECT * FROM Users " ' Bad: string concatenation
            query += "WHERE Age > 18 " ' Bad: string concatenation
            query += "AND Status = 'Active' " ' Bad: string concatenation
            query += "ORDER BY Name" ' Bad: string concatenation
            
            Dim xml As String = ""
            xml += "<?xml version='1.0'?>" ' Bad: string concatenation
            xml += "<root>" ' Bad: string concatenation
            xml += "<data>" ' Bad: string concatenation
            xml += content ' Bad: string concatenation
            xml += "</data>" ' Bad: string concatenation
            xml += "</root>" ' Bad: string concatenation
        End Sub
        
        Sub BadRepeatedConcatenation()
            ' BAD: Repeated string concatenation
            Dim path As String = ""
            path += baseDirectory ' Bad: string concatenation
            path += "\" ' Bad: string concatenation
            path += subfolder ' Bad: string concatenation
            path += "\" ' Bad: string concatenation
            path += filename ' Bad: string concatenation
            path += ".txt" ' Bad: string concatenation
        End Sub
        
        ' GOOD: Efficient string operations using StringBuilder
        
        Sub GoodStringBuilderUsage()
            ' GOOD: Using StringBuilder for multiple concatenations
            Dim sb As New StringBuilder()
            sb.Append("First part") ' Efficient
            sb.Append("Second part") ' Efficient
            sb.Append("Third part") ' Efficient
            sb.Append("Fourth part") ' Efficient
            
            Dim result = sb.ToString()
            
            ' GOOD: StringBuilder for message building
            Dim messageSb As New StringBuilder()
            messageSb.Append("Error: ")
            messageSb.Append("Invalid input")
            messageSb.Append(" at line ")
            messageSb.Append(lineNumber.ToString())
            
            Dim message = messageSb.ToString()
        End Sub
        
        Sub GoodStringBuilderInLoops()
            ' GOOD: Using StringBuilder in loops
            Dim htmlSb As New StringBuilder(1000) ' Pre-allocate capacity
            
            For i = 1 To 100
                htmlSb.Append("<tr>")
                htmlSb.Append("<td>")
                htmlSb.Append(i.ToString())
                htmlSb.Append("</td>")
                htmlSb.Append("</tr>")
            Next
            
            Dim html = htmlSb.ToString()
            
            ' GOOD: StringBuilder for CSV generation
            Dim csvSb As New StringBuilder()
            For Each item In items
                csvSb.Append(item.Name)
                csvSb.Append(",")
                csvSb.Append(item.Value.ToString())
                csvSb.AppendLine()
            Next
            
            Dim csv = csvSb.ToString()
        End Sub
        
        Function GoodStringFormatting() As String
            ' GOOD: Using String.Format instead of concatenation
            Dim part1 = "Start"
            Dim part2 = "Middle"
            Dim part3 = "End"
            
            ' Good: Single String.Format call
            Dim result = String.Format("{0} - {1} - {2}", part1, part2, part3)
            Dim complex = String.Format("{0} {1} ({2})", firstName, lastName, email)
            
            Return result
        End Function
        
        Sub GoodStringInterpolation()
            ' GOOD: Using string interpolation (VB.NET 14+)
            Dim message = $"Error: Invalid input at line {lineNumber}"
            Dim path = $"{baseDirectory}\{subfolder}\{filename}.txt"
            Dim userInfo = $"{firstName} {lastName} ({email})"
        End Sub
        
        Sub GoodQueryBuilding()
            ' GOOD: Using StringBuilder for complex query building
            Dim querySb As New StringBuilder()
            querySb.Append("SELECT * FROM Users ")
            querySb.Append("WHERE Age > 18 ")
            querySb.Append("AND Status = 'Active' ")
            querySb.Append("ORDER BY Name")
            
            Dim query = querySb.ToString()
            
            ' GOOD: Using String.Format for parameterized queries
            Dim parameterizedQuery = String.Format("SELECT * FROM Users WHERE Age > {0} AND Status = '{1}'", minAge, status)
        End Sub
        
        Sub GoodXmlBuilding()
            ' GOOD: Using StringBuilder for XML building
            Dim xmlSb As New StringBuilder()
            xmlSb.AppendLine("<?xml version='1.0'?>")
            xmlSb.AppendLine("<root>")
            xmlSb.AppendLine("<data>")
            xmlSb.AppendLine(content)
            xmlSb.AppendLine("</data>")
            xmlSb.AppendLine("</root>")
            
            Dim xml = xmlSb.ToString()
        End Sub
        
        Sub GoodStringJoin()
            ' GOOD: Using String.Join for array/list concatenation
            Dim parts() As String = {"Part1", "Part2", "Part3", "Part4"}
            Dim result = String.Join(" - ", parts) ' Efficient joining
            
            Dim names As New List(Of String) From {"John", "Jane", "Bob"}
            Dim nameList = String.Join(", ", names) ' Efficient joining
            
            Dim pathParts() As String = {baseDirectory, subfolder, filename & ".txt"}
            Dim fullPath = String.Join("\", pathParts) ' Efficient path building
        End Sub
        
        Sub GoodPreallocatedStringBuilder()
            ' GOOD: Pre-allocating StringBuilder capacity
            Dim expectedLength = items.Count * 50 ' Estimate final length
            Dim sb As New StringBuilder(expectedLength)
            
            For Each item In items
                sb.AppendFormat("Item: {0}, Value: {1}{2}", item.Name, item.Value, vbCrLf)
            Next
            
            Dim result = sb.ToString()
        End Sub
        
        Function GoodStringCaching() As String
            ' GOOD: Caching frequently used strings
            Static cachedResult As String = Nothing
            
            If cachedResult Is Nothing Then
                Dim sb As New StringBuilder()
                sb.Append("Expensive")
                sb.Append(" string")
                sb.Append(" operation")
                cachedResult = sb.ToString()
            End If
            
            Return cachedResult
        End Function
        
        Sub GoodStringComparison()
            ' GOOD: Efficient string comparison
            If String.Equals(str1, str2, StringComparison.OrdinalIgnoreCase) Then
                ' Efficient comparison
            End If
            
            ' GOOD: Using String.IsNullOrEmpty
            If String.IsNullOrEmpty(userInput) Then
                ' Efficient null/empty check
            End If
            
            ' GOOD: Using String.IsNullOrWhiteSpace
            If String.IsNullOrWhiteSpace(userInput) Then
                ' Efficient whitespace check
            End If
        End Sub
        
        ' Helper methods and fields
        Private lineNumber As Integer = 42
        Private items As New List(Of Item)()
        Private hasMoreEntries As Boolean = True
        Private content As String = "sample content"
        Private baseDirectory As String = "C:\Data"
        Private subfolder As String = "Files"
        Private filename As String = "document"
        Private firstName As String = "John"
        Private lastName As String = "Doe"
        Private email As String = "john.doe@example.com"
        Private minAge As Integer = 18
        Private status As String = "Active"
        Private str1 As String = "test"
        Private str2 As String = "TEST"
        Private userInput As String = "  "
        
        Function GetLogEntry() As String
            Return "Log entry"
        End Function
        
        ' Helper class
        Public Class Item
            Public Property Name As String
            Public Property Value As Integer
        End Class
    </script>
</body>
</html>

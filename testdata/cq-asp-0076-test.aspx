<%@ Page Language="VB" %>
<html>
<head>
    <title>Enum Usage Issues Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Enum usage issues - inappropriate enum operations or missing enum validation
        
        Enum Status
            Active = 1
            Inactive = 2
            Pending = 3
        End Enum
        
        Enum Priority
            Low = 1
            Medium = 2
            High = 4
            Critical = 8
        End Enum
        
        Sub BadEnumConversions()
            ' BAD: Direct integer conversion without validation
            Dim userInput As Integer = 999
            Dim status As Status = CInt(userInput) ' No validation
            ProcessStatus(status)
            
            ' BAD: Convert.ToInt32 without validation
            Dim value As String = "5"
            Dim priority As Priority = Convert.ToInt32(value) ' No validation
            ProcessPriority(priority)
            
            ' BAD: Cast without validation
            Dim rawValue As Integer = GetRawValue()
            Dim currentStatus As Status = CType(rawValue, Status) ' No validation
            UpdateStatus(currentStatus)
        End Sub
        
        Sub BadEnumAssignments()
            ' BAD: Direct numeric assignment without validation
            Dim status As Status = CType(99, Status) ' Invalid enum value
            ProcessStatus(status)
            
            ' BAD: Assignment from integer without checking
            Dim priorityValue As Integer = 16
            Dim priority As Priority = CType(priorityValue, Priority) ' Invalid value
            ProcessPriority(priority)
            
            ' BAD: Using invalid enum values
            Dim invalidStatus As Status = CType(0, Status) ' Not defined in enum
            HandleStatus(invalidStatus)
        End Sub
        
        ' BAD: Enum without Flags attribute but used as flags
        Enum BadFlagsEnum
            None = 0
            Read = 1
            Write = 2
            Execute = 4
            Delete = 8
            Full = 15
        End Enum
        
        Sub BadFlagsUsage()
            ' BAD: Using bitwise operations on non-flags enum
            Dim permissions As BadFlagsEnum = BadFlagsEnum.Read Or BadFlagsEnum.Write
            ProcessPermissions(permissions)
            
            ' BAD: Checking flags without Flags attribute
            If (permissions And BadFlagsEnum.Execute) = BadFlagsEnum.Execute Then
                ExecuteOperation()
            End If
        End Sub
        
        Sub BadEnumParsing()
            ' BAD: Parse without TryParse validation
            Dim input As String = "InvalidStatus"
            Dim status As Status = [Enum].Parse(GetType(Status), input) ' Can throw exception
            ProcessStatus(status)
            
            ' BAD: Direct conversion from string
            Dim statusText As String = GetStatusText()
            Dim currentStatus As Status = CInt(statusText) ' Can fail
            UpdateStatus(currentStatus)
        End Sub
        
        Sub BadEnumComparisons()
            ' BAD: Comparing enum to raw integer without validation
            Dim status As Status = GetCurrentStatus()
            If CInt(status) = 5 Then ' Invalid comparison to undefined value
                ProcessSpecialCase()
            End If
            
            ' BAD: Using undefined enum values in comparisons
            If status = CType(999, Status) Then ' Invalid enum value
                HandleError()
            End If
        End Sub
        
        ' BAD: C# style enum issues
        void BadCSharpEnumUsage() {
            // BAD: Direct cast without validation
            int value = 100;
            Status status = (Status)value; // No validation
            ProcessStatus(status);
            
            // BAD: Convert.ToInt32 without validation
            string input = "999";
            Priority priority = (Priority)Convert.ToInt32(input); // No validation
            ProcessPriority(priority);
        }
        
        ' GOOD: Proper enum usage with validation
        
        Sub GoodEnumValidation()
            ' GOOD: Using Enum.IsDefined for validation
            Dim userInput As Integer = 999
            If [Enum].IsDefined(GetType(Status), userInput) Then
                Dim status As Status = CType(userInput, Status)
                ProcessStatus(status)
            Else
                HandleInvalidStatus()
            End If
        End Sub
        
        Sub GoodEnumTryParse()
            ' GOOD: Using TryParse for safe conversion
            Dim input As String = "Active"
            Dim status As Status
            If [Enum].TryParse(input, status) Then
                ProcessStatus(status)
            Else
                HandleInvalidInput()
            End If
        End Sub
        
        Sub GoodEnumConversions()
            ' GOOD: Validate before conversion
            Dim value As String = "2"
            Dim intValue As Integer
            If Integer.TryParse(value, intValue) AndAlso [Enum].IsDefined(GetType(Priority), intValue) Then
                Dim priority As Priority = CType(intValue, Priority)
                ProcessPriority(priority)
            End If
        End Sub
        
        ' GOOD: Proper flags enum
        <Flags>
        Enum GoodPermissions
            None = 0
            Read = 1
            Write = 2
            Execute = 4
            Delete = 8
            ReadWrite = Read Or Write
            Full = Read Or Write Or Execute Or Delete
        End Enum
        
        Sub GoodFlagsUsage()
            ' GOOD: Proper flags enum with Flags attribute
            Dim permissions As GoodPermissions = GoodPermissions.Read Or GoodPermissions.Write
            
            ' GOOD: Proper flag checking
            If permissions.HasFlag(GoodPermissions.Read) Then
                PerformRead()
            End If
            
            ' GOOD: Bitwise operations on flags enum
            permissions = permissions Or GoodPermissions.Execute
            ProcessPermissions(permissions)
        End Sub
        
        Sub GoodEnumComparisons()
            ' GOOD: Compare enums to enum values
            Dim status As Status = GetCurrentStatus()
            If status = Status.Active Then
                ProcessActiveStatus()
            End If
            
            ' GOOD: Use defined enum values
            Select Case status
                Case Status.Active
                    ProcessActive()
                Case Status.Inactive
                    ProcessInactive()
                Case Status.Pending
                    ProcessPending()
                Case Else
                    HandleUnknownStatus()
            End Select
        End Sub
        
        Function GoodEnumValidationFunction(value As Integer) As Status?
            ' GOOD: Return nullable enum for invalid values
            If [Enum].IsDefined(GetType(Status), value) Then
                Return CType(value, Status)
            Else
                Return Nothing
            End If
        End Function
        
        Sub GoodEnumExtensionUsage()
            ' GOOD: Using extension methods for validation
            Dim input As String = "Medium"
            Dim priority As Priority?
            
            If TryParseEnum(input, priority) Then
                ProcessPriority(priority.Value)
            Else
                HandleInvalidPriority()
            End If
        End Sub
        
        ' GOOD: C# style proper enum usage
        void GoodCSharpEnumUsage() {
            // GOOD: Validate before casting
            int value = GetValue();
            if (Enum.IsDefined(typeof(Status), value)) {
                Status status = (Status)value;
                ProcessStatus(status);
            }
            
            // GOOD: Use TryParse
            string input = GetInput();
            if (Enum.TryParse<Priority>(input, out Priority priority)) {
                ProcessPriority(priority);
            }
        }
        
        Sub GoodEnumDefaults()
            ' GOOD: Use defined enum values as defaults
            Dim status As Status = Status.Pending ' Use defined default
            Dim priority As Priority = Priority.Medium ' Use defined default
            
            ProcessDefaults(status, priority)
        End Sub
        
        ' GOOD: Comprehensive enum validation
        Class GoodEnumValidator
            Public Shared Function IsValidStatus(value As Integer) As Boolean
                Return [Enum].IsDefined(GetType(Status), value)
            End Function
            
            Public Shared Function IsValidPriority(value As String) As Boolean
                Dim priority As Priority
                Return [Enum].TryParse(value, True, priority)
            End Function
            
            Public Shared Function GetValidStatuses() As Status()
                Return [Enum].GetValues(GetType(Status)).Cast(Of Status)().ToArray()
            End Function
        End Class
        
        ' Helper methods
        Sub ProcessStatus(status As Status)
        End Sub
        
        Sub ProcessPriority(priority As Priority)
        End Sub
        
        Sub UpdateStatus(status As Status)
        End Sub
        
        Sub HandleStatus(status As Status)
        End Sub
        
        Sub ProcessPermissions(permissions As Object)
        End Sub
        
        Sub ExecuteOperation()
        End Sub
        
        Sub ProcessSpecialCase()
        End Sub
        
        Sub HandleError()
        End Sub
        
        Sub HandleInvalidStatus()
        End Sub
        
        Sub HandleInvalidInput()
        End Sub
        
        Sub HandleInvalidPriority()
        End Sub
        
        Sub PerformRead()
        End Sub
        
        Sub ProcessActiveStatus()
        End Sub
        
        Sub ProcessActive()
        End Sub
        
        Sub ProcessInactive()
        End Sub
        
        Sub ProcessPending()
        End Sub
        
        Sub HandleUnknownStatus()
        End Sub
        
        Sub ProcessDefaults(status As Status, priority As Priority)
        End Sub
        
        Function GetRawValue() As Integer
            Return 1
        End Function
        
        Function GetCurrentStatus() As Status
            Return Status.Active
        End Function
        
        Function GetStatusText() As String
            Return "1"
        End Function
        
        Function GetValue() As Integer
            Return 2
        End Function
        
        Function GetInput() As String
            Return "High"
        End Function
        
        Function TryParseEnum(Of T)(input As String, ByRef result As T?) As Boolean
            Dim temp As T
            If [Enum].TryParse(input, temp) Then
                result = temp
                Return True
            Else
                result = Nothing
                Return False
            End If
        End Function
    </script>
</body>
</html>

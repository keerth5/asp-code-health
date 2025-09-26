<%@ Page Language="VB" %>
<html>
<head>
    <title>DateTime Handling Issues Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: DateTime handling issues - improper DateTime operations without timezone consideration
        
        Sub BadDateTimeNowUsage()
            ' BAD: Using DateTime.Now without timezone consideration
            Dim currentTime As DateTime = DateTime.Now ' No timezone handling
            LogActivity(currentTime)
            
            ' BAD: DateTime.Now in calculations without UTC
            Dim startTime As DateTime = DateTime.Now
            Dim endTime As DateTime = DateTime.Now.AddHours(2)
            Dim duration As TimeSpan = endTime - startTime
            ProcessDuration(duration)
            
            ' BAD: Storing DateTime.Now in database without timezone info
            Dim timestamp As DateTime = DateTime.Now
            SaveToDatabase(timestamp) ' Timezone ambiguity
        End Sub
        
        Sub BadDateTimeParsing()
            ' BAD: DateTime.Parse without culture info
            Dim dateString As String = "12/31/2023"
            Dim parsedDate As DateTime = DateTime.Parse(dateString) ' Culture-dependent
            ProcessDate(parsedDate)
            
            ' BAD: Parse without specifying format or culture
            Dim timeString As String = "2023-12-31 15:30:00"
            Dim parsedTime As DateTime = DateTime.Parse(timeString) ' Ambiguous parsing
            ScheduleEvent(parsedTime)
            
            ' BAD: ParseExact without culture consideration
            Dim customFormat As String = "dd/MM/yyyy"
            Dim dateInput As String = "31/12/2023"
            Dim exactDate As DateTime = DateTime.ParseExact(dateInput, customFormat, Nothing)
            ValidateDate(exactDate)
        End Sub
        
        Sub BadDateTimeArithmetic()
            ' BAD: AddDays without timezone consideration
            Dim baseDate As DateTime = GetBaseDate()
            Dim futureDate As DateTime = baseDate.AddDays(30) ' No timezone handling
            ScheduleFutureTask(futureDate)
            
            ' BAD: AddHours without timezone awareness
            Dim meetingTime As DateTime = GetMeetingTime()
            Dim reminderTime As DateTime = meetingTime.AddHours(-1) ' DST issues possible
            SetReminder(reminderTime)
            
            ' BAD: AddMinutes in scheduling without timezone
            Dim appointmentTime As DateTime = GetAppointmentTime()
            Dim bufferTime As DateTime = appointmentTime.AddMinutes(15) ' Timezone issues
            UpdateSchedule(bufferTime)
        End Sub
        
        Sub BadDateTimeComparisons()
            ' BAD: Comparing DateTime.Now with stored dates
            Dim storedDate As DateTime = GetStoredDate()
            If DateTime.Now > storedDate Then ' Timezone mismatch possible
                ProcessExpiredData()
            End If
            
            ' BAD: Date arithmetic with Now
            Dim createdDate As DateTime = GetCreatedDate()
            Dim age As TimeSpan = DateTime.Now - createdDate ' Timezone issues
            If age.TotalDays > 30 Then
                ArchiveData()
            End If
        End Sub
        
        Sub BadDateTimeFormatting()
            ' BAD: ToString without culture specification
            Dim currentDate As DateTime = DateTime.Now
            Dim formattedDate As String = currentDate.ToString("MM/dd/yyyy") ' Culture-dependent
            DisplayDate(formattedDate)
            
            ' BAD: Default ToString formatting
            Dim timestamp As DateTime = DateTime.Now
            Dim display As String = timestamp.ToString() ' Culture and timezone dependent
            LogTimestamp(display)
        End Sub
        
        ' BAD: DateTime in different contexts without timezone handling
        Sub BadDateTimeInWebContext()
            ' BAD: Using DateTime.Now for web applications
            Dim sessionStart As DateTime = DateTime.Now ' User timezone ignored
            Session("StartTime") = sessionStart
            
            ' BAD: DateTime.Now for logging in web apps
            Dim logTime As DateTime = DateTime.Now ' Server timezone, not user timezone
            WriteLog($"Action performed at {logTime}")
        End Sub
        
        ' GOOD: Proper DateTime handling with timezone consideration
        
        Sub GoodDateTimeUtcUsage()
            ' GOOD: Using DateTime.UtcNow for timezone-independent operations
            Dim currentTimeUtc As DateTime = DateTime.UtcNow
            LogActivity(currentTimeUtc)
            
            ' GOOD: UTC for calculations
            Dim startTimeUtc As DateTime = DateTime.UtcNow
            Dim endTimeUtc As DateTime = DateTime.UtcNow.AddHours(2)
            Dim duration As TimeSpan = endTimeUtc - startTimeUtc
            ProcessDuration(duration)
            
            ' GOOD: Store UTC in database
            Dim timestampUtc As DateTime = DateTime.UtcNow
            SaveToDatabase(timestampUtc) ' Clear timezone reference
        End Sub
        
        Sub GoodDateTimeParsingWithCulture()
            ' GOOD: DateTime.Parse with CultureInfo
            Dim dateString As String = "12/31/2023"
            Dim parsedDate As DateTime = DateTime.Parse(dateString, CultureInfo.InvariantCulture)
            ProcessDate(parsedDate)
            
            ' GOOD: Parse with DateTimeStyles
            Dim timeString As String = "2023-12-31T15:30:00Z"
            Dim parsedTime As DateTime = DateTime.Parse(timeString, Nothing, DateTimeStyles.RoundtripKind)
            ScheduleEvent(parsedTime)
            
            ' GOOD: ParseExact with culture
            Dim customFormat As String = "dd/MM/yyyy"
            Dim dateInput As String = "31/12/2023"
            Dim exactDate As DateTime = DateTime.ParseExact(dateInput, customFormat, CultureInfo.InvariantCulture)
            ValidateDate(exactDate)
        End Sub
        
        Sub GoodDateTimeArithmeticWithTimezone()
            ' GOOD: AddDays with UTC consideration
            Dim baseDateUtc As DateTime = GetBaseDateUtc()
            Dim futureDateUtc As DateTime = baseDateUtc.AddDays(30)
            ScheduleFutureTask(futureDateUtc)
            
            ' GOOD: AddHours with timezone awareness
            Dim meetingTimeUtc As DateTime = GetMeetingTimeUtc()
            Dim reminderTimeUtc As DateTime = meetingTimeUtc.AddHours(-1)
            SetReminder(reminderTimeUtc)
            
            ' GOOD: Using TimeZoneInfo for local time conversion
            Dim utcTime As DateTime = DateTime.UtcNow
            Dim userTimeZone As TimeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time")
            Dim localTime As DateTime = TimeZoneInfo.ConvertTimeFromUtc(utcTime, userTimeZone)
            DisplayLocalTime(localTime)
        End Sub
        
        Sub GoodDateTimeComparisonsWithUtc()
            ' GOOD: Compare UTC times
            Dim storedDateUtc As DateTime = GetStoredDateUtc()
            If DateTime.UtcNow > storedDateUtc Then
                ProcessExpiredData()
            End If
            
            ' GOOD: UTC arithmetic
            Dim createdDateUtc As DateTime = GetCreatedDateUtc()
            Dim age As TimeSpan = DateTime.UtcNow - createdDateUtc
            If age.TotalDays > 30 Then
                ArchiveData()
            End If
        End Sub
        
        Sub GoodDateTimeFormattingWithCulture()
            ' GOOD: ToString with CultureInfo
            Dim currentDateUtc As DateTime = DateTime.UtcNow
            Dim formattedDate As String = currentDateUtc.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture)
            DisplayDate(formattedDate)
            
            ' GOOD: Specific format with culture
            Dim timestampUtc As DateTime = DateTime.UtcNow
            Dim display As String = timestampUtc.ToString("yyyy-MM-dd HH:mm:ss UTC", CultureInfo.InvariantCulture)
            LogTimestamp(display)
        End Sub
        
        Sub GoodDateTimeInWebContextWithTimezone()
            ' GOOD: Store UTC, convert for display
            Dim sessionStartUtc As DateTime = DateTime.UtcNow
            Session("StartTimeUtc") = sessionStartUtc
            
            ' Convert to user's timezone for display
            Dim userTimeZone As String = GetUserTimeZone()
            Dim userTime As DateTime = ConvertUtcToUserTime(sessionStartUtc, userTimeZone)
            DisplaySessionStart(userTime)
            
            ' GOOD: Log in UTC with timezone info
            Dim logTimeUtc As DateTime = DateTime.UtcNow
            WriteLog($"Action performed at {logTimeUtc:yyyy-MM-dd HH:mm:ss} UTC")
        End Sub
        
        Sub GoodDateTimeWithDateTimeOffset()
            ' GOOD: Using DateTimeOffset for timezone-aware operations
            Dim currentOffset As DateTimeOffset = DateTimeOffset.Now
            Dim utcOffset As DateTimeOffset = DateTimeOffset.UtcNow
            
            ' GOOD: Preserve timezone information
            Dim specificOffset As DateTimeOffset = New DateTimeOffset(2023, 12, 31, 15, 30, 0, TimeSpan.FromHours(-5))
            ProcessDateTimeOffset(specificOffset)
        End Sub
        
        Sub GoodDateTimeValidation()
            ' GOOD: Validate DateTime operations
            Dim dateString As String = GetDateInput()
            Dim result As DateTime
            
            If DateTime.TryParse(dateString, CultureInfo.InvariantCulture, DateTimeStyles.None, result) Then
                ' Ensure it's treated as UTC if needed
                If result.Kind = DateTimeKind.Unspecified Then
                    result = DateTime.SpecifyKind(result, DateTimeKind.Utc)
                End If
                ProcessValidDate(result)
            Else
                HandleInvalidDate()
            End If
        End Sub
        
        Sub GoodDateTimeConversions()
            ' GOOD: Explicit timezone conversions
            Dim localTime As DateTime = DateTime.Now
            Dim utcTime As DateTime = localTime.ToUniversalTime()
            
            ' GOOD: Convert back to local when needed
            Dim storedUtc As DateTime = GetStoredUtcTime()
            Dim displayLocal As DateTime = storedUtc.ToLocalTime()
            
            ProcessTimes(utcTime, displayLocal)
        End Sub
        
        ' Helper methods
        Sub LogActivity(time As DateTime)
        End Sub
        
        Sub ProcessDuration(duration As TimeSpan)
        End Sub
        
        Sub SaveToDatabase(timestamp As DateTime)
        End Sub
        
        Sub ProcessDate(date As DateTime)
        End Sub
        
        Sub ScheduleEvent(time As DateTime)
        End Sub
        
        Sub ValidateDate(date As DateTime)
        End Sub
        
        Sub ScheduleFutureTask(date As DateTime)
        End Sub
        
        Sub SetReminder(time As DateTime)
        End Sub
        
        Sub UpdateSchedule(time As DateTime)
        End Sub
        
        Sub ProcessExpiredData()
        End Sub
        
        Sub ArchiveData()
        End Sub
        
        Sub DisplayDate(dateString As String)
        End Sub
        
        Sub LogTimestamp(timestamp As String)
        End Sub
        
        Sub WriteLog(message As String)
        End Sub
        
        Sub DisplaySessionStart(time As DateTime)
        End Sub
        
        Sub ProcessDateTimeOffset(offset As DateTimeOffset)
        End Sub
        
        Sub ProcessValidDate(date As DateTime)
        End Sub
        
        Sub HandleInvalidDate()
        End Sub
        
        Sub ProcessTimes(utc As DateTime, local As DateTime)
        End Sub
        
        Sub DisplayLocalTime(time As DateTime)
        End Sub
        
        Function GetBaseDate() As DateTime
            Return DateTime.Now.Date
        End Function
        
        Function GetBaseDateUtc() As DateTime
            Return DateTime.UtcNow.Date
        End Function
        
        Function GetMeetingTime() As DateTime
            Return DateTime.Now.AddHours(2)
        End Function
        
        Function GetMeetingTimeUtc() As DateTime
            Return DateTime.UtcNow.AddHours(2)
        End Function
        
        Function GetAppointmentTime() As DateTime
            Return DateTime.Now.AddDays(1)
        End Function
        
        Function GetStoredDate() As DateTime
            Return DateTime.Now.AddDays(-10)
        End Function
        
        Function GetStoredDateUtc() As DateTime
            Return DateTime.UtcNow.AddDays(-10)
        End Function
        
        Function GetCreatedDate() As DateTime
            Return DateTime.Now.AddDays(-45)
        End Function
        
        Function GetCreatedDateUtc() As DateTime
            Return DateTime.UtcNow.AddDays(-45)
        End Function
        
        Function GetStoredUtcTime() As DateTime
            Return DateTime.UtcNow.AddHours(-3)
        End Function
        
        Function GetUserTimeZone() As String
            Return "Eastern Standard Time"
        End Function
        
        Function GetDateInput() As String
            Return "2023-12-31"
        End Function
        
        Function ConvertUtcToUserTime(utcTime As DateTime, timeZone As String) As DateTime
            Dim tz As TimeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById(timeZone)
            Return TimeZoneInfo.ConvertTimeFromUtc(utcTime, tz)
        End Function
    </script>
</body>
</html>

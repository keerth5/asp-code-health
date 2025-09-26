<%@ Page Language="VB" %>
<html>
<head>
    <title>Law of Demeter Violations Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Law of Demeter violations - accessing properties/methods of other objects' internal objects
        
        ' BAD: Deep object traversal chains
        Sub BadProcessCustomerOrder()
            ' BAD: Multiple levels of object access
            Dim customerName = order.Customer.Profile.PersonalInfo.Name.FullName
            Dim customerEmail = order.Customer.Profile.ContactInfo.Email.Address
            Dim shippingStreet = order.ShippingAddress.Location.Address.Street.Name
            Dim billingCity = order.BillingAddress.Location.Address.City.Name
        End Sub
        
        ' BAD: Request object chain violations
        Sub BadProcessWebRequest()
            ' BAD: Deep chains through request objects
            Dim userAgent = Request.Headers.UserAgent.Value.ToString()
            Dim acceptLanguage = Request.Headers.AcceptLanguage.Values.FirstOrDefault()
            Dim sessionId = Request.Cookies.SessionCookie.Value.ToString()
            Dim serverName = Request.Server.Variables.ServerName.Value
        End Sub
        
        ' BAD: Configuration chain violations
        Sub BadLoadConfiguration()
            ' BAD: Deep configuration access
            Dim dbServer = Application.Configuration.Database.Connection.Server.Name
            Dim dbPort = Application.Configuration.Database.Connection.Server.Port
            Dim logLevel = Application.Configuration.Logging.FileLogger.Level.Value
            Dim cacheSize = Application.Configuration.Cache.Memory.Settings.MaxSize
        End Sub
        
        ' BAD: UI control chain violations
        Sub BadUpdateUserInterface()
            ' BAD: Deep UI control access
            Dim textValue = Page.Controls.MainPanel.UserForm.NameTextBox.Text.Value
            Dim isChecked = Page.Controls.MainPanel.OptionsPanel.CheckBox1.Checked.Value
            Dim selectedIndex = Page.Controls.MainPanel.DropDownList1.SelectedItem.Index.Value
            Dim gridData = Page.Controls.DataPanel.GridView1.DataSource.Table.Rows.Count
        End Sub
        
        ' BAD: Business object chain violations
        Sub BadCalculateOrderTotal()
            ' BAD: Accessing nested business object properties
            Dim itemPrice = order.Items.FirstItem.Product.Pricing.BasePrice.Amount.Value
            Dim discountRate = order.Customer.Membership.Discount.Rate.Percentage.Value
            Dim taxRate = order.ShippingAddress.Region.TaxInfo.Rate.Percentage.Value
            Dim shippingCost = order.ShippingMethod.Pricing.Cost.Amount.Value
        End Sub
        
        ' BAD: Database result chain violations
        Sub BadProcessDatabaseResults()
            ' BAD: Deep access to database result structures
            Dim userName = dataSet.Tables.Users.Rows.FirstRow.Columns.Name.Value.ToString()
            Dim userEmail = dataSet.Tables.Users.Rows.FirstRow.Columns.Email.Value.ToString()
            Dim orderCount = dataSet.Tables.Orders.Rows.Count.Value.ToString()
            Dim lastOrderDate = dataSet.Tables.Orders.Rows.LastRow.Columns.OrderDate.Value
        End Sub
        
        ' BAD: Session and application state violations
        Sub BadAccessSessionData()
            ' BAD: Deep session state access
            Dim userId = Session.UserData.Profile.Identity.UserId.Value
            Dim preferences = Session.UserData.Settings.Preferences.Theme.Name
            Dim permissions = Session.UserData.Security.Permissions.Level.Value
            Dim lastLogin = Session.UserData.Activity.LastLogin.DateTime.Value
        End Sub
        
        ' BAD: File system chain violations
        Sub BadProcessFileSystem()
            ' BAD: Deep file system access
            Dim fileName = Server.MapPath.Directory.Files.FirstFile.Name.Value
            Dim fileSize = Server.MapPath.Directory.Files.FirstFile.Size.Bytes.Value
            Dim fileDate = Server.MapPath.Directory.Files.FirstFile.Created.DateTime.Value
            Dim permissions = Server.MapPath.Directory.Security.Permissions.Owner.Name
        End Sub
        
        ' GOOD: Law of Demeter compliant code
        
        ' GOOD: Using wrapper methods instead of deep chains
        Sub GoodProcessCustomerOrder()
            ' GOOD: Ask objects for what you need, don't dig into them
            Dim customerName = order.GetCustomerFullName()
            Dim customerEmail = order.GetCustomerEmail()
            Dim shippingStreet = order.GetShippingStreet()
            Dim billingCity = order.GetBillingCity()
        End Sub
        
        ' GOOD: Request helper methods
        Sub GoodProcessWebRequest()
            ' GOOD: Use helper methods instead of deep chains
            Dim userAgent = RequestHelper.GetUserAgent(Request)
            Dim acceptLanguage = RequestHelper.GetAcceptLanguage(Request)
            Dim sessionId = RequestHelper.GetSessionId(Request)
            Dim serverName = RequestHelper.GetServerName(Request)
        End Sub
        
        ' GOOD: Configuration service
        Sub GoodLoadConfiguration()
            ' GOOD: Use configuration service instead of deep access
            Dim dbServer = ConfigurationService.GetDatabaseServer()
            Dim dbPort = ConfigurationService.GetDatabasePort()
            Dim logLevel = ConfigurationService.GetLogLevel()
            Dim cacheSize = ConfigurationService.GetCacheSize()
        End Sub
        
        ' GOOD: UI helper methods
        Sub GoodUpdateUserInterface()
            ' GOOD: Use page helper methods
            Dim textValue = PageHelper.GetTextBoxValue(Page, "NameTextBox")
            Dim isChecked = PageHelper.GetCheckBoxValue(Page, "CheckBox1")
            Dim selectedIndex = PageHelper.GetDropDownSelectedIndex(Page, "DropDownList1")
            Dim gridRowCount = PageHelper.GetGridViewRowCount(Page, "GridView1")
        End Sub
        
        ' GOOD: Business service methods
        Sub GoodCalculateOrderTotal()
            ' GOOD: Use business service methods
            Dim itemPrice = OrderCalculationService.GetItemPrice(order)
            Dim discountRate = CustomerService.GetDiscountRate(order.Customer)
            Dim taxRate = TaxService.GetTaxRate(order.ShippingAddress)
            Dim shippingCost = ShippingService.GetShippingCost(order.ShippingMethod)
        End Sub
        
        ' GOOD: Data access layer
        Sub GoodProcessDatabaseResults()
            ' GOOD: Use data access methods
            Dim userName = UserDataAccess.GetUserName(dataSet)
            Dim userEmail = UserDataAccess.GetUserEmail(dataSet)
            Dim orderCount = OrderDataAccess.GetOrderCount(dataSet)
            Dim lastOrderDate = OrderDataAccess.GetLastOrderDate(dataSet)
        End Sub
        
        ' GOOD: Session service
        Sub GoodAccessSessionData()
            ' GOOD: Use session service methods
            Dim userId = SessionService.GetUserId(Session)
            Dim preferences = SessionService.GetUserPreferences(Session)
            Dim permissions = SessionService.GetUserPermissions(Session)
            Dim lastLogin = SessionService.GetLastLogin(Session)
        End Sub
        
        ' GOOD: File service
        Sub GoodProcessFileSystem()
            ' GOOD: Use file service methods
            Dim fileName = FileService.GetFirstFileName(Server)
            Dim fileSize = FileService.GetFirstFileSize(Server)
            Dim fileDate = FileService.GetFirstFileDate(Server)
            Dim permissions = FileService.GetDirectoryOwner(Server)
        End Sub
        
        ' GOOD: Fluent interface that maintains Law of Demeter
        Class GoodOrderBuilder
            Private _order As Order
            
            Public Sub New()
                _order = New Order()
            End Sub
            
            Public Function WithCustomer(customer As Customer) As GoodOrderBuilder
                _order.Customer = customer
                Return Me
            End Function
            
            Public Function WithShippingAddress(address As Address) As GoodOrderBuilder
                _order.ShippingAddress = address
                Return Me
            End Function
            
            Public Function WithBillingAddress(address As Address) As GoodOrderBuilder
                _order.BillingAddress = address
                Return Me
            End Function
            
            Public Function Build() As Order
                Return _order
            End Function
        End Class
        
        ' Supporting classes with proper encapsulation
        Class Order
            Public Property Customer As Customer
            Public Property Items As List(Of OrderItem)
            Public Property ShippingAddress As Address
            Public Property BillingAddress As Address
            Public Property ShippingMethod As ShippingMethod
            
            ' GOOD: Wrapper methods that encapsulate complex access
            Public Function GetCustomerFullName() As String
                Return Customer?.GetFullName()
            End Function
            
            Public Function GetCustomerEmail() As String
                Return Customer?.GetEmail()
            End Function
            
            Public Function GetShippingStreet() As String
                Return ShippingAddress?.GetStreet()
            End Function
            
            Public Function GetBillingCity() As String
                Return BillingAddress?.GetCity()
            End Function
        End Class
        
        Class Customer
            Public Property Profile As CustomerProfile
            Public Property Membership As Membership
            
            Public Function GetFullName() As String
                Return Profile?.GetFullName()
            End Function
            
            Public Function GetEmail() As String
                Return Profile?.GetEmail()
            End Function
        End Class
        
        Class CustomerProfile
            Public Property PersonalInfo As PersonalInfo
            Public Property ContactInfo As ContactInfo
            
            Public Function GetFullName() As String
                Return PersonalInfo?.GetFullName()
            End Function
            
            Public Function GetEmail() As String
                Return ContactInfo?.GetEmail()
            End Function
        End Class
        
        Class PersonalInfo
            Public Property Name As FullName
            
            Public Function GetFullName() As String
                Return Name?.GetFullName()
            End Function
        End Class
        
        Class ContactInfo
            Public Property Email As EmailInfo
            
            Public Function GetEmail() As String
                Return Email?.GetAddress()
            End Function
        End Class
        
        Class FullName
            Public Property FullName As String
            
            Public Function GetFullName() As String
                Return FullName
            End Function
        End Class
        
        Class EmailInfo
            Public Property Address As String
            
            Public Function GetAddress() As String
                Return Address
            End Function
        End Class
        
        Class Address
            Public Property Location As Location
            
            Public Function GetStreet() As String
                Return Location?.GetStreet()
            End Function
            
            Public Function GetCity() As String
                Return Location?.GetCity()
            End Function
        End Class
        
        Class Location
            Public Property Address As AddressDetails
            
            Public Function GetStreet() As String
                Return Address?.GetStreet()
            End Function
            
            Public Function GetCity() As String
                Return Address?.GetCity()
            End Function
        End Class
        
        Class AddressDetails
            Public Property Street As StreetInfo
            Public Property City As CityInfo
            
            Public Function GetStreet() As String
                Return Street?.GetName()
            End Function
            
            Public Function GetCity() As String
                Return City?.GetName()
            End Function
        End Class
        
        Class StreetInfo
            Public Property Name As String
            
            Public Function GetName() As String
                Return Name
            End Function
        End Class
        
        Class CityInfo
            Public Property Name As String
            
            Public Function GetName() As String
                Return Name
            End Function
        End Class
        
        ' Helper services that maintain Law of Demeter
        Class RequestHelper
            Public Shared Function GetUserAgent(request As HttpRequest) As String
                Return request.UserAgent
            End Function
            
            Public Shared Function GetAcceptLanguage(request As HttpRequest) As String
                Return request.Headers("Accept-Language")
            End Function
            
            Public Shared Function GetSessionId(request As HttpRequest) As String
                Return request.Cookies("ASP.NET_SessionId")?.Value
            End Function
            
            Public Shared Function GetServerName(request As HttpRequest) As String
                Return request.ServerVariables("SERVER_NAME")
            End Function
        End Class
        
        Class ConfigurationService
            Public Shared Function GetDatabaseServer() As String
                Return ConfigurationManager.AppSettings("DatabaseServer")
            End Function
            
            Public Shared Function GetDatabasePort() As Integer
                Return Integer.Parse(ConfigurationManager.AppSettings("DatabasePort"))
            End Function
            
            Public Shared Function GetLogLevel() As String
                Return ConfigurationManager.AppSettings("LogLevel")
            End Function
            
            Public Shared Function GetCacheSize() As Integer
                Return Integer.Parse(ConfigurationManager.AppSettings("CacheSize"))
            End Function
        End Class
        
        Class PageHelper
            Public Shared Function GetTextBoxValue(page As Page, controlId As String) As String
                Dim textBox = TryCast(page.FindControl(controlId), TextBox)
                Return textBox?.Text
            End Function
            
            Public Shared Function GetCheckBoxValue(page As Page, controlId As String) As Boolean
                Dim checkBox = TryCast(page.FindControl(controlId), CheckBox)
                Return checkBox?.Checked
            End Function
            
            Public Shared Function GetDropDownSelectedIndex(page As Page, controlId As String) As Integer
                Dim dropDown = TryCast(page.FindControl(controlId), DropDownList)
                Return dropDown?.SelectedIndex
            End Function
            
            Public Shared Function GetGridViewRowCount(page As Page, controlId As String) As Integer
                Dim gridView = TryCast(page.FindControl(controlId), GridView)
                Return gridView?.Rows.Count
            End Function
        End Class
        
        ' Additional supporting classes
        Class OrderItem
        End Class
        
        Class Membership
        End Class
        
        Class ShippingMethod
        End Class
        
        Class HttpRequest
            Public Property UserAgent As String
            Public Property Headers As NameValueCollection
            Public Property Cookies As HttpCookieCollection
            Public Property ServerVariables As NameValueCollection
        End Class
        
        Class NameValueCollection
            Default Public Property Item(key As String) As String
                Get
                    Return ""
                End Get
                Set(value As String)
                End Set
            End Property
        End Class
        
        Class HttpCookieCollection
            Default Public Property Item(name As String) As HttpCookie
                Get
                    Return New HttpCookie(name)
                End Get
                Set(value As HttpCookie)
                End Set
            End Property
        End Class
        
        Class HttpCookie
            Public Property Value As String
            
            Public Sub New(name As String)
            End Sub
        End Class
        
        Class Page
            Public Function FindControl(id As String) As Control
                Return New Control()
            End Function
        End Class
        
        Class Control
        End Class
        
        Class TextBox
            Inherits Control
            Public Property Text As String
        End Class
        
        Class CheckBox
            Inherits Control
            Public Property Checked As Boolean
        End Class
        
        Class DropDownList
            Inherits Control
            Public Property SelectedIndex As Integer
        End Class
        
        Class GridView
            Inherits Control
            Public Property Rows As GridViewRowCollection
        End Class
        
        Class GridViewRowCollection
            Public Property Count As Integer
        End Class
        
        Class ConfigurationManager
            Public Shared ReadOnly Property AppSettings As NameValueCollection
                Get
                    Return New NameValueCollection()
                End Get
            End Property
        End Class
        
        ' Business services
        Class OrderCalculationService
            Public Shared Function GetItemPrice(order As Order) As Decimal
                Return 0D
            End Function
        End Class
        
        Class CustomerService
            Public Shared Function GetDiscountRate(customer As Customer) As Decimal
                Return 0D
            End Function
        End Class
        
        Class TaxService
            Public Shared Function GetTaxRate(address As Address) As Decimal
                Return 0D
            End Function
        End Class
        
        Class ShippingService
            Public Shared Function GetShippingCost(shippingMethod As ShippingMethod) As Decimal
                Return 0D
            End Function
        End Class
        
        Class UserDataAccess
            Public Shared Function GetUserName(dataSet As DataSet) As String
                Return ""
            End Function
            
            Public Shared Function GetUserEmail(dataSet As DataSet) As String
                Return ""
            End Function
        End Class
        
        Class OrderDataAccess
            Public Shared Function GetOrderCount(dataSet As DataSet) As Integer
                Return 0
            End Function
            
            Public Shared Function GetLastOrderDate(dataSet As DataSet) As DateTime
                Return DateTime.Now
            End Function
        End Class
        
        Class SessionService
            Public Shared Function GetUserId(session As HttpSessionState) As String
                Return ""
            End Function
            
            Public Shared Function GetUserPreferences(session As HttpSessionState) As String
                Return ""
            End Function
            
            Public Shared Function GetUserPermissions(session As HttpSessionState) As String
                Return ""
            End Function
            
            Public Shared Function GetLastLogin(session As HttpSessionState) As DateTime
                Return DateTime.Now
            End Function
        End Class
        
        Class FileService
            Public Shared Function GetFirstFileName(server As HttpServerUtility) As String
                Return ""
            End Function
            
            Public Shared Function GetFirstFileSize(server As HttpServerUtility) As Long
                Return 0
            End Function
            
            Public Shared Function GetFirstFileDate(server As HttpServerUtility) As DateTime
                Return DateTime.Now
            End Function
            
            Public Shared Function GetDirectoryOwner(server As HttpServerUtility) As String
                Return ""
            End Function
        End Class
        
        Class DataSet
        End Class
        
        Class HttpSessionState
        End Class
        
        Class HttpServerUtility
        End Class
        
        ' Example properties used in bad examples
        Private order As Order = New Order()
        Private dataSet As DataSet = New DataSet()
    </script>
</body>
</html>

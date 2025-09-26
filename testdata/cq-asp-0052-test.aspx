<%@ Page Language="VB" %>
<html>
<head>
    <title>Cross-Site Scripting (XSS) Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Cross-Site Scripting (XSS) vulnerabilities - unencoded output
        
        Sub BadXSSExamples()
            ' BAD: Response.Write without encoding
            Response.Write(Request.Form("userName")) ' Bad: XSS vulnerability
            Response.Write(Request.QueryString("message")) ' Bad: XSS vulnerability
            Response.Write(Request.Params("content")) ' Bad: XSS vulnerability
            
            ' BAD: Direct output in server controls
            lblMessage.Text = Request.Form("userMessage") ' Bad: XSS vulnerability
            divContent.InnerHtml = Request.QueryString("htmlContent") ' Bad: XSS vulnerability
            spanText.InnerText = Request.Form("textContent") ' Bad: XSS vulnerability (though InnerText is safer)
            
            ' BAD: String concatenation with user input
            Dim userInput As String = Request.Form("input")
            Dim displayMessage As String = "Hello, " + userInput + "!"
            Response.Write(displayMessage) ' Bad: XSS vulnerability
            
            ' BAD: Session and ViewState values without encoding
            Response.Write(Session("userPreference")) ' Bad: if session contains user input
            Response.Write(ViewState("savedData")) ' Bad: if ViewState contains user input
        End Sub
        
        Sub BadServerSideIncludes()
            ' BAD: Server-side includes without encoding
            Dim greeting As String = Request.QueryString("greeting")
            Dim welcomeMessage As String = greeting + ", welcome to our site!"
            
            ' Bad: Direct output without encoding
            Response.Write("<h1>" + welcomeMessage + "</h1>") ' Bad: XSS vulnerability
            Response.Write("<div class='message'>" + Request.Form("status") + "</div>") ' Bad: XSS vulnerability
        End Sub
        
        Sub BadJavaScriptInjection()
            ' BAD: JavaScript injection vulnerabilities
            Dim scriptValue As String = Request.QueryString("script")
            Dim jsonData As String = Request.Form("jsonData")
            
            ' Bad: Injecting user input into JavaScript
            Response.Write("<script>var userValue = '" + scriptValue + "';</script>") ' Bad: XSS vulnerability
            Response.Write("<script>processData(" + jsonData + ");</script>") ' Bad: XSS vulnerability
            
            ' Bad: Event handlers with user input
            btnSubmit.Attributes.Add("onclick", "alert('" + Request.Form("alertMessage") + "')") ' Bad: XSS vulnerability
        End Sub
        
        ' GOOD: Properly encoded output to prevent XSS
        
        Sub GoodHTMLEncoding()
            ' GOOD: Using Server.HtmlEncode
            Response.Write(Server.HtmlEncode(Request.Form("userName"))) ' Good: encoded output
            Response.Write(Server.HtmlEncode(Request.QueryString("message"))) ' Good: encoded output
            Response.Write(Server.HtmlEncode(Request.Params("content"))) ' Good: encoded output
            
            ' GOOD: Using HttpUtility.HtmlEncode
            Response.Write(HttpUtility.HtmlEncode(Request.Form("userMessage"))) ' Good: encoded output
            Response.Write(HttpUtility.HtmlEncode(Request.QueryString("data"))) ' Good: encoded output
        End Sub
        
        Sub GoodServerControls()
            ' GOOD: Using Text property (automatically encoded)
            lblMessage.Text = Request.Form("userMessage") ' Good: Text property encodes
            lblStatus.Text = Request.QueryString("status") ' Good: Text property encodes
            
            ' GOOD: Encoding before setting InnerHtml
            divContent.InnerHtml = Server.HtmlEncode(Request.QueryString("htmlContent")) ' Good: encoded
            spanText.InnerHtml = HttpUtility.HtmlEncode(Request.Form("content")) ' Good: encoded
        End Sub
        
        Sub GoodAttributeEncoding()
            ' GOOD: Using Server.HtmlAttributeEncode for attributes
            Dim userClass As String = Request.QueryString("cssClass")
            Dim encodedClass As String = Server.HtmlAttributeEncode(userClass)
            
            Response.Write("<div class='" + encodedClass + "'>Content</div>") ' Good: attribute encoded
            
            ' GOOD: HttpUtility.HtmlAttributeEncode
            Dim userTitle As String = Request.Form("title")
            Dim encodedTitle As String = HttpUtility.HtmlAttributeEncode(userTitle)
            Response.Write("<span title='" + encodedTitle + "'>Text</span>") ' Good: attribute encoded
        End Sub
        
        Sub GoodJavaScriptEncoding()
            ' GOOD: Proper JavaScript encoding
            Dim scriptValue As String = Request.QueryString("script")
            Dim encodedScript As String = HttpUtility.JavaScriptStringEncode(scriptValue)
            
            Response.Write("<script>var userValue = '" + encodedScript + "';</script>") ' Good: JS encoded
            
            ' GOOD: JSON serialization for complex data
            Dim userData As Object = GetUserData(Request.Form("userId"))
            Dim jsonData As String = JsonConvert.SerializeObject(userData)
            Response.Write("<script>processData(" + jsonData + ");</script>") ' Good: properly serialized
        End Sub
        
        Sub GoodURLEncoding()
            ' GOOD: URL encoding for query parameters
            Dim searchTerm As String = Request.Form("search")
            Dim encodedSearch As String = Server.UrlEncode(searchTerm)
            
            Dim redirectUrl As String = "results.aspx?q=" + encodedSearch
            Response.Redirect(redirectUrl) ' Good: URL encoded parameter
            
            ' GOOD: HttpUtility.UrlEncode
            Dim category As String = Request.QueryString("category")
            Dim encodedCategory As String = HttpUtility.UrlEncode(category)
            Response.Write("<a href='products.aspx?cat=" + encodedCategory + "'>View Products</a>") ' Good: URL encoded
        End Sub
        
        Sub GoodValidationAndSanitization()
            ' GOOD: Input validation before output
            Dim userInput As String = Request.Form("input")
            
            ' Validate input format
            If Not Regex.IsMatch(userInput, "^[a-zA-Z0-9\s]+$") Then
                Throw New ArgumentException("Invalid input format")
            End If
            
            ' Safe to output validated input (but still encode as best practice)
            Response.Write(Server.HtmlEncode(userInput)) ' Good: validated and encoded
        End Sub
        
        Sub GoodWhitelistApproach()
            ' GOOD: Whitelist allowed values
            Dim colorChoice As String = Request.QueryString("color")
            Dim allowedColors As String() = {"red", "blue", "green", "yellow"}
            
            If allowedColors.Contains(colorChoice.ToLower()) Then
                Response.Write("<div style='color: " + colorChoice + "'>Colored text</div>") ' Good: whitelisted value
            Else
                Response.Write("<div>Invalid color selection</div>") ' Good: safe fallback
            End If
        End Sub
        
        Sub GoodContentSecurityPolicy()
            ' GOOD: Setting Content Security Policy headers
            Response.Headers.Add("Content-Security-Policy", "default-src 'self'; script-src 'self' 'unsafe-inline'")
            Response.Headers.Add("X-Content-Type-Options", "nosniff")
            Response.Headers.Add("X-Frame-Options", "DENY")
            Response.Headers.Add("X-XSS-Protection", "1; mode=block")
            
            ' Safe to output with CSP protection
            Response.Write(Server.HtmlEncode(Request.Form("safeContent"))) ' Good: encoded with CSP
        End Sub
        
        ' Helper methods and fields
        Private lblMessage As Label
        Private lblStatus As Label
        Private divContent As HtmlGenericControl
        Private spanText As HtmlGenericControl
        Private btnSubmit As Button
        
        Function GetUserData(userId As String) As Object
            Return New With {.id = userId, .name = "User"}
        End Function
    </script>
</body>
</html>

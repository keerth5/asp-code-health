<%@ Page Language="VB" %>
<html>
<head>
    <title>Inconsistent Method Ordering Test</title>
</head>
<body>
    <script runat="server">
        ' BAD: Inconsistent method ordering - methods not organized in a logical or consistent order within classes
        
        Class BadMethodOrdering
            ' BAD: Mixed access modifiers without logical grouping
            Private Sub ProcessPrivateData()
                ' Private method
            End Sub
            
            Public Sub DoPublicWork()
                ' Public method mixed in
            End Sub
            
            Protected Sub HandleProtectedLogic()
                ' Protected method
            End Sub
            
            Private Function CalculatePrivateValue() As Integer
                ' Another private method
                Return 42
            End Function
            
            Public Function GetPublicValue() As String
                ' Another public method
                Return "value"
            End Function
            
            Protected Function ValidateProtectedInput() As Boolean
                ' Another protected method
                Return True
            End Function
            
            ' BAD: Properties mixed with methods randomly
            Property Get BadProperty1() As String
                Return "value1"
            End Property
            
            Public Sub AnotherPublicMethod()
                ' Public method after property
            End Sub
            
            Property Set BadProperty2(value As String)
                ' Property setter
            End Property
            
            Private Sub AnotherPrivateMethod()
                ' Private method after property
            End Sub
            
            Property Get BadProperty3() As Integer
                Return 123
            End Property
            
            ' BAD: Static/Shared methods mixed inconsistently
            Public Shared Function SharedMethod1() As String
                Return "shared1"
            End Function
            
            Public Sub InstanceMethod1()
                ' Instance method
            End Sub
            
            Private Shared Sub SharedMethod2()
                ' Private shared method
            End Sub
            
            Protected Sub InstanceMethod2()
                ' Protected instance method
            End Sub
            
            Public Shared Function SharedMethod3() As Integer
                Return 1
            End Function
        End Class
        
        ' BAD: Constructor and destructor placement issues
        Class BadConstructorOrdering
            Public Sub DoWork()
                ' Method before constructor
            End Sub
            
            Public Sub New()
                ' Constructor in middle
            End Sub
            
            Private Sub ProcessData()
                ' Private method after constructor
            End Sub
            
            Protected Overrides Sub Finalize()
                ' Finalizer mixed in randomly
                MyBase.Finalize()
            End Sub
            
            Public Function GetValue() As String
                ' Public method after finalizer
                Return "value"
            End Function
        End Class
        
        ' BAD: Event handlers mixed with regular methods
        Class BadEventHandlerOrdering
            Public Sub ProcessBusinessLogic()
                ' Business method
            End Sub
            
            Private Sub Button1_Click(sender As Object, e As EventArgs)
                ' Event handler mixed in
            End Sub
            
            Public Function CalculateTotal() As Decimal
                ' Another business method
                Return 100D
            End Function
            
            Private Sub Page_Load(sender As Object, e As EventArgs)
                ' Another event handler
            End Sub
            
            Protected Sub ValidateInput()
                ' Protected method
            End Sub
            
            Private Sub TextBox1_TextChanged(sender As Object, e As EventArgs)
                ' Yet another event handler
            End Sub
        End Class
        
        ' GOOD: Well-organized method ordering following conventions
        
        Class GoodMethodOrdering
            ' GOOD: Constructors first
            Public Sub New()
                ' Default constructor
            End Sub
            
            Public Sub New(value As String)
                ' Parameterized constructor
            End Sub
            
            ' GOOD: Public methods grouped together
            Public Sub ProcessData()
                ' Public business method
            End Sub
            
            Public Function GetValue() As String
                ' Public accessor method
                Return "value"
            End Function
            
            Public Sub SaveData()
                ' Public action method
            End Sub
            
            ' GOOD: Protected methods grouped together
            Protected Sub ValidateInput()
                ' Protected helper method
            End Sub
            
            Protected Function CalculateResult() As Integer
                ' Protected calculation method
                Return 42
            End Function
            
            ' GOOD: Private methods grouped together
            Private Sub ProcessInternalData()
                ' Private helper method
            End Sub
            
            Private Function GetInternalValue() As String
                ' Private accessor method
                Return "internal"
            End Function
            
            Private Sub CleanupResources()
                ' Private cleanup method
            End Sub
            
            ' GOOD: Properties grouped together at end
            Public Property Name As String
            
            Public Property Value As Integer
            
            Protected Property InternalFlag As Boolean
            
            ' GOOD: Finalizer at the very end
            Protected Overrides Sub Finalize()
                CleanupResources()
                MyBase.Finalize()
            End Sub
        End Class
        
        ' GOOD: Shared methods grouped separately
        Class GoodSharedMethodOrdering
            ' GOOD: Shared/Static methods grouped at top
            Public Shared Function CreateInstance() As GoodSharedMethodOrdering
                Return New GoodSharedMethodOrdering()
            End Function
            
            Public Shared Function ValidateInput(input As String) As Boolean
                Return Not String.IsNullOrEmpty(input)
            End Function
            
            Private Shared Function GetDefaultValue() As String
                Return "default"
            End Function
            
            ' GOOD: Instance constructors after static methods
            Public Sub New()
                ' Constructor
            End Sub
            
            ' GOOD: Instance methods grouped by access level
            Public Sub ProcessInstance()
                ' Public instance method
            End Sub
            
            Protected Sub ValidateInstance()
                ' Protected instance method
            End Sub
            
            Private Sub CleanupInstance()
                ' Private instance method
            End Sub
        End Class
        
        ' GOOD: Event-driven class with proper organization
        Class GoodEventHandlerOrdering
            ' GOOD: Constructor first
            Public Sub New()
                InitializeComponent()
            End Sub
            
            ' GOOD: Public business methods grouped
            Public Sub LoadData()
                ' Business logic method
            End Sub
            
            Public Sub SaveData()
                ' Business logic method
            End Sub
            
            Public Function ValidateForm() As Boolean
                ' Business logic method
                Return True
            End Function
            
            ' GOOD: Protected helper methods
            Protected Sub InitializeComponent()
                ' Setup method
            End Sub
            
            Protected Sub DisplayMessage(message As String)
                ' Helper method
            End Sub
            
            ' GOOD: Private helper methods
            Private Sub ProcessFormData()
                ' Private helper
            End Sub
            
            Private Function GetFormValues() As Dictionary(Of String, String)
                ' Private helper
                Return New Dictionary(Of String, String)()
            End Function
            
            ' GOOD: Event handlers grouped together at end
            Private Sub Page_Load(sender As Object, e As EventArgs)
                LoadData()
            End Sub
            
            Private Sub Button1_Click(sender As Object, e As EventArgs)
                If ValidateForm() Then
                    SaveData()
                End If
            End Sub
            
            Private Sub TextBox1_TextChanged(sender As Object, e As EventArgs)
                ' Handle text change
            End Sub
        End Class
        
        ' GOOD: Repository pattern with logical method grouping
        Class GoodRepositoryOrdering
            Private connectionString As String
            
            ' GOOD: Constructor
            Public Sub New(connString As String)
                connectionString = connString
            End Sub
            
            ' GOOD: CRUD operations grouped logically
            Public Function Create(entity As Entity) As Integer
                Return SaveEntity(entity, "INSERT")
            End Function
            
            Public Function GetById(id As Integer) As Entity
                Return LoadEntity(id)
            End Function
            
            Public Function Update(entity As Entity) As Boolean
                Return SaveEntity(entity, "UPDATE") > 0
            End Function
            
            Public Sub Delete(id As Integer)
                ExecuteCommand($"DELETE FROM Entities WHERE Id = {id}")
            End Sub
            
            ' GOOD: Query methods grouped
            Public Function GetAll() As List(Of Entity)
                Return LoadEntities("SELECT * FROM Entities")
            End Function
            
            Public Function FindByName(name As String) As List(Of Entity)
                Return LoadEntities($"SELECT * FROM Entities WHERE Name = '{name}'")
            End Function
            
            ' GOOD: Private helper methods grouped at end
            Private Function LoadEntity(id As Integer) As Entity
                ' Load single entity
                Return New Entity()
            End Function
            
            Private Function LoadEntities(query As String) As List(Of Entity)
                ' Load multiple entities
                Return New List(Of Entity)()
            End Function
            
            Private Function SaveEntity(entity As Entity, operation As String) As Integer
                ' Save entity logic
                Return 1
            End Function
            
            Private Sub ExecuteCommand(sql As String)
                ' Execute SQL command
            End Sub
        End Class
        
        ' GOOD: Service class with interface implementation
        Class GoodServiceOrdering
            Implements IUserService
            
            Private repository As IUserRepository
            Private logger As ILogger
            
            ' GOOD: Constructor with dependencies
            Public Sub New(userRepo As IUserRepository, loggerService As ILogger)
                repository = userRepo
                logger = loggerService
            End Sub
            
            ' GOOD: Interface methods implemented first
            Public Function GetUser(id As Integer) As User Implements IUserService.GetUser
                logger.LogInfo($"Getting user {id}")
                Return repository.GetById(id)
            End Function
            
            Public Function CreateUser(userData As UserData) As User Implements IUserService.CreateUser
                ValidateUserData(userData)
                Dim user As User = MapToUser(userData)
                Return repository.Save(user)
            End Function
            
            Public Sub DeleteUser(id As Integer) Implements IUserService.DeleteUser
                logger.LogInfo($"Deleting user {id}")
                repository.Delete(id)
            End Sub
            
            ' GOOD: Public non-interface methods
            Public Function GetActiveUsers() As List(Of User)
                Return repository.GetByStatus("Active")
            End Function
            
            ' GOOD: Private helper methods grouped at end
            Private Sub ValidateUserData(userData As UserData)
                If userData Is Nothing Then
                    Throw New ArgumentNullException(NameOf(userData))
                End If
            End Sub
            
            Private Function MapToUser(userData As UserData) As User
                Return New User() With {
                    .Name = userData.Name,
                    .Email = userData.Email
                }
            End Function
        End Class
        
        ' Supporting classes and interfaces
        Class Entity
            Public Property Id As Integer
            Public Property Name As String
        End Class
        
        Interface IUserService
            Function GetUser(id As Integer) As User
            Function CreateUser(userData As UserData) As User
            Sub DeleteUser(id As Integer)
        End Interface
        
        Interface IUserRepository
            Function GetById(id As Integer) As User
            Function Save(user As User) As User
            Sub Delete(id As Integer)
            Function GetByStatus(status As String) As List(Of User)
        End Interface
        
        Interface ILogger
            Sub LogInfo(message As String)
        End Interface
        
        Class User
            Public Property Id As Integer
            Public Property Name As String
            Public Property Email As String
        End Class
        
        Class UserData
            Public Property Name As String
            Public Property Email As String
        End Class
    </script>
</body>
</html>

<%@ Page Language="C#" %>

<%--Incluimos del espacio de nombres del proveedor de datos para SQL Server--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<%--Incluimos el espacio de nombre para la manipulacion de datos en modo desconectado--%>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    
    // Declaramos el DataSet global para poder acceder desde la pagina
    DataSet ds = new DataSet();

    // Cuando la pagina  se carga nos conectamos a la bbbdd para recuperar los datos
    protected void Page_Load(object sender, EventArgs e)
    {
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        string consulta = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, Manufacturerwebsite" +
                          " FROM Manufacturer";

        SqlConnection conn = new SqlConnection(cadenaConexion);

        // Necesitaremos un DataAdapter para rellenar el DataSet
        SqlDataAdapter da = new SqlDataAdapter(consulta, conn);

        // Acceso a la base de datos
        da.Fill(ds, "Manufacturer");

        // Enlazamos los controles
        Page.DataBind();
        //CountryLabel.DataBind();
        //Links.DataBind();
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inline Binding desde un DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="NameLabel" runat="server">
            Name: <%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[0], "[ManufacturerName]") %>
        </asp:Label>
        <br />
        Country:
        <asp:Label ID="CountryLabel" runat="server" Text='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[0], "[ManufacturerCountry]") %>' />
        <br />
        <asp:Panel ID="Links" runat="server">
            Email:
            <asp:HyperLink ID="EmaiLink" runat="server" NavigateUrl='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[0], "[2]", "mailto:{0}") %>'
                Text='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[0], "[ManufacturerEmail]") %>' />
            <br />
            Website:
            <asp:HyperLink ID="WebsiteLink" runat="server" NavigateUrl='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[0], "[3]") %>'>
                <%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[0], "[ManufacturerWebsite]")%>
            </asp:HyperLink>
            <br />
        </asp:Panel>
        <asp:Label ID="ErrorLabel" runat="server" />
        <br />
        <asp:Panel runat="server">
            <asp:Label ID="Label1" runat="server">
            Name: <%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[3], "[ManufacturerName]") %>
            </asp:Label>
            <br />
            Country:
            <asp:Label ID="Label2" runat="server" Text='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[3], "[ManufacturerCountry]") %>' />
            <br />
            Email:
            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[3], "[2]", "mailto:{0}") %>'
                Text='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[3], "[ManufacturerEmail]") %>' />
            <br />
            Website:
            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[3], "[3]") %>'>
                <%# DataBinder.Eval(ds.Tables["Manufacturer"].Rows[3], "[ManufacturerWebsite]")%>
            </asp:HyperLink>
            <br />
        </asp:Panel>
    </div>
    </form>
</body>
</html>

<%@ Page Language="C#" %>

<%--Incluimos del espacio de nombres del proveedor de datos para SQL Server--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    
    // Declaramos el DataReader global para poder acceder desde la pagina
    SqlDataReader reader;

    // Cuando la pagina  se carga nos conectamos a la bbbdd para recuperar los datos
    protected void Page_Load(object sender, EventArgs e)
    {
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        string consulta = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, Manufacturerwebsite" +
                          " FROM Manufacturer" +
                          " WHERE ManufacturerID = 1";

        SqlConnection conn = new SqlConnection(cadenaConexion);
        SqlCommand cmd = new SqlCommand(consulta, conn);


        // Acceso a la base de datos
        try
        {
            conn.Open();

            reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                // Enlazamos los controles
                Page.DataBind();
            }
            else
            {
                ErrorLabel.Text = "No se han encontrado resultados.";
            }

            reader.Close();
        }
        finally
        {
            conn.Close();
        }


    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Inline Binding desde un DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="NameLabel" runat="server">
            Name: <%# DataBinder.Eval(reader, "[ManufacturerName]") %>
        </asp:Label>
        <br />        
        Country:
        <asp:Label ID="CountryLabel" runat="server" 
                   Text='<%# DataBinder.Eval(reader, "[ManufacturerCountry]") %>' />
        <br />
        Email:
        <asp:HyperLink ID="EmaiLink" runat="server" 
                       NavigateUrl='<%# DataBinder.Eval(reader, "[2]", "mailto:{0}") %>'
                       Text='<%# DataBinder.Eval(reader, "[ManufacturerEmail]") %>' />
        <br />
        Website:
        <asp:HyperLink ID="WebsiteLink" runat="server" 
                        NavigateUrl='<%# DataBinder.Eval(reader, "[3]") %>'>
            <%# DataBinder.Eval(reader, "[ManufacturerWebsite]") %>
        </asp:HyperLink>
                        
        <br />
        <asp:Label ID="ErrorLabel" runat="server" />
    </div>
    </form>
</body>
</html>

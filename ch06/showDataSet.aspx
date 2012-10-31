<%@ Page Language="C#" %>

<%--Incluimos del espacio de nombres del proveedor de datos para SQL Server--%>
<%@ Import Namespace="System.Data.SqlClient" %>

<%--Incluimos el espacio de nombre para la manipulacion de datos en modo desconectado--%>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    // Cuando la pagina  se carga nos conectamos a la bbbdd para recuperar los datos
    protected void Page_Load(object sender, EventArgs e)
    {
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        string consulta = "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, Manufacturerwebsite" +
                          " FROM Manufacturer";

        SqlConnection conn = new SqlConnection(cadenaConexion);

        DataSet ds = new DataSet();
        
        // Necesitaremos un DataAdapter para rellenar el DataSet
        SqlDataAdapter da = new SqlDataAdapter(consulta, conn);

        // Acceso a la base de datos
        da.Fill(ds, "Manufacturer");

        // Mostramos los resultados
        // Establecemos las propiedades de forma manual
        NameLabel.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[0]["ManufacturerName"]);
        CountryLabel.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[0]["Manufacturercountry"]);

        EmaiLink.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[0]["ManufacturerEmail"]);
        EmaiLink.NavigateUrl =
            string.Format("mailto:{0}", Convert.ToString(ds.Tables["Manufacturer"].Rows[0]["ManufacturerEmail"]));

        WebsiteLink.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[0]["ManufacturerWebsite"]);
        WebsiteLink.NavigateUrl = Convert.ToString(ds.Tables["Manufacturer"].Rows[0]["ManufacturerEmail"]);
        
        // Otra file del DataSet
        Label1.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[3]["ManufacturerName"]);
        Label2.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[3]["Manufacturercountry"]);

        HyperLink1.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[3]["ManufacturerEmail"]);
        HyperLink1.NavigateUrl =
            string.Format("mailto:{0}", Convert.ToString(ds.Tables["Manufacturer"].Rows[3]["ManufacturerEmail"]));

        HyperLink2.Text = Convert.ToString(ds.Tables["Manufacturer"].Rows[3]["ManufacturerWebsite"]);
        HyperLink2.NavigateUrl = Convert.ToString(ds.Tables["Manufacturer"].Rows[3]["ManufacturerEmail"]);
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Modificar propiedades desde codigo desde un DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Name:
        <asp:Label ID="NameLabel" runat="server" />
        <br />
        Country:
        <asp:Label ID="CountryLabel" runat="server" />
        <br />
        Email:
        <asp:HyperLink ID="EmaiLink" runat="server" />
        <br />
        Website:
        <asp:HyperLink ID="WebsiteLink" runat="server" />
        <br />
        <asp:Label ID="ErrorLabel" runat="server" />
        <br />
        Name:
        <asp:Label ID="Label1" runat="server" />
        <br />
        Country:
        <asp:Label ID="Label2" runat="server" />
        <br />
        Email:
        <asp:HyperLink ID="HyperLink1" runat="server" />
        <br />
        Website:
        <asp:HyperLink ID="HyperLink2" runat="server" />
        <br />
        <asp:Label ID="Label3" runat="server" />
        <br />
    </div>
    </form>
</body>
</html>

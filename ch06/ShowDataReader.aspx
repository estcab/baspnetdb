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
                          " FROM Manufacturer" +
                          " WHERE ManufacturerID = 1";

        SqlConnection conn = new SqlConnection(cadenaConexion);
        SqlCommand cmd = new SqlCommand(consulta, conn);


        // Acceso a la base de datos
        try
        {
            conn.Open();

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                // Establecemos las propiedades de forma manual
                NameLabel.Text = Convert.ToString(reader["ManufacturerName"]);
                CountryLabel.Text = Convert.ToString(reader["Manufacturercountry"]);
                
                EmaiLink.Text = Convert.ToString(reader["ManufacturerEmail"]);
                EmaiLink.NavigateUrl =
                    string.Format("mailto:{0}", Convert.ToString(reader["ManufacturerEmail"]));

                WebsiteLink.Text = Convert.ToString(reader["ManufacturerWebsite"]);
                WebsiteLink.NavigateUrl = Convert.ToString(reader["ManufacturerEmail"]);

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
    <title>A traves de codigo desde un DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
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
    </div>
    </form>
</body>
</html>

<%@ Page Language="C#" %>

<%--For the DataSet and other disconnected objects--%>
<%@ Import Namespace="System.Data" %>
<%--For the Data-Access specific objects--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    
    // Variables de acceso a datos
    SqlDataAdapter da;
    DataSet ds;

    private void RetrieveManufacturers()
    {
        // Consulta de seleccion
        string query = "SELECT ManufacturerID, ManufacturerName, ManufacturerCountry, " +
                              "ManufacturerEmail, ManufacturerWebsite" +
                       " FROM Manufacturer";

        // Cadena de conexion
        string cadena = ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        SqlConnection conn = new SqlConnection(cadena);

        // Creamos el Data Adapter que comunicara nuestro ds con la BBDD
        da = new SqlDataAdapter(query, conn);

        // Creamos los comandos INSERT/UPDATE/DELETE de forma automatica, basado en nuestro SELECT
        SqlCommandBuilder cb = new SqlCommandBuilder(da);

        // Creamos el dataset y lo rellenamos con la tabla 'Manufacturer'
        ds = new DataSet();
        da.Fill(ds, "Manufacturer");

        // Añadimos la informacion de la  clave primaria
        DataColumn[] primaryKey = { ds.Tables["Manufacturer"].Columns["ManufacturerID"] };
        ds.Tables["Manufacturer"].PrimaryKey = primaryKey;

    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        // Verificamos que la pagina es valida
        if (Page.IsValid)
        {
            // recuperamos la lista de fabricantes de la bbdd
            RetrieveManufacturers();

            // Estamos añadiendo una fila, o editando una ya existente ?
            DataRow drManufacturer = null;
            if (Request.QueryString["ManufacturerID"] == null)
            {
                // Creamos una nueva fila
                drManufacturer = ds.Tables["Manufacturer"].NewRow();
            }
            else
            {
                // Recuperamos la fila para editar
                drManufacturer = ds.Tables["Manufacturer"].Rows.Find(Request.QueryString["ManufacturerID"]);
            }


            // Establecemos los valores
            drManufacturer["ManufacturerName"] = ManufacturerName.Text;
            drManufacturer["ManufacturerCountry"] = ManufacturerCountry.Text;
            drManufacturer["ManufacturerEmail"] = ManufacturerEmail.Text;
            drManufacturer["ManufacturerWebsite"] = ManufacturerWebsite.Text;

            // Si es una fila nueva necesitamos añadirla a la tabla
            if ((Request.QueryString["ManufacturerID"] == null))
            {
                // Clave primaria temporarl..
                drManufacturer["ManufacturerID"] = -1;
                // Añadimos la nueva fila al ds
                ds.Tables["Manufacturer"].Rows.Add(drManufacturer);
            }

            try
            {
                // Actualizamos la base de datos
                da.Update(ds, "Manufacturer");

                QueryResult.Text = "Save of manufacturer was successful";

                // Deshabilitamos los controles
                SaveButton.Enabled = false;
                DeleteButton.Enabled = false;
                ManufacturerName.Enabled = false;
                ManufacturerCountry.Enabled = false;
                ManufacturerEmail.Enabled = false;
                ManufacturerWebsite.Enabled = false;

            }
            catch (Exception ex)
            {
                QueryResult.Text = "An error has occurred: " + ex.Message;
            }
        }
    }

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Manufacturers.aspx");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Verificamos si tenemos un ManufacturerID y cargamos sus datos
            if (Request.QueryString["ManufacturerID"] != null)
            {
                // Cargamos el dataset con todos los fabricantes
                RetrieveManufacturers();

                // buscamos la fila que queremos editar
                DataRow drManufacturer = ds.Tables["Manufacturer"].Rows.Find(Request.QueryString["ManufacturerID"]);

                // Mostramos los datos con los web controls
                ManufacturerName.Text = drManufacturer["ManufacturerName"].ToString();
                ManufacturerCountry.Text = drManufacturer["ManufacturerCountry"].ToString();
                ManufacturerEmail.Text = drManufacturer["ManufacturerEmail"].ToString();
                ManufacturerWebsite.Text = drManufacturer["ManufacturerWebsite"].ToString();
            }
            else
            {
                // Deshabilitamos el boton de borrar
                DeleteButton.Enabled = false;
            }
        }


    }

    protected void DeleteButton_Click(object sender, EventArgs e)
    {
        // Recuperamos la tabla de fabricantes de la bbdd
        RetrieveManufacturers();

        // Recuperamos la fila que queremos borrar
        DataRow drManufacturer = ds.Tables["Manufacturer"].Rows.Find(Request.QueryString["ManufacturerID"]);

        // Borramos la fila del dataset
        drManufacturer.Delete();

        // Actualizamos la bbdd
        try
        {

            da.Update(ds, "Manufacturer");

            QueryResult.Text = "Delete of manufacturer was successful";

            // Deshabilitamos los controles
            SaveButton.Enabled = false;
            DeleteButton.Enabled = false;
            ManufacturerName.Enabled = false;
            ManufacturerCountry.Enabled = false;
            ManufacturerEmail.Enabled = false;
            ManufacturerWebsite.Enabled = false;
        }
        catch (Exception ex)
        {
            QueryResult.Text = "An error has occurred: " + ex.Message;
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Manufacturer</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            width: 192px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table class="style1">
            <tr>
                <td class="style2">
                    <asp:Label ID="Label1" runat="server" Text="Manufacturer Name:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="ManufacturerName" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Label ID="Label2" runat="server" Text="Manufacturer Country:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="ManufacturerCountry" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Label ID="Label3" runat="server" Text="Manufacturer Email:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="ManufacturerEmail" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Label ID="Label4" runat="server" Text="Manufacturer WebSite:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="ManufacturerWebsite" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Button ID="SaveButton" runat="server" Text="Save Manufacturer" OnClick="SaveButton_Click" />
                </td>
                <td>
                    <asp:Button ID="DeleteButton" runat="server" OnClick="DeleteButton_Click" Text="Delete Manufacturer" />
                </td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Button ID="ReturnButton" runat="server" Text="Return To  List" OnClick="ReturnButton_Click" />
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="QueryResult" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

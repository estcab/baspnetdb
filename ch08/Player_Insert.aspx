<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que se carga la pagina rellenamos la lista de fabricantes
        if (!Page.IsPostBack)
        {
            PopulateManufacturerList();
        }
    }


    // Metodo que carga el DropDownList de Fabricantes
    private void PopulateManufacturerList()
    {
        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Creamos el comando de selecion
        string manufacturerQuery = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer ORDER BY ManufacturerName";

        // Nos conectamos a la base de datos y ejecutamos la consulta
        using (SqlConnection conn = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand cmd = new SqlCommand(manufacturerQuery, conn))
            {
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                //Configuramos el DDL
                ManufacturerListDropDownList.DataSource = reader;
                ManufacturerListDropDownList.DataTextField = "ManufacturerName";
                ManufacturerListDropDownList.DataValueField = "ManufacturerID";

                // Enlazamos los datos
                ManufacturerListDropDownList.DataBind();

                reader.Close();
            }
        }

    }

    protected void ManufacturerListDropDownList_DataBound(object sender, EventArgs e)
    {
        // Creamos el elemento 0
        ManufacturerListDropDownList.Items.Insert(0, new ListItem("Please select...", "0"));
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        // Guardamos el reproductor en la base de datos
        int playerID = SavePlayer();

        // Informamos del resultado
        if (playerID == -1)
        {
            QueryResult.Text = "An error has occurred!";
        }
        else
        {
            QueryResult.Text = "Save of player '" + playerID.ToString() + "' was successful";

            SubmitButton.Enabled = false;
        }
    }

    // Metodo que inserta un registro en la  bbdd
    private int SavePlayer()
    {
        int intPlayerID = 0;
        
        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Creamos el comando INSERT
        string insertPlayerQuery =
            "INSERT INTO Player (PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage)" +
            " VALUES (@Name, @ManufacturerID, @Cost, @Storage);" +
            // Esto nos devuelve la clave primaria generada por la bbdd
            " SELECT SCOPE_IDENTITY();";

        // Nos conectamos a la base de datos y ejecutamos la consulta
        using (SqlConnection conn = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand cmd = new SqlCommand(insertPlayerQuery, conn))
            {
                try
                {
                    // Añadimos los parametros
                    cmd.Parameters.AddWithValue("@Name", PlayerNameTextBox.Text);
                    cmd.Parameters.AddWithValue("@ManufacturerID", ManufacturerListDropDownList.SelectedValue);
                    cmd.Parameters.AddWithValue("@Cost", PlayerCostTextBox.Text);
                    cmd.Parameters.AddWithValue("@Storage", PlayerStorageTextBox.Text);

                    conn.Open();

                    // Ejecutamos la consulta
                    intPlayerID = Convert.ToInt32(cmd.ExecuteScalar());
                }
                catch (Exception ex)
                {
                    // Si hay algun error devolvemos le valor -1
                    intPlayerID = - 1;
                }
            }
        }

        return intPlayerID;
    }

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Players.aspx");
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>INSERT Player</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table class="style1">
            <tr>
                <td>
                    Player Name:
                </td>
                <td>
                    <asp:TextBox ID="PlayerNameTextBox" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Manufacturer:
                </td>
                <td>
                    <asp:DropDownList ID="ManufacturerListDropDownList" runat="server" OnDataBound="ManufacturerListDropDownList_DataBound">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>
                    Player Cost:
                </td>
                <td>
                    <asp:TextBox ID="PlayerCostTextBox" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Player Storage:
                </td>
                <td>
                    <asp:TextBox ID="PlayerStorageTextBox" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="SubmitButton" runat="server" Text="Insert Player" OnClick="SubmitButton_Click" />
                </td>
                <td>
                    <asp:Button ID="ReturnButton" runat="server" Text="Return To Players List" 
                        onclick="ReturnButton_Click" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="QueryResult" runat="server"></asp:Label>
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

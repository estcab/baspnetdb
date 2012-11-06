<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que se carga la pagina 
        if (!Page.IsPostBack)
        {
            // rellenamos la lista de fabricantes
            PopulateManufacturerList();

            // Y la lista de formatos
            PopulateFormatsList();
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
    // Metodo que carga el ChackBoxList de Formatos
    private void PopulateFormatsList()
    {
        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Creamos el comando de selecion
        string formatsQuery = "SELECT FormatID, FormatName FROM Format ORDER BY FormatName";

        // Nos conectamos a la base de datos y ejecutamos la consulta
        using (SqlConnection conn = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand cmd = new SqlCommand(formatsQuery, conn))
            {
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                //Configuramos el CBL
                FormatCheckBoxList.DataSource = reader;
                FormatCheckBoxList.DataTextField = "FormatName";
                FormatCheckBoxList.DataValueField = "FormatID";

                // Enlazamos los datos
                FormatCheckBoxList.DataBind();

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

        // Comprobamos si se ha producido un error
        if (playerID == -1)
        {
            // Informamos del error
            QueryResult.Text = "An error has occurred!";
        }
        else
        {
            // Si el reproductor se he añadido correctamente insertamos los formatos
            bool blnError = SaveFormats(playerID);

            // Revisamos de nuevo por un error
            if (blnError)
            {
                QueryResult.Text = "An error has occurred!";
            }
            else
            {
                QueryResult.Text = "Save of player '" + playerID.ToString() + "' was successful";

                SubmitButton.Enabled = false;
            }
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
                    intPlayerID = -1;
                }
            }
        }

        return intPlayerID;
    }

    // Metodo que inserta los formatos soportados en la bbdd
    private bool SaveFormats(int intPlayerID)
    {
        bool blnError = false;

        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Creamos el comando INSERT
        string insertQuery = "INSERT WhatPlaysWhatFormat(WPWFPlayerID, WPWFFormatID)" +
                             " VALUES (@PlayerID, @FormatID)";

        // Nos conectamos a la base de datos y ejecutamos la consulta
        using (SqlConnection conn = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
            {
                try
                {
                    // Añadimos los parametros
                    cmd.Parameters.AddWithValue("@PlayerID", intPlayerID);
                    cmd.Parameters.Add("@FormatID", System.Data.SqlDbType.Int);

                    conn.Open();

                    // Para cada formato seleccionado enviamos  un insert
                    foreach (ListItem item in FormatCheckBoxList.Items)
                    {
                        if (item.Selected)
                        {
                            // Añadimos el parametro que falta
                            cmd.Parameters["@FormatID"].Value = item.Value;
                            // Ejecutamos la consulta
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // indicamos el error
                    blnError = true;
                }
            }
        }

        return blnError;
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
        .style2
        {
            width: 171px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table class="style1">
            <tr>
                <td class="style2">
                    Player Name:
                </td>
                <td>
                    <asp:TextBox ID="PlayerNameTextBox" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    Manufacturer:
                </td>
                <td>
                    <asp:DropDownList ID="ManufacturerListDropDownList" runat="server" OnDataBound="ManufacturerListDropDownList_DataBound">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    Player Cost:
                </td>
                <td>
                    <asp:TextBox ID="PlayerCostTextBox" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    Player Storage:
                </td>
                <td>
                    <asp:TextBox ID="PlayerStorageTextBox" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    Supported Formats:
                </td>
                <td>
                    <asp:CheckBoxList ID="FormatCheckBoxList" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                    </asp:CheckBoxList>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Button ID="SubmitButton" runat="server" Text="Insert Player" OnClick="SubmitButton_Click" />
                </td>
                <td>
                    <asp:Button ID="ReturnButton" runat="server" Text="Return To Players List" OnClick="ReturnButton_Click" />
                </td>
            </tr>
            <tr>
                <td class="style2">
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

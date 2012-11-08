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

            // Recuperamos los  datos del reproductor  seleccionado para edicion
            RetrieveExistingPlayer();
        }
    }

    private void RetrieveExistingPlayer()
    {
        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        SqlConnection conn = new SqlConnection(cadenaConexion);

        // Creamos dos comandos, uno  para el repdroductor y otro para los formatos
        string playerQuery = "SELECT PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage" +
                              " FROM Player WHERE PlayerID=@PlayerID;";

        SqlCommand playersCmd = new SqlCommand(playerQuery, conn);
        playersCmd.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);


        string formatsQuery = "SELECT WPWFFormatID FROM WhatPlaysWhatFormat" +
                              " WHERE WPWFPlayerID = @PlayerID;";

        SqlCommand formatsCmd = new SqlCommand(formatsQuery, conn);
        formatsCmd.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);


        try
        {
            // Abrimos la conexion
            conn.Open();


            // Ejecutamos el primer comando y enlazamos los datos a los controles
            SqlDataReader playerRd = playersCmd.ExecuteReader();

            if (playerRd.Read())
            {
                PlayerNameTextBox.Text = playerRd.GetString(playerRd.GetOrdinal("PlayerName"));

                ManufacturerListDropDownList.SelectedValue =
                    playerRd.GetInt32(playerRd.GetOrdinal("PlayerManufacturerID")).ToString();

                // Sustituimos la coma por un punto, para evitar errores de validacion (, -> .)
                string playerCost = playerRd.GetDecimal(playerRd.GetOrdinal("PlayerCost")).ToString();
                PlayerCostTextBox.Text = playerCost.Replace(',', '.'); 

                PlayerStorageTextBox.Text = playerRd.GetString(playerRd.GetOrdinal("PlayerStorage"));

            }

            playerRd.Close();


            // Ejecutamos el segundo comando y enlazamos los datos a los controles
            SqlDataReader formatsRd = formatsCmd.ExecuteReader();

            while(formatsRd.Read())
            {
                // Recuperamos el valor del formato soportado
                string formatValue = formatsRd.GetInt32(formatsRd.GetOrdinal("WPWFFormatID")).ToString();

                // Marcamos como seleccionado el valor que coincida
                foreach (ListItem item in FormatCheckBoxList.Items)
                {
                    if (item.Value == formatValue)
                    {
                        item.Selected = true;
                        break;
                    }
                }
            }

            formatsRd.Close();

        }
        finally
        {
            // Cerramos la conexion
            conn.Close();
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

    protected void UpdateButton_Click(object sender, EventArgs e)
    {
        // Comprobamos que todos los controles han pasado la validacion
        if (Page.IsValid)
        {
            // Guardamos el reproductor en la base de datos
            bool blnPlayerError = UpdatePlayer();

            // Comprobamos si se ha producido un error
            if (blnPlayerError)
            {
                // Informamos del error
                QueryResult.Text = "An error has occurred!";
            }
            else
            {
                // Si el reproductor se he añadido correctamente insertamos los formatos
                bool blnFormatError = UpdateFormats();

                // Revisamos de nuevo por un error
                if (blnFormatError)
                {
                    QueryResult.Text = "An error has occurred!";
                }
                else
                {
                    QueryResult.Text = "Update of player '" + Request.QueryString["PlayerID"] + "' was successful";

                    UpdateButton.Enabled = false;
                }
            }
        }

    }

    // Metodo que inserta un registro en la  bbdd
    private bool UpdatePlayer()
    {
        bool blnError = false;

        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Creamos el comando UPDATE
        string updatePlayerQuery = "UPDATE Player " +
            "SET PlayerName  = @Name," +
               " PlayerManufacturerID = @ManufacturerID," +
               " PlayerCost = @Cost," +
               " PlayerStorage = @Storage" +
               " WHERE PlayerID = @PlayerID";

        // Nos conectamos a la base de datos y ejecutamos la consulta
        using (SqlConnection conn = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand cmd = new SqlCommand(updatePlayerQuery, conn))
            {
                try
                {
                    // Añadimos los parametros
                    cmd.Parameters.AddWithValue("@Name", PlayerNameTextBox.Text);
                    cmd.Parameters.AddWithValue("@ManufacturerID", ManufacturerListDropDownList.SelectedValue);
                    cmd.Parameters.AddWithValue("@Cost", PlayerCostTextBox.Text);
                    cmd.Parameters.AddWithValue("@Storage", PlayerStorageTextBox.Text);
                    cmd.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);

                    conn.Open();

                    // Ejecutamos la consulta
                    cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    // Si hay algun error devolvemos 
                    blnError = true;
                }
            }
        }

        return blnError;
    }

    // Metodo que actualiza los formatos soportados en la bbdd
    private bool UpdateFormats()
    {
        bool blnError = false;

        // Recuperamos la cadena de conexion
        string cadenaConexion =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Primero borramos todos los formatos soportados por el reproductor
        string deleteQuery = "DELETE FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = @PlayerID;";


        // Luego volvemos a insertar todos los formatos seleccionados
        string insertQuery = "INSERT WhatPlaysWhatFormat (WPWFPlayerID, WPWFFormatID)" +
                             " VALUES (@PlayerID, @FormatID)";

        // Nos conectamos a la base de datos y ejecutamos la consulta
        using (SqlConnection conn = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand delCmd = new SqlCommand(deleteQuery, conn))
            using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
            {
                try
                {
                    // Sentencia DELETE
                    delCmd.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);
                    
                    // Sentencia INSERT        
                    insertCmd.Parameters.AddWithValue("@PlayerID", Request.QueryString["PlayerID"]);
                    insertCmd.Parameters.Add("@FormatID", System.Data.SqlDbType.Int);

                    conn.Open();

                    // Borramos los datos 
                    delCmd.ExecuteNonQuery();
                    
                    // Para cada formato seleccionado enviamos  un insert
                    foreach (ListItem item in FormatCheckBoxList.Items)
                    {
                        if (item.Selected)
                        {
                            // Añadimos el parametro que falta
                            insertCmd.Parameters["@FormatID"].Value = item.Value;
                            // Ejecutamos la consulta
                            insertCmd.ExecuteNonQuery();
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

    protected void Unnamed6_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (FormatCheckBoxList.SelectedIndex == -1)
        {
            args.IsValid = false;
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UPDATE Player</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
        }
        .style3
        {
            width: 160px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table class="style1">
            <tr>
                <td class="style2" colspan="2">
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    Player Name:
                </td>
                <td>
                    <asp:TextBox ID="PlayerNameTextBox" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ErrorMessage="You must enter a name." ControlToValidate="PlayerNameTextBox"
                        runat="server" Display="Dynamic" Text="*" />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    Manufacturer:
                </td>
                <td>
                    <asp:DropDownList ID="ManufacturerListDropDownList" runat="server" OnDataBound="ManufacturerListDropDownList_DataBound">
                    </asp:DropDownList>
                    <asp:CompareValidator ErrorMessage="You must select a manufacturer." ControlToValidate="ManufacturerListDropDownList"
                        runat="server" Display="Dynamic" Text="*" Operator="NotEqual" ValueToCompare="0" />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    Player Cost:
                </td>
                <td>
                    <asp:TextBox ID="PlayerCostTextBox" runat="server"></asp:TextBox>
                    <asp:RegularExpressionValidator ErrorMessage="You must specify the cost as a decimal."
                        ControlToValidate="PlayerCostTextBox" runat="server" Text="*" Display="Dynamic"
                        ValidationExpression="^\d+(\.\d\d)" />
                    <asp:RequiredFieldValidator ErrorMessage="You must enter a cost." ControlToValidate="PlayerCostTextBox"
                        runat="server" Text="*" Display="Dynamic" />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    Player Storage:
                </td>
                <td>
                    <asp:TextBox ID="PlayerStorageTextBox" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ErrorMessage="You must enter a storage type." ControlToValidate="PlayerStorageTextBox"
                        runat="server" Text="*" Display="Dynamic" />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    Supported Formats:
                </td>
                <td>
                    <asp:CheckBoxList ID="FormatCheckBoxList" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                    </asp:CheckBoxList>
                    <asp:CustomValidator ErrorMessage="You must select at least one format." runat="server"
                        Text="*" Display="Dynamic" OnServerValidate="Unnamed6_ServerValidate" />
                </td>
            </tr>
            <tr>
                <td class="style3">
                    <asp:Button ID="UpdateButton" runat="server" Text="Update Player" 
                        OnClick="UpdateButton_Click" />
                </td>
                <td>
                    <asp:Button ID="ReturnButton" runat="server" Text="Return To Players List" OnClick="ReturnButton_Click"
                        CausesValidation="False" />
                </td>
            </tr>
            <tr>
                <td class="style3">
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

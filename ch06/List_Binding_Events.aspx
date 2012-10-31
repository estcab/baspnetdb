<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que cargamos la pagina llamamos al a bbdd para rellenar la lista
        if (!Page.IsPostBack)
        {
            string cadena =
                ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(cadena))
            {
                SqlCommand cmd = new SqlCommand
                    ("SELECT ManufacturerID, ManufacturerName FROM Manufacturer", conn);

                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    ManufacturesList.DataSource = reader;
                    ManufacturesList.DataBind();
                }
            }
        }
    }

    // Cuando se produce un post-back recuperamos la lista de reproductores asociados al 
    // fabricante seleccionado
    protected void ManufacturesList_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ManufacturesList.SelectedItem.Value != "-1")
        {
            string cadena = 
                ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

            string playersQuery =
                "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage" +
                " FROM Player WHERE (PlayerManufacturerID = @ManufacturerID)";

            using (SqlConnection conn = new SqlConnection(cadena))
            {
                SqlCommand cmd = new SqlCommand(playersQuery, conn);

                cmd.Parameters.Add("@ManufacturerID", System.Data.SqlDbType.Int);
                cmd.Parameters["@ManufacturerID"].Value = ManufacturesList.SelectedValue;

                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    PlayersGrid.DataSource = reader;
                    PlayersGrid.DataBind();
                }
            }
        }
        else
        {
            // Limpiamos el GridView
            PlayersGrid.DataSource = null;
            PlayersGrid.DataBind();
        }

    }

    // Despues de que se produzca el enlace de datos del DropDownList
    protected void ManufacturesList_DataBound(object sender, EventArgs e)
    {
        // Creamos un nuevo elemento 
        ListItem li = new ListItem("please select...", "-1");
        ManufacturesList.Items.Insert(0, li);
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>List Binding with Events to a DataReader</title>
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
        <%--Configuramos el DropDownList para mostrar la lista de fabricantes--%>
        <table class="style1">
            <tr>
                <td style="vertical-align: top">
                    <asp:DropDownList ID="ManufacturesList" runat="server" AutoPostBack="true" DataTextField="ManufacturerName"
                        DataValueField="ManufacturerID" OnSelectedIndexChanged="ManufacturesList_SelectedIndexChanged"
                        OnDataBound="ManufacturesList_DataBound">
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:GridView ID="PlayersGrid" runat="server">
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

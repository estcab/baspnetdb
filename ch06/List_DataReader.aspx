<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string cadena =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(cadena))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;

            conn.Open();

            // La primera vez que cargamos la pagina llamamos al a bbdd para rellenar la lista
            if (!Page.IsPostBack)
            {
                cmd.CommandText = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    ManufacturesList.DataSource = reader;
                    ManufacturesList.DataBind();
                }
            }
            // Cuando se produce un post-back recuperamos la lista de reproductores asociados al 
            // fabricante seleccionado
            else
            {                
                cmd.CommandText = "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage" +
                                  " FROM Player WHERE (PlayerManufacturerID = @ManufacturerID)";
                
                cmd.Parameters.Add("@ManufacturerID", System.Data.SqlDbType.Int);
                cmd.Parameters["@ManufacturerID"].Value = ManufacturesList.SelectedValue;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    PlayersGrid.DataSource = reader;
                    PlayersGrid.DataBind();                    
                }
            }
        }




    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>List Binding to a DataReader</title>
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
                        DataValueField="ManufacturerID">
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

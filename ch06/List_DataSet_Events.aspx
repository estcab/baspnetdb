<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que cargamos la pagina llamamos al a bbdd para rellenar la lista
        if (!Page.IsPostBack)
        {
            // Creamos la consulta que recupera la lista de fabricantes
            string commandText = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

            // Rellenamos el DataSet
            DataSet ds = BuildDataSet(commandText, "Manufacturer");

            // Configuramos el DropDownList
            ManufacturesList.DataSource = ds;
            ManufacturesList.DataMember = "Manufacturer";
            ManufacturesList.DataBind();

            // Configuramos el RadioButtonList
            RadioButtonList1.DataSource = ds;
            RadioButtonList1.DataMember = "Manufacturer";
            RadioButtonList1.DataBind();
        }

    }

    private DataSet BuildDataSet(string commandText, string tableName)
    {
        DataSet ds = new DataSet();

        string cadena = ConfigurationManager
                        .ConnectionStrings["PlayersConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(cadena))
        using (SqlCommand cmd = new SqlCommand(commandText, conn))
        {
            // Creamos el DataAdapter
            SqlDataAdapter da = new SqlDataAdapter(cmd);

            // Rellenamos el DataSet
            da.Fill(ds, tableName);
        }
        return ds;
    }

    // Cuando se produce un post-back recuperamos la lista de reproductores asociados al 
    // fabricante seleccionado
    protected void ManufacturesList_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ManufacturesList.SelectedItem.Value != "-1")
        {
            // Configuramos la consulta que recupera los reproductores para el fabricante seleccionado
            string playersQuery =
                "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage" +
                " FROM Player" +
                " WHERE PlayerManufacturerID = " + ManufacturesList.SelectedValue;

            // Configuramos el Grid
            PlayersGrid.DataSource = BuildDataSet(playersQuery, "Players");
            PlayersGrid.DataMember = "Players";
            PlayersGrid.DataBind();
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

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList1.SelectedItem.Value != "-1")
        {
            // Configuramos la consulta que recupera los reproductores para el fabricante seleccionado
            string playersQuery =
                "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage" +
                " FROM Player" +
                " WHERE PlayerManufacturerID = " + RadioButtonList1.SelectedValue;

            // Configuramos el Grid
            PlayersGrid.DataSource = BuildDataSet(playersQuery, "Players");
            PlayersGrid.DataMember = "Players";
            PlayersGrid.DataBind();
        }
        else
        {
            // Limpiamos el GridView
            PlayersGrid.DataSource = null;
            PlayersGrid.DataBind();
        }

    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>List Binding with Events to a DataSet</title>
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
                    <br />
                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" AutoPostBack="True" DataValueField="ManufacturerID"
                        DataTextField="ManufacturerName" 
                        onselectedindexchanged="RadioButtonList1_SelectedIndexChanged">
                    </asp:RadioButtonList>
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

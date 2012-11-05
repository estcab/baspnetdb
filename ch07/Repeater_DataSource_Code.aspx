<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que se carga la pagina
        if (!Page.IsPostBack)
        {
            // Recuperamos el parametro de la query string
            if (!string.IsNullOrEmpty(Request.QueryString["ManufacturerID"]))
            {
                int manufacturerID = int.Parse(Request.QueryString["ManufacturerID"]);
                string connString = ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;
                string select = "SELECT [PlayerName], [PlayerCost], [PlayerStorage]" +
                                " FROM [Player] WHERE ([PlayerManufacturerID] = @ManufacturerID)";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(select, conn))
                    {
                        cmd.Parameters.Add("@ManufacturerID", SqlDbType.Int);
                        cmd.Parameters["@ManufacturerID"].Value = manufacturerID;

                        conn.Open();
                        
                        SqlDataReader rd = cmd.ExecuteReader();

                        Repeater1.DataSource = rd;
                        Repeater1.DataBind();

                        rd.Close();
                    }
                }
                
            }
        }
    }
    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item 
            || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            // En el caso del DataReader la fila es de tipo DbDataRecord
            System.Data.Common.DbDataRecord objData = (System.Data.Common.DbDataRecord)e.Item.DataItem;
            
            // Enlazamos los datos de forma manual
            Label lblName = (Label)e.Item.FindControl("lblName");
            Label lblCost = (Label)e.Item.FindControl("lblCost");
            Image imgType = (Image)e.Item.FindControl("imgType");

            lblName.Text = objData["PlayerName"].ToString();
            lblCost.Text = string.Format("{0:n}", objData["PlayerCost"].ToString());

            string playerStorage = objData["PlayerStorage"].ToString();

            // En funcion  de tipo de almacenamiento utilizamos una imagen u otra
            if (playerStorage == "Hard Disk")
            {
                imgType.ImageUrl = "./images/disk.gif";
            }
            else
            {
                imgType.ImageUrl = "./images/solid.gif";
            }
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Binding a DataSource to a Repeater.</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Repeater ID="Repeater1" runat="server"
            onitemdatabound="Repeater1_ItemDataBound">
            <HeaderTemplate>
                <div style="background-color: Bisque">
                    <font size="+2">Players</font>
                </div>
                <hr style="color: blue" />
            </HeaderTemplate>
            <ItemTemplate>
                <table>
                    <tr>
                        <td rowspan="2">
                            <asp:Image ID="imgType" runat="server" />
                        </td>
                        <td>
                            <b>
                                <asp:Label ID="lblName" runat="server" Text="name" /></b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblCost" runat="server" Text="cost" />
                        </td>
                    </tr>
                </table>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    </form>
</body>
</html>

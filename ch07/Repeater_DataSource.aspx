<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item 
            || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            // Recuperamos la  fila actual
            DataRowView objData = (DataRowView)e.Item.DataItem;
            
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
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein"
            ProviderName="System.Data.SqlClient" 
            SelectCommand="SELECT [PlayerName], [PlayerCost], [PlayerStorage] FROM [Player] WHERE ([PlayerManufacturerID] = @PlayerManufacturerID)">
            
            <SelectParameters>
                <asp:QueryStringParameter Name="PlayerManufacturerID" 
                    QueryStringField="ManufacturerID"
                    Type="Int32" />
            </SelectParameters>

        </asp:SqlDataSource>
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1" 
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

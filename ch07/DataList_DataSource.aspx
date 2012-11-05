<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    // Enlazamos los datos de forma manual para un mayor control
    protected void DataList1_ItemDataBound(object sender, DataListItemEventArgs e)
    {   
        // Comprobamos que estamos enlazando un Item o AlternateItem
        if (e.Item.ItemType == ListItemType.Item 
            || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            // Recuperamos la fila actual
            DataRowView dataOjb = (DataRowView)e.Item.DataItem;
            
            // Recuperamos los controles del template
            Label lblName = (Label)e.Item.FindControl("lblName");
            Label lblCost = (Label)e.Item.FindControl("lblCost");
            Image imgType = (Image)e.Item.FindControl("imgType");
            
            // Enalzamos los datos
            lblName.Text = dataOjb["PlayerName"].ToString();
            lblCost.Text = string.Format("{0:c}", dataOjb["PlayerCost"].ToString());

            if (dataOjb["PlayerStorage"].ToString() == "Hard Disk")
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
    <title>Binding a DataSource to a DataList</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein"
            ProviderName="System.Data.SqlClient" SelectCommand="SELECT [PlayerName], [PlayerCost], [PlayerStorage] FROM [Player] ORDER BY [PlayerName]">
        </asp:SqlDataSource>
        <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1" RepeatColumns="3"
            RepeatDirection="Horizontal" onitemdatabound="DataList1_ItemDataBound">
            <ItemTemplate>
                <table bgcolor="Ivory">
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
            <AlternatingItemTemplate>
                <table bgcolor="Azure">
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
            </AlternatingItemTemplate>
        </asp:DataList>
    </div>
    </form>
</body>
</html>

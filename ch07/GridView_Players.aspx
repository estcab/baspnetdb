<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // Vamos a personalizar la imagen en funcion de los  datos
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // Recuperamos la fila actual
            DataRowView data = (DataRowView)e.Row.DataItem;
            
            // Recuperamos el elemento Image para personalizar el archivo que utilizaremos
            Image imgType = (Image)e.Row.FindControl("imgType");
            
            // En funcion del valor PlayerStorage utilizamos un .jpg u otro.
            if (data["PlayerStorage"].ToString() == "Hard Disk")
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
    <title>Players in a GridView</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein"
            ProviderName="System.Data.SqlClient" SelectCommand="SELECT Player.PlayerID, Player.PlayerName, Manufacturer.ManufacturerName , 
                                  Player.PlayerCost, Player.PlayerStorage 
                           FROM Player INNER JOIN Manufacturer 
                           ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID
                           WHERE Player.PlayerManufacturerID = @ManufacturerID">
            <SelectParameters>
                <asp:QueryStringParameter Name="ManufacturerID" 
                    QueryStringField="ManufacturerID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" CellPadding="4" 
            AutoGenerateColumns="False" onrowdatabound="GridView1_RowDataBound" 
            ForeColor="#333333" GridLines="None" AllowPaging="True" 
            AllowSorting="True" PageSize="5">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="PlayerID" SortExpression="PlayerID" HeaderText="PlayerID" />
                <asp:BoundField DataField="PlayerName" SortExpression="PlayerName" HeaderText="Name" />
                <asp:BoundField DataField="ManufacturerName" SortExpression="ManufacturerName" HeaderText="Manufacturer" />
                <asp:BoundField DataField="PlayerCost"  HeaderText="PlayerCost" DataFormatString="{0:C}" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Image ID="imgType" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EditRowStyle BackColor="#2461BF" />
            <FooterStyle BackColor="#507CD1" ForeColor="White" Font-Bold="True" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#EFF3FB" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#F5F7FB" />
            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
            <SortedDescendingCellStyle BackColor="#E9EBEF" />
            <SortedDescendingHeaderStyle BackColor="#4870BE" />
        </asp:GridView>
    </div>
    </form>
</body>
</html>

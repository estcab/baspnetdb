<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // Si el evento ha sdo generado por el link  'View Players'
        if (e.CommandName == "Players")
        {
            // Obtenemos el numero de fila
            int index = Convert.ToInt32(e.CommandArgument);
            // Obtenemos el ID del fabricante
            string manufacturerID = GridView1.DataKeys[index].Value.ToString();            
            // Dirigimos la respuesta a la pagina de reproductores
            Response.Redirect("./GridView_Players.aspx?ManufacturerID=" + manufacturerID);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manufacturers in a GridView</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein" 
            ProviderName="System.Data.SqlClient" 
            SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer]">
        </asp:SqlDataSource>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            CellPadding="4" DataKeyNames="ManufacturerID" DataSourceID="SqlDataSource1" 
            ForeColor="#333333" GridLines="None" onrowcommand="GridView1_RowCommand">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="ManufacturerID" HeaderText="ManufacturerID" 
                    InsertVisible="False" ReadOnly="True" SortExpression="ManufacturerID" />
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" 
                    SortExpression="ManufacturerName" />
                <asp:ButtonField CommandName="Players" Text="View Players" />
            </Columns>
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>

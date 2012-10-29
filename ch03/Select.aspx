<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        DropDownList1.Items.Insert(0,
            new ListItem("-- All Manufacturers --", "0"));
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SELECT</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:PlayersConnectionString %>"             
            
            
            SelectCommand="SELECT Player.PlayerName AS Player, Manufacturer.ManufacturerName AS Manufacturer FROM Player INNER JOIN Manufacturer ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID WHERE (Manufacturer.ManufacturerID = @ManufacturerID) OR (@ManufacturerID = 0) ORDER BY Manufacturer, Player">
            <SelectParameters>
                <asp:ControlParameter ControlID="DropDownList1" Name="ManufacturerID" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
            ConnectionString="<%$ ConnectionStrings:PlayersConnectionString %>" 
            SelectCommand="SELECT [ManufacturerID], [ManufacturerName] FROM [Manufacturer] ORDER BY [ManufacturerName]">
        </asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" 
            DataSourceID="SqlDataSource2" DataTextField="ManufacturerName" 
            DataValueField="ManufacturerID" ondatabound="DropDownList1_DataBound">
        </asp:DropDownList>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" CellPadding="4" ForeColor="#333333" 
            GridLines="None">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="Player" HeaderText="Player" 
                    SortExpression="Player" />
                <asp:BoundField DataField="Manufacturer" 
                    HeaderText="Manufacturer" SortExpression="Manufacturer" />
                    
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

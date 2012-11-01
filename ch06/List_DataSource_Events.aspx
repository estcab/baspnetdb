<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void ManufacturesList_DataBound(object sender, EventArgs e)
    {
        // Creamos un nuevo elemento 
        ListItem li = new ListItem("please select...", "-1");
        ManufacturesList.Items.Insert(0, li);
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>List Binding with Events to a SqlDataSource.</title>
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
                    <asp:DropDownList ID="ManufacturesList" runat="server" AutoPostBack="True" DataTextField="ManufacturerName"
                        DataValueField="ManufacturerID"
                        OnDataBound="ManufacturesList_DataBound" DataSourceID="SqlDataSource1">
                    </asp:DropDownList><asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                        ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein" 
                        ProviderName="System.Data.SqlClient" 
                        SelectCommand="SELECT [ManufacturerName], [ManufacturerID] FROM [Manufacturer] ORDER BY [ManufacturerName]">
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                        ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein" 
                        ProviderName="System.Data.SqlClient" 
                        SelectCommand="SELECT [PlayerID], [PlayerName], [PlayerManufacturerID], [PlayerCost], [PlayerStorage] FROM [Player] WHERE ([PlayerManufacturerID] = @PlayerManufacturerID) ORDER BY [PlayerName]">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ManufacturesList" Name="PlayerManufacturerID" 
                                PropertyName="SelectedValue" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    
                </td>
                <td>
                    <asp:GridView ID="PlayersGrid" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="PlayerID" DataSourceID="SqlDataSource2">
                        <Columns>
                            <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" 
                                InsertVisible="False" ReadOnly="True" SortExpression="PlayerID" />
                            <asp:BoundField DataField="PlayerName" HeaderText="PlayerName" 
                                SortExpression="PlayerName" />
                            <asp:BoundField DataField="PlayerManufacturerID" 
                                HeaderText="PlayerManufacturerID" SortExpression="PlayerManufacturerID" />
                            <asp:BoundField DataField="PlayerCost" HeaderText="PlayerCost" 
                                SortExpression="PlayerCost" />
                            <asp:BoundField DataField="PlayerStorage" HeaderText="PlayerStorage" 
                                SortExpression="PlayerStorage" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

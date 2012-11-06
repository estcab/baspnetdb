<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Players</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein" 
            ProviderName="System.Data.SqlClient" 
            SelectCommand="SELECT [PlayerID], [PlayerName], [PlayerCost] FROM [Player]">
        </asp:SqlDataSource>
        <asp:HyperLink ID="HyperLink1" runat="server" 
            NavigateUrl="~/Player_Insert.aspx">Add Player</asp:HyperLink>

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="PlayerID" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" 
                    InsertVisible="False" ReadOnly="True" SortExpression="PlayerID" />
                <asp:BoundField DataField="PlayerName" HeaderText="PlayerName" 
                    SortExpression="PlayerName" />
                <asp:BoundField DataField="PlayerCost" HeaderText="PlayerCost" 
                    SortExpression="PlayerCost" DataFormatString="{0:C}" />
            </Columns>
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>

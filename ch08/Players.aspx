<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // Verificamos que el control que ha generado el evento es  el boton 'delete'
        if (e.CommandName == "DeletePlayer")
        {
            // Obtenemos el numero de fila que  ha generado  el  evento
            int index = Convert.ToInt32(e.CommandArgument);
            // Con este indice obtenemos la id  del  reproductor que queremos borrar
            string playerID = GridView1.DataKeys[index].Value.ToString();
            
            // Redirigimos la respuesta a la pagina de confirmacion
            Response.Redirect("./Player_Delete.aspx?PlayerID=" + playerID);
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Players</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein"
            ProviderName="System.Data.SqlClient" SelectCommand="SELECT [PlayerID], [PlayerName], [PlayerCost] FROM [Player]">
        </asp:SqlDataSource>
        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Player_Insert.aspx">Add Player</asp:HyperLink>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="PlayerID"
            DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="PlayerID" HeaderText="PlayerID" InsertVisible="False"
                    ReadOnly="True" SortExpression="PlayerID" />
                <asp:BoundField DataField="PlayerName" HeaderText="PlayerName" SortExpression="PlayerName" />
                <asp:BoundField DataField="PlayerCost" HeaderText="PlayerCost" SortExpression="PlayerCost"
                    DataFormatString="{0:C}" />
                <asp:ButtonField CommandName="DeletePlayer" Text="Delete" ButtonType="Button" />
            </Columns>
        </asp:GridView>
    </div>
    </form>
</body>
</html>

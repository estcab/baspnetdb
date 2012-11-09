<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        // Recuperamos la clave primaria de la fila seleccionada
        int index = Convert.ToInt32( e.CommandArgument);
        string manufacturerID = GridView1.DataKeys[index].Value.ToString();
        
        
        // Respondemos al comando Edit
        if (e.CommandName == "EditManufacturer")
        {
            // Redirigimos a la pagina de Edicion pasando la id
            Response.Redirect("~/Manufacturer_Edit.aspx?ManufacturerID=" + manufacturerID);
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manufacturers</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="Data Source=ESTCAB-959648EC\SQLEXPRESS;Initial Catalog=Players;Persist Security Info=True;User ID=band;Password=letmein" 
            ProviderName="System.Data.SqlClient" 
            SelectCommand="SELECT [ManufacturerID], [ManufacturerName], [ManufacturerCountry] FROM [Manufacturer]">
        </asp:SqlDataSource>
        <asp:HyperLink ID="HyperLink1" runat="server" 
            NavigateUrl="~/Manufacturer_Edit.aspx">Add Manufacturer</asp:HyperLink>
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="ManufacturerID" DataSourceID="SqlDataSource1" 
            onrowcommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="ManufacturerID" HeaderText="ManufacturerID" 
                    InsertVisible="False" ReadOnly="True" SortExpression="ManufacturerID" />
                <asp:BoundField DataField="ManufacturerName" HeaderText="ManufacturerName" 
                    SortExpression="ManufacturerName" />
                <asp:BoundField DataField="ManufacturerCountry" 
                    HeaderText="ManufacturerCountry" SortExpression="ManufacturerCountry" />
                <asp:ButtonField ButtonType="Button" CommandName="EditManufacturer" Text="Edit" />
            </Columns>
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>

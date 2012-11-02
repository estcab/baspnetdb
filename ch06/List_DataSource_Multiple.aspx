<%@ Page Language="C#" %>

<%@ Import Namespace="System.Text" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {
        // Construimos la consulta de reproductores
        StringBuilder Query = new StringBuilder(
            "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage FROM Player WHERE PlayerManufacturerID IN (");
        bool gotResult = false;
        for (int i = 0; i < ListBox1.Items.Count; i++)
        {
            if (ListBox1.Items[i].Selected)
            {
                if (gotResult == true) Query.Append(",");
                Query.Append(ListBox1.Items[i].Value);
                gotResult = true;
            }
        }
        Query.Append(")");
        // Si hay elementos seleccionados ejecutamos la consulta
        if (gotResult)
        {
            // set the correct SelectCommand
            SqlDataSource2.SelectCommand = Query.ToString();
        }
        else
        {
            // clear the GridView
            SqlDataSource2.SelectCommand = null;
        }


    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Multiple Selection Using a SqlDataSource.</title>
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
        <table class="style1">
            <tr>
                <td>
                    <asp:ListBox ID="ListBox1" runat="server" DataTextField="ManufacturerName" DataValueField="ManufacturerID"
                        SelectionMode="Multiple" DataSourceID="SqlDataSource1"></asp:ListBox>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PlayersConnectionString %>"
                        SelectCommand="SELECT ManufacturerID, ManufacturerName FROM Manufacturer"></asp:SqlDataSource>
                    <br />
                    <asp:Button ID="Button1" runat="server" Text="Select" OnClick="Button1_Click" />
                </td>
                <td>
                    <asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource2">
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:PlayersConnectionString %>">
                    </asp:SqlDataSource>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Text" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string conStr = ConfigurationManager
                .ConnectionStrings["PlayersConnectionString"].ConnectionString;

            string manQuery = "SELECT ManufacturerID, ManufacturerName FROM Manufacturer";

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand(manQuery, con))
            {
                con.Open();

                ListBox1.SelectionMode = ListSelectionMode.Multiple;

                ListBox1.DataSource = cmd.ExecuteReader();

                ListBox1.DataValueField = "ManufacturerID";
                ListBox1.DataTextField = "ManufacturerName";

                ListBox1.DataBind();
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string conStr = ConfigurationManager
            .ConnectionStrings["PlayersConnectionString"].ConnectionString;

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("", con))
        {
            con.Open();

            // Construimos la  consulta de forma dinamica
            StringBuilder Query = new StringBuilder(
                         "SELECT PlayerID, PlayerName, PlayerManufacturerID, PlayerCost, PlayerStorage");
            Query.Append(" FROM Player WHERE PlayerManufacturerID IN (");

            bool gotResult = false;

            // Incluimos todos  los ID seleccionados
            for (int i = 0; i < ListBox1.Items.Count; i++)
            {
                if (ListBox1.Items[i].Selected)
                {
                    if (gotResult) Query.Append(", ");
                    Query.Append(ListBox1.Items[i].Value);
                    gotResult = true;                    
                }
            }
            // Terminamos la consulta                                            
            Query.Append(")");
            
            
            // Si hay algun  fabricante seleccionado ejecutamos la consulta
            if (gotResult)
            {
                cmd.CommandText = Query.ToString();
                
                GridView1.DataSource = cmd.ExecuteReader();
                GridView1.DataBind();
            }
            // Sino,  limpiamos el grid
            else
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
            }
        }
    }
    
    
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Selecciones Multiples con DataReader</title>
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
                    <asp:ListBox ID="ListBox1" runat="server"></asp:ListBox>
                    <br />
                    <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
                </td>
                <td>
                    <asp:GridView ID="GridView1" runat="server">
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>

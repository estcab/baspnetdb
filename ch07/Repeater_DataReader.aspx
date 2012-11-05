<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>

<%--Para poder 'castear' las filas del DataReader a DbDataRecord--%>
<%@ Import Namespace ="System.Data.Common" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que se carga la pagina cargamos los datos de la bbdd
        if (!Page.IsPostBack)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

            string manufacturersQuery = "SELECT ManufacturerID, ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite" +
                                        " FROM Manufacturer";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(manufacturersQuery, conn))
                {
                    conn.Open();

                    SqlDataReader rd = cmd.ExecuteReader();

                    Repeater1.DataSource = rd;
                    Repeater1.DataBind();

                    rd.Close();

                }
            }
        }
    }

    protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        // Seria mas facil a  traves de un HyperLink; este codigo es para demostrar  el ItemCommand
        if (e.CommandName == "Players")
        {
            Response.Redirect(
                "./Repeater_DataSource.aspx?ManufacturerID="
                + e.CommandArgument);
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Binding a DataReader to a Repeater</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Repeater ID="Repeater1" runat="server" 
            onitemcommand="Repeater1_ItemCommand">
            <HeaderTemplate>
                <div style="background-color: Bisque">
                    <font size="+2">Manufacturers</font>
                </div>
                <hr style="color: blue" />
            </HeaderTemplate>
            <ItemTemplate>
                <div style="background-color: Ivory">
                    <b>
                        <asp:Label ID="lblName" runat="server" Text='<%# Eval("[ManufacturerName]") %>'>
                        </asp:Label>
                    </b>
                    <br />
                    Country:
                    <asp:Label ID="lblCountry" runat="server" Text='<%# Eval("[ManufacturerCountry]") %>'>
                    </asp:Label>
                    <br />
                    Email:
                    <%--Para mejorar el rendimiento, utilizariamos el casting directo
                    <%# ((DbDataRecord)Container.DataItem)["ManufacturerEmail"]%>--%>
                    <asp:HyperLink ID="lnkEmail" runat="server" NavigateUrl='<%# Eval("[ManufacturerEmail]", "mailto:{0}") %>'
                        Text='<%# Eval("[ManufacturerEmail]") %>'>
                    </asp:HyperLink>
                    <br />
                    Website:
                    <asp:HyperLink ID="lnkWebsite" runat="server" NavigateUrl='<%# Eval("[ManufacturerWebsite]") %>'>
                        <%# Eval("[ManufacturerWebsite]") %>
                    </asp:HyperLink>
                    <br />

                    <asp:HyperLink ID="ViewPlayers" runat="server" 
                                   NavigateUrl='<%# Eval("[ManufacturerID]" ,"./Repeater_DataSource_Code.aspx?ManufacturerID={0}") %>'>
                                   View Players                        
                    </asp:HyperLink>
                    <%-- <asp:LinkButton ID="btnProducts" runat="server" 
                                CommandName="Players" Text="View Players"
                                CommandArgument='<%# Eval("[ManufacturerID]") %>' />--%>
                        
                </div>
            </ItemTemplate>
            <SeparatorTemplate>
                <hr style="color: blue" />
            </SeparatorTemplate>
            <AlternatingItemTemplate>
                <div style="background-color: Azure">
                    <b>
                        <asp:Label ID="lblName" runat="server" Text='<%# Eval("[ManufacturerName]") %>'>
                        </asp:Label>
                    </b>
                    <br />
                    Country:
                    <asp:Label ID="lblCountry" runat="server" Text='<%# Eval("[ManufacturerCountry]") %>'>
                    </asp:Label>
                    <br />
                    Email:
                    <asp:HyperLink ID="lnkEmail" runat="server" NavigateUrl='<%# Eval("[ManufacturerEmail]", "mailto:{0}") %>'
                        Text='<%# Eval("[ManufacturerEmail]") %>'>
                    </asp:HyperLink>
                    <br />
                    Website:
                    <asp:HyperLink ID="lnkWebsite" runat="server" NavigateUrl='<%# Eval("[ManufacturerWebsite]") %>'>
                        <%# Eval("[ManufacturerWebsite]") %>
                    </asp:HyperLink>
                    <br />
                    <asp:LinkButton ID="btnProducts" runat="server" CommandName="Players" Text="View Players"
                        CommandArgument='<%# Eval("[ManufacturerID]") %>' />
                </div>
            </AlternatingItemTemplate>
            <FooterTemplate>
                <hr style="color: blue" />
                <div style="background-color: Bisque">
                    <br />
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
    </form>
</body>
</html>

<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">   

    protected void Page_Load(object sender, EventArgs e)
    {
        // La primera vez que se carga la pagina
        if (!Page.IsPostBack)
        {
            // Recuperamos la cadena de conexion del archivo web.config
            string connecitionString =
                ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

            // Creamos el objeto Connection
            SqlConnection conn = new SqlConnection(connecitionString);

            // Creamos la consulta del ddl
            string query = "SELECT ManufacturerID, ManufacturerName " +
                           "FROM Manufacturer " +
                           "ORDER BY ManufacturerID";

            // Creamos el comando
            SqlCommand cmd = new SqlCommand(query, conn);

            try
            {
                // Abrimos la conexion
                conn.Open();

                // Ejecutamos el comando y  rellenamos el DropDownList
                DropDownList1.DataSource = cmd.ExecuteReader();
                DropDownList1.DataTextField = "ManufacturerName";
                DropDownList1.DataValueField = "ManufacturerID";
                DropDownList1.DataBind();

                // Forzamos la primera carga de datos
                DropDownList1_SelectedIndexChanged(null, null);
            }
            catch (Exception ex)
            {
                // Guardamos un registro de errores
                StreamWriter sw = File.AppendText(Server.MapPath("~/Error.log"));
                sw.WriteLine(ex.Message);
                sw.Close();           
                
                // volvemos a lanzar el error para verlo en IE
                throw (ex);
            }
            finally
            {
                // Cerramos la conexion
                conn.Close();
            }
        }
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Recuperamos la cadena de conexion del archivo web.config
        string connecitionString =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Creamos el objeto Connection
        SqlConnection conn = new SqlConnection(connecitionString);

        /*  Alternativa 1
        // Riesgo significativo de sufrir un ataque 'SQL Injection'
        // Creamos la consulta base
        string query = "SELECT Player.PlayerName, Manufacturer.ManufacturerName " +
                       "FROM Player INNER JOIN Manufacturer " +
                       "ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID";

        // Añadimos el filtro ...
        string filter = DropDownList1.SelectedValue;
        if (filter != "0")
        {
            query += " WHERE Player.PlayerManufacturerID = " + filter;
        }

        // ...y el orden
        query += " ORDER BY Player.PlayerName";
        
        */

        // Alternativa 2, mas seguro: Utilizando parametros
        string query = "SELECT Player.PlayerName, Manufacturer.ManufacturerName " +
                       "FROM Player INNER JOIN Manufacturer " +
                       "ON Player.PlayerManufacturerID = Manufacturer.ManufacturerID " +
                       "WHERE Player.PlayerManufacturerID = @ManufacturerID " +
                       "OR @ManufacturerID = 0 " +
                       " ORDER BY Player.PlayerName";


        // Creamos el comando
        SqlCommand selectCommand = new SqlCommand(query, conn);

        // Añadimos el parametro
        SqlParameter manufacturerID = new SqlParameter("@ManufacturerID", SqlDbType.Int);
        manufacturerID.Value = DropDownList1.SelectedValue;

        selectCommand.Parameters.Add(manufacturerID);


        // Añadimos otro comando para contar el  numero de resultados
        string countQuery = "SELECT COUNT(*) FROM Player " +
                            "WHERE @ManufacturerID = 0 OR PlayerManufacturerID = @ManufacturerID";

        SqlCommand countCommand = new SqlCommand(countQuery, conn);

        SqlParameter countParamerter = new SqlParameter("@ManufacturerID", SqlDbType.Int);
        countParamerter.Value = DropDownList1.SelectedValue;

        countCommand.Parameters.Add(countParamerter);

        // Abrimos la conexion
        conn.Open();

        // Consultamos el  numero de resultados
        countLabel.Text = Convert.ToString(countCommand.ExecuteScalar());

        // Ejecutamos el comando y  mostramos los datos            
        GridView1.DataSource = selectCommand.ExecuteReader();
        GridView1.DataBind();



        // Cerramos la conexion
        conn.Close();
    }

    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        DropDownList1.Items.Insert(0,
            new ListItem("-- All Manufactures --", "0"));
    }
    
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Displaying Data with SqlClient</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
            OnDataBound="DropDownList1_DataBound">
        </asp:DropDownList>
        Players found:
        <asp:Label ID="countLabel" runat="server"></asp:Label>
        <asp:GridView ID="GridView1" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" />
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

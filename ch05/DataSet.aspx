<%@ Page Language="C#" %>

<%--Espacios de nombres necesarios --%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // Creamos la conexion
        SqlConnection conn = new SqlConnection();
        
        // Creamos el DataSet, que contendra los datos
        DataSet ds = new DataSet();

        // Recuperamos la cadena de conexion
        string connectionString =
            ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Configuramos la conexion  para que apunte a la bbdd adecuada
        conn.ConnectionString = connectionString;

        // Creamos la consulta que recuperara todos los datos de la tabla Manufacturer
        string manufacturersQuery =
            "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite" +
            " FROM Manufacturer ORDER BY ManufacturerName";

        // Creamos el comando que enviaremos a la bbdd
        SqlCommand cmd = new SqlCommand(manufacturersQuery, conn);
        
        // Creamos el DataAdapter que se comunicara con la BBDD y rellenara el DataSet
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        
        // Rellenamos el DataSet
        da.Fill(ds, "Manufactures");
        
        // Recorremos el DataSet creando objetos Manufacturer y mostrandolos en la pagina
        DataTable ManufacturesTable = ds.Tables["Manufactures"];
        
        for (int i = 0; i < ManufacturesTable.Rows.Count -1; i++)
        {
            DataRow ManufacturerRow = ManufacturesTable.Rows[i];
            
            Manufacturer man = new Manufacturer 
            {
                Name = Convert.ToString( ManufacturerRow["ManufacturerName"]),
                Country = Convert.ToString(ManufacturerRow["ManufacturerCountry"]),
                Email = Convert.ToString(ManufacturerRow["ManufacturerEmail"]),
                Website = Convert.ToString(ManufacturerRow["ManufacturerWebsite"])
            };

            resultLabel.Text += man.ToString() + "<br />";
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Recorrido de un DataSet</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="resultLabel" Text="" runat="server" />
    </div>
    </form>
</body>
</html>

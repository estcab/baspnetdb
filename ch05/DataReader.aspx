<%@ Page Language="C#" %>

<%--Importamos el proveedor  de datos para Sql  Server--%>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
                      "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        // Creamos la conexion
        SqlConnection con = new SqlConnection();

        // Creamos un codigo 'a prueba de fallos'
        try
        {
            // Recuperamos la cadena de conexion
            string connectionString =
                ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

            // Configuramos la conexion  para que apunte a la bbdd adecuada
            con.ConnectionString = connectionString;

            // Creamos la consulta que recuperara todos los datos de la tabla Manufacturer
            string manufacturersQuery =
                "SELECT ManufacturerName, ManufacturerCountry, ManufacturerEmail, ManufacturerWebsite" +
                " FROM Manufacturer ORDER BY ManufacturerName";

            // Creamos el comando que enviaremos a la bbdd
            SqlCommand cmd = new SqlCommand(manufacturersQuery, con);

            // Abrimos la conexion 
            con.Open();

            // Ejecutamos el comando que nos devuelve el DataReader
            SqlDataReader reader = cmd.ExecuteReader();

            // Si  la consulta devuelve resultados
            if (reader.HasRows)
            {
                // Mientras haya informacion leemos el DataReader

                while (reader.Read() == true)
                {
                    // Creamos el objeto Manufacturer y le asinamos valores
                    Manufacturer man = new Manufacturer
                    {
                        Name = Convert.ToString(reader["ManufacturerName"]),
                        Country = Convert.ToString(reader["ManufacturerCountry"]),
                        Email = reader.GetString(reader.GetOrdinal("ManufacturerEmail")),
                        Website = reader.GetString(reader.GetOrdinal("ManufacturerWebsite"))
                    };

                    // Mostramos el resultado
                    resultLabel.Text += man.ToString() + "<br />";
                }
            }
            else
            {
                resultLabel.Text = "No se han obtenido resultados.";
            }



            //Cerramos el DataReader
            reader.Close();
        }
        finally
        {
            // Finalmente, cerramos la conexion  
            con.Close();
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Recorrido de un DataReader</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="resultLabel" Text="" runat="server" />
    </div>
    </form>
</body>
</html>

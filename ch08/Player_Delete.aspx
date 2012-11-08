<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        // Volvemos a la lista
        Response.Redirect("./Players.aspx");
    }

    // Evento que borra el reproductor seleccionado
    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        // Recuperamos la cadena de conexion del web.config
        string connString = ConfigurationManager.ConnectionStrings["PlayersConnectionString"].ConnectionString;

        // Sentencias SQL que borra el reproductor y sus formatos
        string delQuery = "DELETE FROM WhatPlaysWhatFormat WHERE WPWFPlayerID = @PlayerID;" +
                          " DELETE FROM Player WHERE PlayerID = @PlayerID";

        // Creamos la conexion y el comando
        SqlConnection con = new SqlConnection(connString);
        SqlCommand cmd = new SqlCommand(delQuery, con);
        
        try
        {            
            // añadimos el parametro
            cmd.Parameters.AddWithValue("PlayerID", Request.QueryString["PlayerID"]);

            // Abrimos la  conexion  y ejecutamos la consulta
            con.Open();

            cmd.ExecuteNonQuery();

            // Mostramos el resultado
            QueryResult.Text = "Delete of player '" +
                Request.QueryString["PlayerID"] + "' was successful";

            // Deshabilitamos el boton
            SubmitButton.Enabled = false;

        }
        catch (Exception ex)
        {
            QueryResult.Text = "An error has occurred: " + ex.Message;
        }
        finally
        {
            con.Close();
        }

    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DELETE Player</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <p>
            Esta seguro de que quiere eliminar&nbsp; este reproductor?
        </p>
        <p>
            <asp:Button ID="SubmitButton" runat="server" Text="Delete Player" OnClick="SubmitButton_Click" />
        </p>
        <p>
            <asp:Button ID="ReturnButton" runat="server" Text="Return To PlayerList" OnClick="ReturnButton_Click" />
        </p>
        <p>
            <asp:Label ID="QueryResult" Text="" runat="server" />
        </p>
    </div>
    </form>
</body>
</html>

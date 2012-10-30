using System.Text;

/// <summary>
/// Summary description for Manufacturer
/// </summary>
public class Manufacturer
{

    public string Name { get; set; }
    public string Country { get; set; }
    public string Email { get; set; }
    public string Website { get; set; }

    public Manufacturer()
    {
    }

    public override string ToString()
    {
        StringBuilder sb = new StringBuilder();
        
        sb.Append("Name: ");
        sb.Append(this.Name);
        sb.Append("<BR/>");
        
        sb.Append("Country: ");
        sb.Append(this.Country);
        sb.Append("<BR/>");
        
        sb.Append("Email: ");
        sb.Append("<a href='mailto:");
        sb.Append(this.Email);
        sb.Append("'>");
        sb.Append(this.Email);
        sb.Append("</a>");
        sb.Append("<BR/>");
        
        sb.Append("Website: ");
        sb.Append("<a href='");
        sb.Append(this.Website);
        sb.Append("'>");
        sb.Append(this.Website);
        sb.Append("</a>");
        sb.Append("<BR/>");
        
        
        return (sb.ToString());
    }
}
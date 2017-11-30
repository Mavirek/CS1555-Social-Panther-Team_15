import java.sql.*;  //import the file containing definitions for the parts
import java.text.ParseException;
import java.util.*;
public class SocialPanther
{
	private static Connection connection; //used to hold the jdbc connection to the DB
    private Statement statement; //used to create an instance of the connection
    private PreparedStatement prepStatement; //used to create a prepared statement, that will be later reused
    private ResultSet resultSet; //used to hold the result of your query (if one
    // exists)
    private String query;  //this will hold the query we are using
	private static Scanner s;
	private static int userID;
	private static String name;
	private static String pass;
	private static String email;
  public static void main(String args[]) throws SQLException
  {
	userID=1;
	String username, password;
	username = "alp170"; //This is your username in oracle
	password = "4047005"; //This is your password in oracle
	
	try{
		// Register the oracle driver.  
		DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
		
		//This is the location of the database.  This is the database in oracle
		//provided to the class
		String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass"; 
		
		//create a connection to DB on class3.cs.pitt.edu
		connection = DriverManager.getConnection(url, username, password); 
		//SocialPanther socPan = new SocialPanther();
		s = new Scanner(System.in);
	}
	catch(Exception Ex)  {
		System.out.println("Error connecting to database.  Machine Error: " +
				   Ex.toString());
	}
	finally
	{
		connection.close();
	}
  }
  
  public void createUser()
  {
	try{
		connection.setAutoCommit(false);
		connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
		statement = connection.createStatement();
		System.out.print("Please enter your name: ");
		name = s.next();
		System.out.print("\nEnter your email: ");
		email = s.next();
		System.out.print("\nEnter a password: ");
		pass = s.next();
		System.out.print("\nEnter your date of birth (DD-MM-YYYY): ");
		String dob = s.next();
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd-MM-yyyy");
	    java.sql.Date date_reg = new java.sql.Date (df.parse(dob).getTime());
		prepStatement = connection.prepareStatement(query);
		query = "INSERT INTO PROFILE values(?,?,?,?,?,?)";
		prepStatement.setInt(1,userID);
		prepStatement.setString(2,name);
		prepStatement.setString(3,email);
		prepStatement.setString(4,pass);
		prepStatement.setDate(5,date_reg);
		prepStatement.setTimestamp(6,null);
		
		prepStatement.executeUpdate();
		userID++;
	}
	catch(SQLException sqle)
	{
		System.out.println("Error executing query - "+sqle.toString());
	}
	catch(ParseException e)
	{
		System.out.println("Error parsing date - "+e.toString());
	}
  }
  
  
}
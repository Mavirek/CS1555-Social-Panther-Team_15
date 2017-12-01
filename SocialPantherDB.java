import java.sql.*;  //import the file containing definitions for the parts
import java.util.*;
import java.text.ParseException;
public class SocialPantherDB
{
	private static Connection connection; //used to hold the jdbc connection to the DB
    private Statement statement; //used to create an instance of the connection
    private PreparedStatement prepStatement; //used to create a prepared statement, that will be later reused
    private ResultSet resultSet; //used to hold the result of your query (if one
    // exists)
    private String query;  //this will hold the query we are using
	private Timestamp lastLogin;
	private ArrayList<String> threeDegPath;

  public static void main(String args[]) throws SQLException
  {
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
  
  public int createUser(String userID, String name, String email, String pass, String dob)
  {
		int result=-1;
		try{
			//connection.setAutoCommit(false);
			//connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
			//statement = connection.createStatement();
			query = "INSERT INTO PROFILE values(?,?,?,?,?,NULL)";
			prepStatement = connection.prepareStatement(query);
			
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd-MM-yyyy");
			java.sql.Date date_reg = new java.sql.Date (df.parse(dob).getTime());
			
			prepStatement.setString(1,userID);
			prepStatement.setString(2,name);
			prepStatement.setString(3,email);
			prepStatement.setString(4,pass);
			prepStatement.setDate(5,date_reg);
			
			result=prepStatement.executeUpdate();
		}
		catch(ParseException pe)
		{
			System.out.println("Error parsing date");
		}
		catch(SQLException e)
		{
			System.out.println("Error creating user");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
		}
		return result;
  }
  
  public boolean login(String userID, String pass)
  {
	  try{
		  //connection.setAutoCommit(false);
		  //connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
		  //statement = connection.createStatement();
		  query = "SELECT password FROM PROFILE WHERE userID = ?";
		  prepStatement = connection.prepareStatement(query);
		  prepStatement.setString(1,userID);
		  resultSet = prepStatement.executeQuery();
		  resultSet.next(); //move cursor to the first row of resultSet
		  String dbPass = resultSet.getString("password");
		  
		  if(dbPass.equals(pass)) //login successful
		  {
			query = "SELECT lastLogin FROM PROFILE WHERE userID = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userID);
			resultSet = prepStatement.executeQuery();
			resultSet.next();
			lastLogin = resultSet.getTimestamp("lastLogin");
			return true;
		  }
		  else
			return false;
	  }
	  catch(SQLException e)
	  {
		System.out.println("Error logging in user "+userID);
		while(e!=null)
		{
			System.out.println("Message - "+e.getMessage());
			System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
			e=e.getNextException();
		}
	  }
	  return false;
  }
  
  public boolean initiateFriendship(String fromUser, String toUser)
  {
	    String toName = null;
		Scanner s;
	    try{
			s = new Scanner(System.in);
			query = "SELECT name FROM PROFILE WHERE userID = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,toUser);
			resultSet = prepStatement.executeQuery();
			resultSet.next();
			toName = resultSet.getString("name");
		}
		catch(SQLException se)
		{
			System.out.println("Error retrieving name of toUser "+toUser);
			while(se!=null)
			{
				System.out.println("Message - "+se.getMessage());
				System.out.println("State - "+se.getSQLState()+" - "+se.getErrorCode());
				se=se.getNextException();
			}
			return false;
		}
		System.out.println("Initiating friend request to "+toName);
		System.out.println("Enter a friend request message:");
		String msg = s.nextLine();
		
		System.out.println("Confirm friend request to "+toName+"? Y/N:");
		String confirm = s.nextLine().toUpperCase();
		while(!confirm.equals("Y") && !confirm.equals("N"))
		{
			System.out.println("Please enter (Y)es or (N)o:");
			confirm=s.nextLine().toUpperCase();
		}
		if(confirm.equals("Y"))
		{
			try{
				query = "INSERT INTO PENDINGFRIENDS values(?,?,?)";
				prepStatement = connection.prepareStatement(query);
				prepStatement.setString(1,fromUser);
				prepStatement.setString(2,toUser);
				prepStatement.setString(3,msg);
				prepStatement.executeUpdate();
				System.out.println("Successfully sent friend request to "+toName);
				return true;
			}
			catch(SQLException e)
			{
				System.out.println("Error initiating friendship from users "+fromUser+" to "+toUser);
				while(e!=null)
				{
					System.out.println("Message - "+e.getMessage());
					System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
					e=e.getNextException();
				}
				return false;
			}
		}
		System.out.println("Failed to send friend request to "+toName);
		return false;
  }
  
	public void confirmFriendship(String userID, String gID)
    {
	 try{
			 Scanner s = new Scanner(System.in);
			 query = "SELECT fromID, message FROM PENDINGFRIENDS WHERE toID = ?";
			 prepStatement = connection.prepareStatement(query);
			 prepStatement.setString(1,userID);
			 resultSet = prepStatement.executeQuery();
			 if(!resultSet.first())
			 {
				 System.out.println("No outstanding friend requests!");
				 //proceed to confirming group memberships
				 confirmGroupMembership(userID,gID);
				 return;
			 }
			 int num=1;
			 ArrayList<Friend> fr = new ArrayList<Friend>();
			 System.out.println("Outstanding friend requests:");
			 do
			 {
				 String fromUser=resultSet.getString("fromID");
				 String msg=resultSet.getString("message");
				 System.out.println(num+") "+fromUser+"\t"+msg);
				 Friend f = new Friend(fromUser,msg);
				 fr.add(f);
				 num++;
			 }while(resultSet.next());
			 System.out.println("Enter a friend request number to confirm, enter 0 to confirm all, or -1 to quit:");
			 int choice=s.nextInt();
			if(choice==0) //confirm all friend requests
			{
				for(Friend fromUser : fr)
				{
					try{
						java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd-MM-yyyy");
						Calendar cal = Calendar.getInstance(); //current date
						java.sql.Date date_reg = new java.sql.Date (cal.getTimeInMillis());
						String fUser = fromUser.getFromUser();
						String msg = fromUser.getMsg();
						query = "INSERT INTO FRIENDS values(?,?,?,?)";
						//PENDINGFRIENDS_TRIGGER should activate
						prepStatement=connection.prepareStatement(query);
						prepStatement.setString(1,userID);
						prepStatement.setString(2,fUser);
						prepStatement.setDate(3,date_reg);
						prepStatement.setString(4,msg);
						prepStatement.executeUpdate();
					}
					catch(SQLException e)
					{
						System.out.println("Error accepting friendship");
						while(e!=null)
						{
							System.out.println("Message - "+e.getMessage());
							System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
							e=e.getNextException();
						}
						return;
					}
					
				}
			}
			else if(choice>0) //specify certain friend requests to confirm
			{
				while(choice>0)
				{
					try{
						Friend fromUser = fr.remove(choice-1); //choice-1 because 0 is to accept all friend requests
						java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd-MM-yyyy");
						Calendar cal = Calendar.getInstance(); //current date
						java.sql.Date date_reg = new java.sql.Date (cal.getTimeInMillis());
						String fUser = fromUser.getFromUser();
						String msg = fromUser.getMsg();
						query = "INSERT INTO FRIENDS values(?,?,?,?)";
						//PENDINGFRIENDS_TRIGGER should activate
						prepStatement=connection.prepareStatement(query);
						prepStatement.setString(1,userID);
						prepStatement.setString(2,fUser);
						prepStatement.setDate(3,date_reg);
						prepStatement.setString(4,msg);
						prepStatement.executeUpdate();
					}
					catch(SQLException e)
					{
						System.out.println("Error accepting friendship");
						while(e!=null)
						{
							System.out.println("Message - "+e.getMessage());
							System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
							e=e.getNextException();
						}
						return;
					}
					//prompt user to keep adding or quit
					System.out.println("Enter a friend request number to confirm, or -1 to quit:");
					choice = s.nextInt();
				}
				
			}
			
			//remove the remaining friend requests that were not accepted
			//arraylist fr should be null if choice = 0 initially
			for(Friend user : fr)
			{
				try{
					query = "DELETE FROM PENDINGFRIENDS WHERE toID = ?";
					prepStatement = connection.prepareStatement(query);
					prepStatement.setString(1,userID);
					prepStatement.executeQuery();
				}
				catch(SQLException e)
				{
					System.out.println("Error deleting declined pending friends");
					while(e!=null)
					{
						System.out.println("Message - "+e.getMessage());
						System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
						e=e.getNextException();
					}
					return;
				}
				
			}
			//proceed to confirming group memberships
			confirmGroupMembership(userID,gID);
		}
		catch(SQLException e)
		{
			System.out.println("Error confirming friendship and group membership");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
			return;
		}
	}
	
	public void confirmGroupMembership(String userID, String gID)
	{
		try{
			 Scanner s = new Scanner(System.in);
			 //check if the user is the manager of any groups
			 query = "SELECT gID FROM GROUPMEMBERSHIP WHERE role = 'Manager' AND userID = ?";
			 prepStatement = connection.prepareStatement(query);
			 prepStatement.setString(1,userID);
			 resultSet = prepStatement.executeQuery();
			 if(!resultSet.first())
			 {
				 System.out.println("User is not the manager of any groups");
				 return;
			 }
			 
			 //select all the groups the user is the manager of in the inner query
			 //in order to select the corresponding pending group member requests for those groups
			 query = "SELECT userID, message, gID "
				+"FROM PENDINGGROUPMEMBERS "
				+"WHERE PENDINGGROUPMEMBERS.gID "
				+"IN (SELECT gID FROM GROUPMEMBERSHIP WHERE role = 'Manager' AND userID = ?)";
			 prepStatement = connection.prepareStatement(query);
			 prepStatement.setString(1,userID);
			 resultSet = prepStatement.executeQuery();
			 
			 
			 int num=1;
			 ArrayList<GroupMember> gr = new ArrayList<GroupMember>();
			 System.out.println("Outstanding group member requests:");
			 do
			 {
				 String user=resultSet.getString("userID");
				 String msg=resultSet.getString("message");
				 String groupID=resultSet.getString("gID");
				 System.out.println(num+") "+user+"\t"+groupID+"\t"+msg);
				 GroupMember gm = new GroupMember(user,msg,groupID);
				 gr.add(gm);
				 num++;
			 }while(resultSet.next());
			 System.out.println("Enter a group member request number to confirm, enter 0 to confirm all, or -1 to quit:");
			 int choice=s.nextInt();
			if(choice==0) //confirm all group membership requests
			{
				for(GroupMember user : gr)
				{
					try{
						String usr = user.getUser();
						String grID = user.getGID();
						query = "INSERT INTO GROUPMEMBERSHIP values(?,?,'Member')";
						//PENDINGGROUPMEMBERS_TRIGGER should activate
						prepStatement=connection.prepareStatement(query);
						prepStatement.setString(1,grID);
						prepStatement.setString(2,usr);
						prepStatement.executeUpdate();
					}
					catch(SQLException e)
					{
						System.out.println("Error accepting group member");
						while(e!=null)
						{
							System.out.println("Message - "+e.getMessage());
							System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
							e=e.getNextException();
						}
						return;
					}
					
				}
			}
			else if(choice>0) //specify certain group membership requests to confirm
			{
				while(choice>0)
				{
					try{
						GroupMember user = gr.remove(choice-1); //choice-1 because 0 is to accept all group member requests
						String usr = user.getUser();
						String grID = user.getGID();
						query = "INSERT INTO GROUPMEMBERSHIP values(?,?,'Member')";
						//PENDINGGROUP_TRIGGER should activate
						prepStatement=connection.prepareStatement(query);
						prepStatement.setString(1,grID);
						prepStatement.setString(2,usr);
						prepStatement.executeUpdate();
					}
					catch(SQLException e)
					{
						System.out.println("Error accepting group member");
						while(e!=null)
						{
							System.out.println("Message - "+e.getMessage());
							System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
							e=e.getNextException();
						}
						return;
					}
					//prompt user to keep adding or quit
					System.out.println("Enter a group member request number to confirm, or -1 to quit:");
					choice = s.nextInt();
				}
				
			}
			
			//remove the remaining friend requests that were not accepted
			//arraylist fr should be null if choice = 0 initially
			for(GroupMember user : gr)
			{
				try{
					query = "DELETE FROM PENDINGGROUPMEMBERS WHERE gID = ? AND userID = ?";
					prepStatement = connection.prepareStatement(query);
					prepStatement.setString(1,user.getGID());
					prepStatement.setString(2,user.getUser());
					prepStatement.executeQuery();
				}
				catch(SQLException e)
				{
					System.out.println("Error deleting declined pending group members");
					while(e!=null)
					{
						System.out.println("Message - "+e.getMessage());
						System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
						e=e.getNextException();
					}
					return;
				}
				
			}
			return;
		}
		catch(SQLException e)
		{
			System.out.println("Error confirming group members");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
			return;
		}
	}
	
	public void displayFriends(String userID)
	{
		try{
			//gather the user's friends
			query = "SELECT name, userID1, userID2 "
				+"FROM (FRIENDS JOIN PROFILE ON (((userID1 <> ?) AND (userID1 = userID)) "
				+"OR ((userID2 <> ?) AND (userID2 = userID)))) "
				+"WHERE userID1 = ? OR userID2 = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userID);
			prepStatement.setString(2,userID);
			prepStatement.setString(3,userID);
			prepStatement.setString(4,userID);
			resultSet = prepStatement.executeQuery();
			
			System.out.println("Friends List:");
			while(resultSet.next())
			{
				String friend = resultSet.getString("userID1");
				if(userID.equals(friend))
					System.out.println("Name: "+resultSet.getString("name")+" - UserID: "+resultSet.getString("userID2"));
				else
					System.out.println("Name: "+resultSet.getString("name")+" - UserID: "+friend);
			}
			
			System.out.println("Enter a userID to retrieve a profile, or enter 0 to quit:");
			Scanner s = new Scanner(System.in);
			String id = s.nextLine();
			while(!id.equals("0"))
			{
				query = "SELECT userID,name,email,dateOfBirth FROM PROFILE WHERE userID = ?";
				prepStatement = connection.prepareStatement(query);
				prepStatement.setString(1,id);
				resultSet = prepStatement.executeQuery();
				//display friend profile
				System.out.println("UserID: "+resultSet.getString("userID"));
				System.out.println("Name: "+resultSet.getString("name"));
				System.out.println("Email: "+resultSet.getString("email"));
				System.out.println("Date of birth: "+resultSet.getDate("dateOfBirth"));
				System.out.println("\nEnter a userID to retrieve a profile, or enter 0 to quit:");
				id = s.nextLine();
			}
		}
		catch(SQLException e)
		{
			System.out.println("Error displaying friends");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
			return;
		}
	}
	
	public boolean initiateAddingGroup(String userID, String gID)
	{
		try{
			Scanner s = new Scanner(System.in);
			query = "INSERT INTO PENDINGGROUPMEMBERS values(?,?,?)";
			prepStatement = connection.prepareStatement(query);
			System.out.println("Enter a message for the group membership request:");
			String msg = s.nextLine();
			prepStatement.setString(1,gID);
			prepStatement.setString(2,userID);
			prepStatement.setString(3,msg);
			prepStatement.executeUpdate();
			return true;
		}
		catch(SQLException e)
		{
			System.out.println("Error initiating group membership request");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
			return false;
		}
	}
	
	public boolean sendMessageToGroup(String userID, String gID)
	{
		try{
			//check if user is in the group
			query = "SELECT gID FROM GROUPMEMBERSHIP WHERE userID = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userID);
			resultSet = prepStatement.executeQuery();
			while(resultSet.next())
			{
				if(!gID.equals(resultSet.getString("gID")))
				//user is not part of the group
				System.out.println("User is not part of the group!");
				return false;
			}
			Scanner s = new Scanner(System.in);
			System.out.println("Enter your message:");
			String msg = s.nextLine();
			query = "SELECT MAX(msgID) AS maxID FROM MESSAGES";
			prepStatement = connection.prepareStatement(query);
			resultSet = prepStatement.executeQuery();
			int maxID = 1;
			if(resultSet.next())
				maxID = resultSet.getInt("maxID");
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("dd-MM-yyyy");
			Calendar cal = Calendar.getInstance(); //current date
			java.sql.Date date_reg = new java.sql.Date (cal.getTimeInMillis());
			query = "INSERT INTO MESSAGES values(?,?,?,NULL,?,?)";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,(maxID+""));
			prepStatement.setString(2,userID);
			prepStatement.setString(3,msg);
			prepStatement.setString(4,gID);
			prepStatement.setDate(5,date_reg);
			prepStatement.executeUpdate();
			return true;
		}
		catch(SQLException e)
		{
			System.out.println("Error sending group message");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
			return false;
		}
	}
	
	public void displayMessages(String userID)
	{
		try{
			query = "SELECT fromID, message, dateSend FROM MESSAGES WHERE toUserID = ? ORDER BY dateSend DESC";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userID);
			resultSet = prepStatement.executeQuery();
			
			while(resultSet.next())
			{
				System.out.println("From: "+resultSet.getString("fromID"));
				System.out.println("Date Sent: "+resultSet.getDate("dateSend"));
				System.out.println("Message: "+resultSet.getString("message"));
			}
		}
		catch(SQLException e)
		{
			System.out.println("Error displaying messages");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
		}
	}
	
	public void displayNewMessages(String userID)
	{
		try{
			query = "SELECT fromID, message, dateSend FROM MESSAGES WHERE toUserID = ? AND dateSend > ? ORDER BY dateSend DESC";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userID);
			prepStatement.setTimestamp(2,lastLogin);
			resultSet = prepStatement.executeQuery();
			
			while(resultSet.next())
			{
				System.out.println("From: "+resultSet.getString("fromID"));
				System.out.println("Date Sent: "+resultSet.getDate("dateSend"));
				System.out.println("Message: "+resultSet.getString("message"));
			}
		}
		catch(SQLException e)
		{
			System.out.println("Error displaying new messages");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
		}
	}
	
	public void threeDegrees(String userA, String userB)
	{
		try{
			ArrayList<String> friends = new ArrayList<String>();
			query = "SELECT userID1,userID2 FROM FRIENDS WHERE userID1 = ? OR userID2 = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userA);
			prepStatement.setString(2,userA);
			resultSet = prepStatement.executeQuery();
			while(resultSet.next())
			{
				String f = resultSet.getString("userID1");
				if(f.equals(userA))
					f = resultSet.getString("userID2");
				//add all of userA's friends
				friends.add(f);
			}
			threeDegPath.add(userA);
			for(String friend : friends)
			{
				if(threeDegRec(friend,userB))
				{
					System.out.println("Path from "+userA+" to "+userB);
					for(String path : threeDegPath)
					{
						if(!path.equals(userB))
							System.out.print(path+" -> ");
						else
							System.out.println(path);
					}
				}
			}
		}
		catch(SQLException e)
		{
			System.out.println("Error finding three degrees path");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
		}
		return;
	}
	
	public boolean threeDegRec(String user, String targetUser)
	{
		if (threeDegPath.size()>3)
			return false;
		if(targetUser.equals(user)) //found targetUser
			return true;
		try{
			ArrayList<String> friends = new ArrayList<String>();
			query = "SELECT userID1,userID2 FROM FRIENDS WHERE userID1 = ? OR userID2 = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,user);
			prepStatement.setString(2,user);
			resultSet = prepStatement.executeQuery();
			while(resultSet.next())
			{
				String f = resultSet.getString("userID1");
				if(f.equals(user))
					f = resultSet.getString("userID2");
				//add all of user's friends
				friends.add(f);
			}
			threeDegPath.add(user);
			for(String friend : friends)
			{
				threeDegPath.add(friend);
				if(threeDegRec(friend,targetUser))
					return true;
				else
					threeDegPath.remove(threeDegPath.size()-1); //undo the previous add
			}
		}
		catch(SQLException e)
		{
			System.out.println("Error finding three degrees path");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
		}
		return false;
	}
	
	public boolean dropUser(String userID)
	{
		try{
			query = "DELETE FROM PROFILE WHERE userID = ?";
			prepStatement = connection.prepareStatement(query);
			prepStatement.setString(1,userID);
			prepStatement.executeUpdate();
			return true;
		}
		catch(SQLException e)
		{
			System.out.println("Error dropping user");
			while(e!=null)
			{
				System.out.println("Message - "+e.getMessage());
				System.out.println("State - "+e.getSQLState()+" - "+e.getErrorCode());
				e=e.getNextException();
			}
		}
		return false;
	}
	
}
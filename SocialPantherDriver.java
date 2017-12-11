import java.sql.*;  //import the file containing definitions for the parts
import java.util.*;
import java.io.*;

public class SocialPantherDriver
{
	public static void main(String[] args) throws Exception
	{
		SocialPantherDB db = new SocialPantherDB();
		db.runDB();
		String userID = null;
		Scanner s = new Scanner(System.in);
		System.out.println("Welcome to Social Panther!");
		System.out.println("Please select an action:");
		System.out.println("1. Create an account");
		System.out.println("2. Login");
		System.out.println("3. Quit");
		int input = s.nextInt();
		switch(input)
		{
			case 1:
				userID = UUID.randomUUID().toString().substring(0,5);
				s.nextLine();
				System.out.println("Please enter your full name:");
				String name = s.nextLine();
				System.out.println("Please enter your email:");
				String email = s.nextLine();
				System.out.println("Please enter a password:");
				String pass = s.nextLine();
				System.out.println("Please enter your date of birth (numerical format: dd-MM-yyyy):");
				String dob = s.nextLine();
				if(db.createUser(userID,name,email,pass,dob)>0)
				{
					System.out.println("Account successfully created");
					System.out.println("Your userID is "+userID);
					//assumes each user is given a generated 5 char alphanumeric userID, just like
					//how pitt gives each student their own username
					//each user is assumed to have to memorize their userID
				}
				else
					System.out.println("Account unable to be created");
				break;
			case 2:
				s.nextLine();
				System.out.println("Please enter your userID:");
				userID = s.nextLine();
				System.out.println("Please enter your password:");
				pass = s.nextLine();
				if(db.login(userID,pass))
					System.out.println("Successfully logged in");
				else
				{
					System.out.println("Unable to log in");
					System.exit(0);
				}
				break;
			case 3:
				System.out.println("Exiting Social Panther. Good bye!");
				System.exit(0);
				break;
		}
		//proceed to display user options after creating an account or logging in
		if(input<3 && input>0)
		{
			displayOptions();
			int choice = s.nextInt();
			while(choice<14 && choice>0)
			{
				switch(choice)
				{
					case 1:
						s.nextLine();
						System.out.println("Enter the userID of the user to send a friend request to:");
						String toUser = s.nextLine();
						if(!db.initiateFriendship(userID,toUser))
							System.out.println("Unable to send friend request");
						break;
					//confirm friend requests and group membership requests
					//assumes the group manager(s) knows their groupID 
					case 2:
						db.confirmFriendship(userID);
						break;
					case 3:
						db.displayFriends(userID);
						break;
					case 4:
						s.nextLine();
						System.out.println("What do you want to call your group?");
						String gname = s.nextLine();
						System.out.println("Enter is your group's description:");
						String desc = s.nextLine();
						System.out.println("Enter the max number of group members allowed:");
						int lim = s.nextInt();
						db.createGroup(gname,desc,userID,lim);
						break;
					case 5:
						s.nextLine();
						db.showGroups();
						System.out.println("Enter the groupID to send a group membership request to:");
						String gid = s.nextLine();
						if(db.initiateAddingGroup(userID,gid))
							System.out.println("Successfully sent group membership request");
						break;
					case 6:
						s.nextLine();
						db.showGroups();
						System.out.println("Enter the groupID to send a group message to:");
						gid = s.nextLine();
						if(db.sendMessageToGroup(userID,gid))
							System.out.println("Successfully sent message to all group members");
						break;
					case 7:
						db.displayMessages(userID);
						break;
					case 8:
						db.displayNewMessages(userID);
						break;
					case 9: //not working
						//s.nextLine();
						System.out.println("Enter a value for K:");
						int k = s.nextInt();
						System.out.println("Enter a value for X:");
						int x = s.nextInt();
						db.topMessages(x,k);
						break;
					case 10: //not working
						s.nextLine();
						System.out.println("Enter a userID to find a path to:");
						String userB = s.nextLine();
						db.threeDegrees(userID,userB);
						break;
					case 11:
						if(db.dropUser(userID))
						{
							System.out.println("Successfully deleted user");
							System.exit(0);
						}
						break;
					case 12:
						s.nextLine();
						System.out.println("Enter the userID to send the message to:");
						String toID = s.nextLine();
						db.sendMessageToUser(toID,userID);
						break;
					case 13:
						s.nextLine();
						System.out.println("Enter the name of the user to search for:");
						String name = s.nextLine();
						db.searchForUser(name);
						break;
				}
				displayOptions();
				choice = s.nextInt();
			}
			System.out.println("Thank you for using Social Panther!\nLogging out..");
			db.logOut(userID);
		}
		
		
	}
	
	public static void displayOptions()
	{
		System.out.println("Please select an action:");
		System.out.println("1. Send a friend request to a user");
		System.out.println("2. Confirm friend requests and group membership requests");
		System.out.println("3. Display friends list");
		System.out.println("4. Create a group");
		System.out.println("5. Send a group membership request");
		System.out.println("6. Send a group message");
		System.out.println("7. Display all messages");
		System.out.println("8. Display new messages");
		System.out.println("9. Display the top k users with the most activity in the past x months");
		System.out.println("10. Display Three Degrees path from one user to another user");
		System.out.println("11. Delete your account");
		System.out.println("12. Send a message to a user");
		System.out.println("13. Search for a user");
		System.out.println("14. Logout");
	}
}
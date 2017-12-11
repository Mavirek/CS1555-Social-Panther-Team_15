import java.sql.*;  //import the file containing definitions for the parts
import java.util.*;
import java.io.*;

public class SocialPantherBenchmark
{
	public static void main(String[] args) throws Exception
	{
		SocialPantherDB db = new SocialPantherDB();
		db.runDB();
		
		System.out.println("Testing account creation..\n");
		/*
		Assumes SocialPanther should assign you a userID to memorize, just like
			how Pitt assigns everyone a username
		*/
		String userID = "alp170";
		//UUID.randomUUID().toString().substring(0,5); is used in the Driver program
		//hardcoding userID for testing purposes
		String name = "Allen";
		String email = "allen@pitt.edu";
		String pass = "pass";
		String dob = "29-11-1996";
		if(db.createUser(userID,name,email,pass,dob)>0)
		{
			System.out.println("Account successfully created");
			System.out.println("Your userID is "+userID);
		}
		else
		{
			System.out.println("Account unable to be created");
		}
		
		System.out.println("\nTesting account login..\n");
		if(db.login(userID,pass))
		{
			System.out.println("Successfully logged in");
		}
		else
		{
			System.out.println("Unable to log in");
			System.exit(0);
		}
		
		System.out.println("\nTesting initiateFriendship..\n");
		String toUser = "6b3ad";
		//sends friend request from user alp170 to user 6b3ad
		if(!db.initiateFriendship(toUser,userID))
			System.out.println("Unable to send friend request");
		
		System.out.println("\nTesting confirmFriendship..\n");
		//requires manual control to pick which friend/group requests to confirm
		//confirm friendships/group memberships for user alp170

		//Social Panther will continue to prompt the user to input a
		//number if the user chooses to confirm friend requests individually
		//input -1 to stop
		db.confirmFriendship(userID);
		
		System.out.println("\nTesting displayFriends..\n");
		//displays the friends of user alp170
		db.displayFriends(userID);
		
		System.out.println("\nTesting createGroup..\n");
		String groupName = "Pitt Soccer";
		String desc = "Pitt intramural soccer club";
		int lim = 2;
		//user alp170 should be the manager of the group by default
		//Social Panther will assign the group a groupID automatically
		//in this case, it will be 11 since there are 10 pre-inserted groups in the DB
		db.createGroup(groupName,desc,userID,lim);
		
		System.out.println("\nTesting initiateAddingGroup..\n");
		if(db.initiateAddingGroup("6b3ad","11"))
			System.out.println("Successfully sent group membership request");
		else
			System.out.println("Unable to send group membership request");
		
		System.out.println("\nTesting sendMessageToGroup..\n");
		//requires manual input for the message
		//verify correctness via SQLPLUS query to check MESSAGES table tuples
		//user alp170 sending group message
		if(db.sendMessageToGroup(userID,"11"))
			System.out.println("Successfully sent message to all group members");
		else
			System.out.println("Unable to send message to all group members");
		
		System.out.println("\nTesting displayMessages..\n");
		//display all messages for user alp170
		db.displayMessages(userID);
		//should appear as nothing since there are no messages
		
		System.out.println("\nTesting sendMessageToUser..\n");
		//send a message to user alp170 from user 6b3ad
		db.sendMessageToUser(userID,"6b3ad");
		
		System.out.println("\nTesting logOut..\n");
		db.logOut(userID); //logout and login to display the new message from 6b3ad
		
		System.out.println("Relogging in");
		db.runDB();
		db.login("alp170","pass");
		
		System.out.println("\nTesting displayNewMessages..\n");
		//display new messages for user alp170 that were received
		//since the last login. (should receive a new message from 6b3ad)
		db.displayNewMessages(userID);
		
		
		System.out.println("\nTesting topMessages..\n");
		//top k users who sent the most messages in the past x months
		int k = 3;
		int x = 2;
		db.topMessages(x,k);
		
		System.out.println("\nTesting threeDegrees..\n");
		String userA = "25c82";
		String userB = "6b3ad";
		db.threeDegrees(userA,userB);
		//should output: 25c82 -> ca2cf -> 6b3ad
		
		System.out.println("\nTesting searchForUser..\n");
		db.searchForUser("Myron"); //should be valid
		db.searchForUser("allen"); //should be invalid
		
		System.out.println("\nTesting dropUser..\n");
		if(db.dropUser(userID))
		{
			System.out.println("Successfully deleted user");
		}
		else
			System.out.println("Unable to delete user");
	}
}
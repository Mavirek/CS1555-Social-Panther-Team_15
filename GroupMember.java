public class GroupMember
{
	private String userID;
	private String msg;
	private String gID;
	
	public GroupMember(String userID, String msg, String gID)
	{
		this.userID = userID;
		this.msg = msg;
		this.gID = gID;
	}
	
	public String getUser()
	{
		return userID;
	}
	
	public String getMsg()
	{
		return msg;
	}
	
	public String getGID()
	{
		return gID;
	}
}
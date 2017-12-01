public class Friend
{
	private String fromID;
	private String msg;
	
	public Friend(String fromID, String msg)
	{
		this.fromID = fromID;
		this.msg = msg;
	}
	
	public String getFromUser()
	{
		return fromID;
	}
	
	public String getMsg()
	{
		return msg;
	}
}
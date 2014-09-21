package dao;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.TimeZone;
import java.util.Vector;


public class Connect {
	
	  private static int inuse = 0;
	  private static int max = 36;
	  private static Vector connections = new Vector();

	  public static synchronized void releaseConnection(Connection con)
	  {
	    connections.addElement(con);
	    inuse--;
	  }
	 
	  public static synchronized Connection getConnected()
	  {
	    Connection con=null;
	    if(connections.size()>0)
	     {
	       con=(Connection) connections.elementAt(0);
	       connections.removeElementAt(0);
	       try{
	       if(con.isClosed())
	       {
	         con = getConnected();
	       }
	       }catch(SQLException e){
	    	   e.printStackTrace();
	       }
	     }
	     else if( max == 0|| inuse < max )
	      {
	         con = newConnection();
	      }
	     if( con != null )
	      { inuse++; }
	     if(con == null)
	    	 System.err.println("connection null");
	     System.out.println("正在使用的数据库连接数inuse = "+inuse+" connection向量大小："+connections.size());
	   return con;  
	  }
	  
	  private static Connection newConnection()
	  {
	    Connection con=null;
	    try
	    {
	      //Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
	      Class.forName("com.mysql.jdbc.Driver");
	    }catch(Exception e){
	    	e.printStackTrace();
	    }
	    try
	    {
	      con=DriverManager.getConnection("jdbc:mysql://localhost:3306/yichuandb","root","root");
	    }catch(SQLException e)
	     {
	      e.printStackTrace();
	      return null;
	     }
	    return con;
	  }
	  
	  public static synchronized void closeCon()
	  {
	    Enumeration allConnections=connections.elements();
	    while(allConnections.hasMoreElements())
	    {
	      Connection con=(Connection)allConnections.nextElement();
	      try{con.close();}
	      catch(SQLException e){
	    	  System.out.println("关闭数据库连接发生错误");
	      }
	    }
	    connections.removeAllElements();
	    inuse = 0;
	  }
	public static boolean close(Connection con)
	{
		try {
			con.close();
		} catch (SQLException e) {
			System.out.println("关闭连接失败！");
			e.printStackTrace();
			return false;
		}
		
		return true;
	}

	public static void main(String[] args) throws SQLException {
		// TODO Auto-generated method stub
		Connection connection = getConnected();
		Statement statementLeft = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		String addLeftSql = "select * from adds , add_position where adds.addName=add_position.addName and position='左侧'";
		//String addLeftSql = "select * from adds";
		ResultSet addLeftResultSet = statementLeft.executeQuery(addLeftSql);
		addLeftResultSet.next();
		System.out.println(addLeftResultSet.getString(1));
		addLeftResultSet.next();
		System.out.println(addLeftResultSet.getString(1));
		
	}
}

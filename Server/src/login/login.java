package login;

import java.sql.*;



public class login {

	public String user_name;

	public String user_key;

	public Connection con;

	
	public boolean login_exe() throws Exception {
		try {

			Statement statement = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sql = "insert into user_info (user_name,user_key) values ('"+ user_name + "','" + user_key + "')";
			System.out.println("ÕýÔÚ×¢²á¡£¡£¡£");
			statement.executeUpdate(sql);
			System.out.println("×¢²áÍê±Ï¡£¡£¡£");

			return true;

		} catch (SQLException ee) {
			ee.printStackTrace();
			return false;
		}

	}
}
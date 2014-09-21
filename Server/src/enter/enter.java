package enter;

import java.sql.*;

public class enter {
	public String user_name;
	public String user_key;
	public Connection con;

	public boolean enter_exe() throws Exception {
		try {

			Statement statement = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sql = "select * from use_info where user_name='" + user_name	+ "' and user_key='" + user_key + "'";
			ResultSet r = statement.executeQuery(sql);

			if (!r.first()) {
				return false;
			} else {
				return true;
			}

		} catch (SQLException ee) {
			return false;
		}

	}

}
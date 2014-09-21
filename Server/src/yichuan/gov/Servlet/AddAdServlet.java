package yichuan.gov.Servlet;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import UpdateLog.UpdateLog;

import dao.Connect;

public class AddAdServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public AddAdServlet() {
		super();
	}

	 
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}
  
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		 
	}

	 
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		String adName = request.getParameter("adName");
		String description = request.getParameter("description").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
	    String filename = request.getParameter("filename");
		String adPosition  = request.getParameter("adPosition");  
		PrintWriter out = response.getWriter();
		Connection connection = Connect.getConnected();
		
		String sql = "";
		try {
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务			
			sql = "insert into advertisement (adName,adImage,adPosition,description) values ('"+adName+"',?,'"+adPosition+"','"+description+"')";		
			
            FileInputStream fileins = new FileInputStream(filename);
			
			PreparedStatement psmt = connection.prepareStatement(sql);
			psmt.setBinaryStream(1, fileins, fileins.available());

			psmt.execute();
			psmt.close();

			Connect.releaseConnection(connection);//added by dujintao 20131226
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("<b>插入广告"+adName+"时发生错误！</b><br>错误代码："+e.toString());
			Connect.releaseConnection(connection);//added by dujintao 20131226
			System.out.println("插入广告"+adName+"时发生错误！");
			return;
		}
		out.println("<b>插入广告"+adName+"成功！</b>");
		UpdateLog.updatelog(true,sql,filename);
	}

	 
	public void init() throws ServletException {
		// Put your code here
	}

}

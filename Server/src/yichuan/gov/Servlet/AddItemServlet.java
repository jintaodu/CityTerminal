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

public class AddItemServlet extends HttpServlet {

	 
	public AddItemServlet() {
		super();
	}
 
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	 
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the GET method");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	 
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		String secondlevelcategoryName = request.getParameter("secondlevelcategoryName");
		String newitemName = request.getParameter("newitemName");
		String description  = request.getParameter("description").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String abstractdescription  = request.getParameter("abstractdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String filename     = request.getParameter("filename");
		String sql = "";
		PrintWriter out = response.getWriter();
		Connection connection = Connect.getConnected();
		try {
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			
			sql = "insert into item (itemName,itemImage,itemCategory,itemAbstract,itemText) values ('"+newitemName+"',?,'"+secondlevelcategoryName+"','"+abstractdescription+"','"+description+"')";
			
			FileInputStream fileins = new FileInputStream(filename);
			
			PreparedStatement psmt = connection.prepareStatement(sql);
			psmt.setBinaryStream(1, fileins, fileins.available());
			psmt.execute();
			psmt.close();
			
			Connect.releaseConnection(connection);//added by dujintao 20131226
					
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("添加新项目，数据库操作错误："+e.toString());
			Connect.releaseConnection(connection);//added by dujintao 20131226
			out.println("<b>"+"添加新项目，数据库操作错误："+e.toString()+"</b>");
			return;
		}
		
		out.println("<b>新项目"+newitemName+"添加成功！</b>");
		System.out.println("<b>新项目"+newitemName+"添加成功！</b>");
		UpdateLog.updatelog(true,sql,filename);
	
	}
	 
	public void init() throws ServletException {
		// Put your code here
	}

}

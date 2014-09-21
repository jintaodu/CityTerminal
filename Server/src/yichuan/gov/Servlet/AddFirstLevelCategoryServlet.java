package yichuan.gov.Servlet;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import UpdateLog.UpdateLog;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

import dao.*;

public class AddFirstLevelCategoryServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public AddFirstLevelCategoryServlet() {
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

		response.setContentType("text/html");
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String categoryName = request.getParameter("categoryName");
		String description  = request.getParameter("description").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String filename  = request.getParameter("filename");
		
		PrintWriter out = response.getWriter();
		Connection connection = Connect.getConnected();
		String sql = "";
		try {
			
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			sql = "insert into FirstLevelCategory (categoryName,categoryImage,description) values ('"+categoryName+"',?,'"+description+"')";
			
			FileInputStream fileins = new FileInputStream(filename);
			
			PreparedStatement psmt = connection.prepareStatement(sql);
			psmt.setBinaryStream(1, fileins, fileins.available());

			psmt.execute();
			psmt.close();
			
		} catch (SQLException e) {
			 
			e.printStackTrace();
			out.println("<br>添加一级类别，数据库错误<b>"+e.toString()+"</b>");
			Connect.releaseConnection(connection);//added by dujintao 20131226
			return;//此时不保存更新操作，因为更新没有成功
		}
        
	    UpdateLog.updatelog(true,sql,filename);
	    Connect.releaseConnection(connection);//added by dujintao 20131226
	    System.out.println("成功添加新类别到数据库中！");
		
		out.print("<br><b>成功添加新类别到数据库中！</b>");
	    //response.sendRedirect("manageCurrentCategories.jsp"); 
		
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	
	public void init() throws ServletException {
		// Put your code here
	}

}

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

public class FirstLevelCategoryInfoUpdate extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public FirstLevelCategoryInfoUpdate() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
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

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		
		response.setContentType("text/html");
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		
		String oldcategoryName = request.getParameter("oldcategoryName");
		String newcategoryName = request.getParameter("newcategoryName");
		String description  = request.getParameter("newdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String filename  = request.getParameter("filename");
		
		PrintWriter out = response.getWriter();
		Connection connection = Connect.getConnected();
		
		String sql = "";
		String sql1 = ""; String sql2 = ""; String sql3 = "";
		try {
			connection.setAutoCommit(false);
			
			if(filename != null && filename.length() > 0)
			{
				FileInputStream str = new FileInputStream(filename);
				sql="update firstlevelcategory set categoryImage=? where categoryName='"+oldcategoryName+"'";

				PreparedStatement pstmt = connection.prepareStatement(sql);
				pstmt.setBinaryStream(1,str,str.available());
				 
				pstmt.execute();
				pstmt.close();
				sql1 = sql;
			}
			if(description != null && description.replaceAll("\t", "").length()>0)
			{
				sql = "update FirstLevelCategory set description='"+ description +"' where categoryName='"+oldcategoryName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql2 = sql;
			   
			}
			if(newcategoryName != null && newcategoryName.length() > 0)
			{
				sql = "update FirstLevelCategory set categoryName='"+newcategoryName+"' where categoryName='"+oldcategoryName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql3 = sql;
			}
			
			connection.commit();

		} catch (SQLException e) {
			 
			e.printStackTrace();
			out.println("<br>更新一级类别，数据库发生错误<b>"+e.toString()+"</b>");
			try {
				connection.rollback();//发生错误是回滚

			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				out.println("<br>更新一级类别，数据库回滚发生错误<b>"+e1.toString()+"</b>");
			}
			Connect.releaseConnection(connection);//当出现异常时也释放数据库连接
			
			return;//此时不保存更新操作，因为更新没有成功
		}

	    Connect.releaseConnection(connection);//added by dujintao 20131226
	    /*
	     * 数据库操作成功后保存更新记录
	     */
	    if(sql1.length() > 0)
	    	UpdateLog.updatelog(true,sql1,filename);
	    if(sql2.length() > 0)
	    	UpdateLog.updatelog(false,sql2,"");
	    if(sql3.length() > 0)
	    	UpdateLog.updatelog(false,sql3,"");
	    
	    System.out.println("成功更新类别信息到数据库中！");
		
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");

		out.println("<b>更新类别信息成功！</b>");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
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

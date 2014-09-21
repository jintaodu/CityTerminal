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

public class AdInfoUpdateServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public AdInfoUpdateServlet() {
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
		response.setCharacterEncoding("UTF-8");
		
		PrintWriter out = response.getWriter();
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		
		
		String oldadName = request.getParameter("oldadName");
		String newadName = request.getParameter("newadName");
		String newadPosition = request.getParameter("newadPosition");
		String newdescription  = request.getParameter("newdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String newfilename  = request.getParameter("newfilename");
		
		Connection connection = Connect.getConnected();
		
		String sql = "";String sql1="";String sql2="";String sql3="";String sql4="";
		try{
			connection.setAutoCommit(false);
			
			if(newadPosition != null && newadPosition.length() > 0)
			{
				sql = "update advertisement set adPosition='"+newadPosition+"' where adName='"+oldadName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql1 = sql;
			    
			}
			if(newfilename != null && newfilename.length() > 0)
			{
				FileInputStream str = new FileInputStream(newfilename);
				sql="update advertisement set adImage=? where adName='"+oldadName+"'";

				PreparedStatement pstmt = connection.prepareStatement(sql);
				pstmt.setBinaryStream(1,str,str.available());
				 
				pstmt.execute();
				pstmt.close();
				sql2 = sql;
			   
			}
			if(newdescription != null && newdescription.replaceAll("\t", "").length()>0)
			{
				sql = "update advertisement set description='"+newdescription+"' where adName='"+oldadName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql3 = sql;
			   
			}
			if(newadName != null && newadName.length() > 0)
			{
				sql = "update advertisement set adName='"+newadName+"' where adName='"+oldadName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				
				sql4 = sql;
			    
			}
			connection.commit();//数据库提交更新
			
		}catch(SQLException e) {
			 
			e.printStackTrace();
			out.println("<br>广告更新，数据库发生错误：<b>"+e.toString()+"</b>");
			try {
				connection.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				out.println("<br>广告更新，数据库回滚发生错误：<b>"+e1.toString()+"</b>");
			}
			Connect.releaseConnection(connection);
			return;//此时不保存更新操作，因为更新没有成功
		}
		
		Connect.releaseConnection(connection);
		/*
		 * 保存更新记录
		 */
		if(sql1.length() > 0)
			UpdateLog.updatelog(false,sql1,"");
		if(sql2.length() > 0)
			UpdateLog.updatelog(true,sql2,newfilename);
		if(sql3.length() > 0)
			UpdateLog.updatelog(false,sql3,"");
		if(sql4.length() > 0)
			UpdateLog.updatelog(false,sql4,"");
		
		
		
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("更新广告\""+oldadName+"\"信息成功！");
		
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

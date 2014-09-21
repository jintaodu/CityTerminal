package yichuan.gov.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.Connect;

public class LoginCheckServlet extends HttpServlet {

	 
	public LoginCheckServlet() {
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

		String user_name = request.getParameter("user_name");
		String user_key  = request.getParameter("user_key");  
		Connection connection = Connect.getConnected();
		
		try {
			
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sql = "select * from users where  user ='"+ user_name + "' and password='" + user_key + "'";
			ResultSet resultSet =statement.executeQuery(sql);
			if(resultSet.next()){
				String type=resultSet.getString("type");
				if(type.equals("administor")){
					response.sendRedirect("manage.jsp");
				}
				else if(type.equals("category")){
					response.sendRedirect("categoriesManage.html");
				}
				else if(type.equals("add")){
					response.sendRedirect("addManage.html");
				}
				else{
					response.sendRedirect("adminenter.jsp");
				}
				
			}
			else{
				response.sendRedirect("adminenter.jsp");
			}
			Connect.releaseConnection(connection);//added by dujintao 20131226 
			
		} catch (SQLException e) {
			e.printStackTrace();
			Connect.releaseConnection(connection);//added by dujintao 20131226 
		}
	}

	 
	public void init() throws ServletException {
		// Put your code here
	}

}

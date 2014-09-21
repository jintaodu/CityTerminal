package yichuan.gov.Servlet;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
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

import dao.Connect;


import FileZip.ZipUtils;

public class UpdateClientDBServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	private static Connection con;//每个对象的共享变量
	private static Connect connect;//每个对象的共享变量
	public UpdateClientDBServlet() {
		super();
		con = Connect.getConnected();
		if(con == null)
		{
			System.out.println("连接数据库失败");
		}
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
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>手动更新客户端数据库</TITLE></HEAD>");
		out.println("  <BODY>");
		
		String status = updateclientdb();
		
		if(status.equals("-1"))
		{
			out.println("C盘下无\"更新包.zip\"文件！");
		}else if(status.equals("OK")){
			out.println("更新客户端数据库成功！");
			out.println(" 重新刷新主页立即生效！");
		}else if(status.equals("-2"))
		{
			out.println("<b>本客户端数据库已为最新！无需更新！</b>");
		}else
		{
			out.println("<b>更新客户端数据库发生错误，错误信息如下：</b>");
			out.println(status);
		}
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}
	public String updateclientdb() throws IOException
	{
		File updatepackage = new File("C://更新包.zip");
		if(!updatepackage.exists())
			return "-1";
		String path = "C:\\";
		ZipUtils.unZipFiles(updatepackage, path);//解压更新包
		
		String exesql_status = executesql("C:\\updatepackage");

		Connect.releaseConnection(con);
		return exesql_status;

	}

	private String executesql(String updatepackpath) throws IOException
	{
		File updateconfig = new File("C:\\Program Files\\Apache Software Foundation\\Tomcat 7.0\\webapps\\Tours\\UpdateConfig");
		FileReader fr = new FileReader(updateconfig);
		BufferedReader br = new BufferedReader(fr);
		
		String line = br.readLine();
		String updatebreakpoint = "";
		String[] info = new String[0];
		info = line.split(":");
		if(info != null && info.length == 2)
			updatebreakpoint = info[1];
		else updatebreakpoint = "0000-00-00-00-00-00";
		String newupdatebreakpoint = updatebreakpoint;
		br.close();
		fr.close();
		FileWriter fw = new FileWriter(updateconfig);
		BufferedWriter bw = new BufferedWriter(fw);
		
	    String sqlfilepath = updatepackpath+"\\sql.txt";

    	InputStreamReader isr = new InputStreamReader(new FileInputStream(sqlfilepath),"UTF-8");
    	BufferedReader br_isr = new BufferedReader(isr);
	    try{			
			Statement statement = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			
			int updatecount = 0;//记录执行了几条sql语句
			while((line = br_isr.readLine()) != null)
			{
				info = line.split("::::");//将sql.txt每行内容拆开
				System.out.println("line="+line);

				System.out.println("更新断点updatebreakpoint = "+updatebreakpoint);
				System.out.println("sql语句的时间："+info[0]);
				System.out.println("字符串比较结果："+info[0].compareTo(updatebreakpoint));
				if(info[0].compareTo(updatebreakpoint) >= 1)//如果更新时间大于当前sql时间则执行sql语句
				{
					updatecount++;
					if(Integer.parseInt(info[1]) == 1)//是图片更新
					{
						if(!new File(updatepackpath+"\\"+info[3]).exists())
						  {
							System.out.println("更新包中不存在文件"+updatepackpath+"\\"+info[3]);
							return ("更新包中不存在文件"+updatepackpath+"\\"+info[3]);
						  }
						FileInputStream str = new FileInputStream(updatepackpath+"\\"+info[3]);
						PreparedStatement pstmt = con.prepareStatement(info[2]);//info[2]为sql语句
						pstmt.setBinaryStream(1,str,str.available());
						pstmt.execute();
						pstmt.close();
						System.out.println(info[2]+"\r\n\t更新完成");
					}else
					{
						statement.executeUpdate(info[2]);
						System.out.println(info[2]+"\r\n\t更新完成");
					}//end of if
					newupdatebreakpoint = info[0];//如果sql执行成功则更新newupdatebreakpoint
				}else{
					continue;
				}

			}// end of while
			
			updateconfig.delete();
			bw.write("UpdateBreakPoint:"+newupdatebreakpoint);
			bw.flush();
			
			br_isr.close();	isr.close();
			bw.close();	fw.close();
			if(0 == updatecount)
				return "-2";
	    } catch(Exception e)
	    {
	    	updateconfig.delete();
			bw.write("UpdateBreakPoint:"+newupdatebreakpoint);//发生数据库操作异常时将更新成功的更新断点保存
			bw.flush();
			br_isr.close();	isr.close();
			bw.close();	fw.close();
	    	System.out.println("更新客户端数据库发生错误！");
	    	e.printStackTrace();
	    	return e.toString();
	    }
	    return "OK";
		
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

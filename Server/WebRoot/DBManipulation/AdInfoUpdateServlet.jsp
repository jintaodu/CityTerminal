<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.io.*" %>
<%@page import="dao.Connect" %>
<%@page import="UpdateLog.UpdateLog" %>
<%@page import="com.jspsmart.upload.*" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'AdInfoUpdateServlet.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    <%
    
    	response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		
		SmartUpload su = new SmartUpload();
	    su.initialize(pageContext);
	    //su.setAllowedFilesList("jpg,jpeg");
	    su.upload();
	    int filecount = su.save("/upload",SmartUpload.SAVE_VIRTUAL);
		
		String oldadName = su.getRequest().getParameter("oldadName");
		String newadName = su.getRequest().getParameter("newadName");
		String newadPosition = su.getRequest().getParameter("newadPosition");
		String newdescription  = su.getRequest().getParameter("newdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String newfilename  = application.getRealPath("/")+"/upload/"+su.getFiles().getFile(0).getFileName();
		System.out.println("广告新图片的路径为：" + newfilename);
		
		if(!newfilename.endsWith("upload/") && !(newfilename.endsWith(".jpg")||newfilename.endsWith(".jpeg")))
        {
        %>
        <script language="javascript">alert("上传图片格式不正确！"+"\n需要的图片格式为jpg或jpeg");
        window.location = "../AdInfoUpdate.jsp";</script>
        <% 
        System.out.println("上传项目图片格式不正确");
        return;
        }
        
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
			if(!newfilename.endsWith("upload/"))//如果不上传图片就不更新
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
    
     %>
  </body>
</html>

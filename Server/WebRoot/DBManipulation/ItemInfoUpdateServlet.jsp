<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.*,java.io.*" %>
<%@page import="dao.Connect" %>
<%@page import="UpdateLog.UpdateLog" %>
<%@page import="com.jspsmart.upload.*,java.awt.image.BufferedImage" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'ItemInfoUpdateServlet.jsp' starting page</title>
    
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
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");
		
		SmartUpload su = new SmartUpload();
	    su.initialize(pageContext);
	    //su.setAllowedFilesList("png");
	    su.upload();
	    
	    int filecount = su.save("/upload",SmartUpload.SAVE_VIRTUAL);
		
		String olditemName = su.getRequest().getParameter("olditemName");
		String newsecondlevelcategoryName = su.getRequest().getParameter("newsecondlevelcategoryName");
		String newitemName = su.getRequest().getParameter("newitemName");
		String newdescription  = su.getRequest().getParameter("newdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String newabstractdescription  = su.getRequest().getParameter("newabstractdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String newfilename  = application.getRealPath("/")+"/upload/"+su.getFiles().getFile(0).getFileName();
		
		
		System.out.println("更新项目，图片路径为："+newfilename);
		if(!newfilename.endsWith("upload/") && !(newfilename.endsWith(".jpg")||newfilename.endsWith(".jpeg")))
        {
        %>
        <script language="javascript">alert("上传图片格式不正确！"+"\n需要的图片格式为jpg或jpeg");
        window.location = "../ItemInfoUpdate.jsp";</script>
        <% 
        System.out.println("上传项目图片格式不正确");
        return;
        }else if(!newfilename.endsWith("upload/"))
        {
        	InputStream isis  = new FileInputStream(newfilename);
	   		BufferedImage src = javax.imageio.ImageIO.read(isis); //构造Image对象
	   		int srcWidth  = src.getWidth(null); //得到图片宽
	   		int srcHeight = src.getHeight(null); //得到图篇高
       
	       if(srcWidth >= 560 || srcWidth <= 540 || srcHeight >= 310||srcHeight <= 290)
	       {
	       %>
	       <script language="javascript"> alert("上传图片像素宽高不符合要求"+"\n需要的最佳宽为550高300");
	      	 window.location = "../ItemInfoUpdate.jsp";</script>
	       <% 
	       
	       return;
	       }
        }
		
		Connection connection = Connect.getConnected();
		
		String sql = "";String sql0 = "", sql1 = "", sql2 = "", sql3 = "", sql4 = "";
		try{
			connection.setAutoCommit(false);
			if(newabstractdescription != null && newabstractdescription.length() > 0)
			{
				sql = "update item set itemAbstract='"+newabstractdescription+"' where itemName='"+olditemName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql0 = sql;
			}
			if(newsecondlevelcategoryName != null && newsecondlevelcategoryName.length() > 0)
			{
				sql = "update item set itemCategory='"+newsecondlevelcategoryName+"' where itemName='"+olditemName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql1 = sql;
			}
			if(!newfilename.endsWith("upload/"))//如果没有上传图片，就不更新
			{
				FileInputStream str = new FileInputStream(newfilename);
				sql="update item set itemImage=? where itemName='"+olditemName+"'";

				PreparedStatement pstmt = connection.prepareStatement(sql);
				pstmt.setBinaryStream(1,str,str.available());
				 
				pstmt.execute();
				pstmt.close();
				str.close();
				sql2 = sql; 
			    
			}
			if(newdescription != null && newdescription.replaceAll("\t", "").length()>0)
			{
				sql="update item set itemText='"+newdescription+"' where itemName='"+olditemName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql3 = sql;
			    
			}
			if(newitemName != null && newitemName.length() > 0)
			{
				sql = "update item set itemName='"+newitemName+"' where itemName='"+olditemName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
				statement.executeUpdate(sql);
				statement.close();
				sql4 = sql;
			}
			connection.commit();
		}catch(SQLException e) {
			 
			e.printStackTrace();
			out.println("<br>项目信息更新，数据库发生错误<b>"+e.toString()+"</b>");
			try {
				connection.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				out.println("<br>项目信息更新，数据库回滚发生错误<b>"+e1.toString()+"</b>");
			}
			Connect.releaseConnection(connection);
			return;//此时不保存更新操作，因为更新没有成功
		}
	    
		Connect.releaseConnection(connection);
		/*
		 *保存数据库更新操作
		 */
		if(sql0.length() > 0)
			UpdateLog.updatelog(false,sql0,"");
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

		out.println("<b>更新项目"+olditemName+"信息成功！</b>");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
    
     %>
  </body>
</html>

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
    
    <title>My JSP 'SecondLevelCategoryInfoUpdateServlet.jsp' starting page</title>
    
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
	   
		String oldsecondlevelcategoryName = su.getRequest().getParameter("oldsecondlevelcategoryName");
		String newparentcategoryName      = su.getRequest().getParameter("newparentcategoryName");
		String newsecondlevelcategoryName = su.getRequest().getParameter("newsecondlevelcategoryName");
		String description  = su.getRequest().getParameter("newdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String filename  = application.getRealPath("/")+"/upload/"+su.getFiles().getFile(0).getFileName();
		
		System.out.println("更改的二级类别图片路径 = "+filename);
		

		if(!filename.endsWith("upload/") && !(filename.endsWith(".png")))
        {
        %>
        <script language="javascript">alert("上传图片格式不正确！"+"\n需要的图片格式为png");
        window.location = "../SecondLevelCategoryInfoUpdate.jsp";</script>
        <% 
        System.out.println("上传项目图片格式不正确");
        return;
        }else if(!filename.endsWith("upload/"))
	    {
	       InputStream isis  = new FileInputStream(filename);
		   BufferedImage src = javax.imageio.ImageIO.read(isis); //构造Image对象
		   int srcWidth  = src.getWidth(null); //得到图片宽
		   int srcHeight = src.getHeight(null); //得到图篇高
	       
	       if(srcWidth >= 135 || srcWidth <= 115 || srcHeight >= 145 || srcHeight <= 125)
	       {
	       %>
	       <script language="javascript"> alert("上传图片像素宽高不符合要求"+"\n需要的最佳宽为125高135");
	      	 window.location = "../SecondLevelCategoryInfoUpdate.jsp";</script>
	       <%
	       
	       return;
	       }
        }
        
		Connection connection = Connect.getConnected();
		String sql = "",sql1 = "",sql2 = "",sql3 = "",sql4 = "";
		try {
			
			connection.setAutoCommit(false);
			if(newparentcategoryName != null && newparentcategoryName.length() > 0)
			{
				sql="update SecondLevelCategory set parentcategoryName='"+newparentcategoryName+"' where categoryName='"+oldsecondlevelcategoryName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
			    sql1 = sql;
			}
			if(!filename.endsWith("upload/"))//如果上传图片才对图片更新
			{
				FileInputStream str = new FileInputStream(filename);
				sql="update secondlevelcategory set categoryImage=? where categoryName='"+oldsecondlevelcategoryName+"'";

				PreparedStatement pstmt = connection.prepareStatement(sql);
				pstmt.setBinaryStream(1,str,str.available());
				 
				pstmt.execute();
				pstmt.close();
				sql2 = sql;
			    
			}
			if(description != null && description.replaceAll("\t", "").length()>0)
			{
				sql="update SecondLevelCategory set description='"+description+"' where categoryName='"+oldsecondlevelcategoryName+"'";

				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql3 = sql;
			    
			}
			if(newsecondlevelcategoryName != null && newsecondlevelcategoryName.length() > 0)
			{
				sql="update SecondLevelCategory set categoryName='"+newsecondlevelcategoryName+"' where categoryName='"+oldsecondlevelcategoryName+"'";


				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);	
				statement.executeUpdate(sql);
				statement.close();
				sql4 = sql;
			    
			}
			connection.commit();

		} catch (SQLException e) {
			 
			e.printStackTrace();
			out.println("<br>更新二级类别，数据库发生错误：<b>"+e.toString()+"</b>");
			try {
				connection.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				out.println("<br>更新二级类别，数据库回滚发生错误：<b>"+e1.toString()+"</b>");
			}
			Connect.releaseConnection(connection);//added by dujintao 20131226
			return;//此时不保存更新操作，因为更新没有成功
		}

		/*
		 * 保存更新日志
		 */
		if(sql1.length() > 0)
			UpdateLog.updatelog(false,sql1,"");
		if(sql2.length() > 0)
			UpdateLog.updatelog(true,sql2,filename);
		if(sql3.length() > 0)
			UpdateLog.updatelog(false,sql3,"");
		if(sql4.length() > 0)
			UpdateLog.updatelog(false,sql4,"");
		
	    Connect.releaseConnection(connection);//added by dujintao 20131226
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
    %>
  </body>
</html>

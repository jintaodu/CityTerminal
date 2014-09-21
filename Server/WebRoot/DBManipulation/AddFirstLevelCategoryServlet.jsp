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
    
    <title>My JSP 'AddFirstLevelCategoryServlet.jsp' starting page</title>
    
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
		response.setCharacterEncoding("UTF-8");
		
	   SmartUpload su = new SmartUpload();
	   su.initialize(pageContext);
	   //su.setAllowedFilesList("png");
	   su.upload();

	   int filecount = su.save("/upload",SmartUpload.SAVE_VIRTUAL);
	   
	   String categoryName = su.getRequest().getParameter("categoryName");
	   String description  = su.getRequest().getParameter("description").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
	   String filename     = application.getRealPath("/")+"/upload/"+su.getFiles().getFile(0).getFileName();
	   
	   if(0 == filecount)
	   {
	   %>
	    <script language="javascript">alert("上传文件个数为0,确认是否上传图片！");
        window.location = "../addFirstLevelCategory.jsp";</script>
	   <%
	     System.out.println("添加一级目录，<b>\""+categoryName+"\"</b>上传文件个数为0,确认是否上传图片！"); 	     
	     return;
	   }
	   
	   if(!filename.endsWith(".png"))
        {
        %>
        <script language="javascript">alert("上传图片格式不正确！"+"\n需要的图片格式为png");
        window.location = "../addFirstLevelCategory.jsp";</script>
        <% 
        System.out.println("上传一级类别图片格式不正确");
        return;
        }
        
	   InputStream isis  = new FileInputStream(filename);
	   BufferedImage src = javax.imageio.ImageIO.read(isis); //构造Image对象
	   int srcWidth  = src.getWidth(null);  //得到图片宽
	   int srcHeight = src.getHeight(null); //得到图片高
       
       if(srcWidth >= 73 || srcWidth <= 53 || srcHeight <= 64 || srcHeight >= 84)
       {
       %>
       <script language="javascript"> alert("上传图片像素宽高不符合要求"+"\n需要的最佳宽为63高74");
      	 window.location = "../addFirstLevelCategory.jsp";</script>
       <% 
       
       return;
       }
        System.out.println("srcWidth ="+srcWidth+"   srcHeight="+srcHeight);
		
		Connection connection = Connect.getConnected();
		String sql = "";
		System.out.println("插入一级类别，类别名："+categoryName);
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
	    System.out.println("成功添加新类别\""+categoryName+"\"到数据库中！");
		
		out.print("<br><b>成功添加新类别<b>\""+categoryName+"\"</b>到数据库中！</b>");
  %>
  </body>
</html>

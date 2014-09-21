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
    
    <title>My JSP 'AddItemServlet.jsp' starting page</title>
    
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
    	request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		SmartUpload su = new SmartUpload();
	    su.initialize(pageContext);
	    //su.setAllowedFilesList("jpg,jpeg");
	    su.upload();
	    int filecount = su.save("/upload",SmartUpload.SAVE_VIRTUAL);
	   
		String secondlevelcategoryName = su.getRequest().getParameter("secondlevelcategoryName");
		String newitemName  = su.getRequest().getParameter("newitemName");
		String description  = su.getRequest().getParameter("description").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String abstractdescription  = su.getRequest().getParameter("abstractdescription").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
		String filename     = application.getRealPath("/")+"/upload/"+su.getFiles().getFile(0).getFileName();
		System.out.println("添加的新项目图片路径 filename = "+filename);
		
		String sql = "";

 		if(0 == filecount)
	    {
	    %>
	   	<script language="javascript">alert("上传文件个数为0,确认是否上传图片！");
        window.location = "../addItem.jsp";</script>
        <%
	      System.out.println("添加项目，<b>\""+newitemName+"\"</b>上传文件个数为0,确认是否上传图片！");
	      //out.print("<br>添加项目，<b>\""+newitemName+"\"</b>上传文件个数为0,确认是否上传图片！");
	      return;
	    }
	    
	    if(!(filename.endsWith(".jpg")||filename.endsWith(".jpeg")))
        {
        %>
        <script language="javascript">alert("上传图片格式不正确！"+"\n需要的图片格式为png");
        window.location = "../addItem.jsp";</script>
        <%
        System.out.println("上传一级类别图片格式不正确");
        return;
        }
        
       InputStream isis  = new FileInputStream(filename);
	   BufferedImage src = javax.imageio.ImageIO.read(isis); //构造Image对象
	   int srcWidth  = src.getWidth(null); //得到图片宽
	   int srcHeight = src.getHeight(null); //得到图篇高
       
       if(srcWidth >= 560 || srcWidth <= 540 || srcHeight >= 310||srcHeight <= 290)
       {
       %>
       <script language="javascript"> alert("上传图片像素宽高不符合要求"+"\n需要的最佳宽为550高300");
      	 window.location = "../addItem.jsp";</script>
       <% 
       
       return;
       }
        System.out.println("srcWidth ="+srcWidth+"   srcHeight="+srcHeight);
	   
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
    %>
  </body>
</html>

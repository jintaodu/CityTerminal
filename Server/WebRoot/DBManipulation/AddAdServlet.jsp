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
    
    <title>My JSP 'AddAdServlet.jsp' starting page</title>
    
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
	    
		String adName = su.getRequest().getParameter("adName");
		String description = su.getRequest().getParameter("description").replaceAll("\r\n", "").replaceAll("\n", "").replaceAll("\r", "");
	    String filename = application.getRealPath("/")+"/upload/"+su.getFiles().getFile(0).getFileName();
		String adPosition  = su.getRequest().getParameter("adPosition");
		
		System.out.println("添加的新广告图片路径 filename = "+filename);
		
   
	    if(0 == filecount)
	    {
	    %>
	   	<script language="javascript">alert("上传文件个数为0,确认是否上传图片！");
        window.location = "../addAd.jsp";</script>
        <%
	      System.out.println("添加广告，<b>\""+adName+"\"</b>上传文件个数为0,确认是否上传图片！");
	      //out.print("<br>添加广告，<b>\""+newitemName+"\"</b>上传文件个数为0,确认是否上传图片！");
	      return;
	    }
	    
	    if(!(filename.endsWith(".jpg")||filename.endsWith(".jpeg")))
        {
        %>
        <script language="javascript">alert("上传图片格式不正确！"+"\n需要的图片格式为jpeg或jpg");
        window.location = "../addAd.jsp";</script>
        <% 
        System.out.println("上传广告图片格式不正确");
        return;
        }
        
		Connection connection = Connect.getConnected();
		
		String sql = "";
		try {
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务			
			sql = "insert into advertisement (adName,adImage,adPosition,description) values ('"+adName+"',?,'"+adPosition+"','"+description+"')";		
			
            FileInputStream fileins = new FileInputStream(filename);
			
			PreparedStatement psmt = connection.prepareStatement(sql);
			psmt.setBinaryStream(1, fileins, fileins.available());

			psmt.execute();
			psmt.close();

			Connect.releaseConnection(connection);//added by dujintao 20131226
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("<b>插入广告"+adName+"时发生错误！</b><br>错误代码："+e.toString());
			Connect.releaseConnection(connection);//added by dujintao 20131226
			System.out.println("插入广告"+adName+"时发生错误！");
			return;
		}
		out.println("<b>插入广告"+adName+"成功！</b>");
		UpdateLog.updatelog(true,sql,filename);
		
     %>
  </body>
</html>

<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="dao.Connect,java.sql.*,MD5.MD5" %>


<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'amend_password.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  <%
    MD5 md5 = new MD5();
    Connection connection = Connect.getConnected();

	String oldkey  = new String(request.getParameter("oldkey").getBytes("ISO8859_1"), "GBK");
	String newkey1 = new String(request.getParameter("newkey1").getBytes("ISO8859_1"), "GBK");
	String newkey2 = new String(request.getParameter("newkey2").getBytes("ISO8859_1"), "GBK");

	String user_keymd5value = md5.getMD5ofStr(oldkey);
	String user_keyfromdb = "";
   	try {
		
		connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		String sql = "select * from user where  userName ='yichuan'";
		ResultSet resultSet =statement.executeQuery(sql);
		if(resultSet.next()){
			user_keyfromdb = resultSet.getString(2);
			System.out.println("user_keyfromdb = "+user_keyfromdb);
		}
		
		if(user_keyfromdb.equals(user_keymd5value))
		{
			sql = "update user set password='"+ md5.getMD5ofStr(newkey1) +"' where userName='yichuan'";
			statement.executeUpdate(sql);
			statement.close();
		}
		else{
		%>
		<script language="javascript"> alert("旧密码错误，请重新输入！");
		window.location = "amend_password.html";</script>
		<%
		}
		
		Connect.releaseConnection(connection);//added by dujintao 20131226
		
	} catch (SQLException e) {
		e.printStackTrace();
		Connect.releaseConnection(connection);//added by dujintao 20131226 
	}
%>
  <body>
    <b>密码修改成功，请牢记您的密码！</b> <br>
  </body>
</html>

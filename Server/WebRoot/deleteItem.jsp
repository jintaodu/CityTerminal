<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="dao.*"%>
<%@ page language="java" import="java.sql.*"%>
<jsp:useBean id="ul" scope="application" class="UpdateLog.UpdateLog" />


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>    
    <title>My JSP 'Test.jsp' starting page</title>
    
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
   	response.setCharacterEncoding("UTF-8");
   	String deleteItemName = (String)request.getParameter("deleteItemName");
   	deleteItemName = new String(deleteItemName.getBytes("ISO-8859-1"), "utf-8");

	System.out.println(deleteItemName);
	Connection connection = Connect.getConnected();
	connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
	String sql="";
	try {
		
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		sql = "delete  from item where itemName ='"+deleteItemName+"'";
		
		statement.execute(sql);
		
		System.out.println("delete item sql = "+sql);
		Connect.releaseConnection(connection);//added by dujintao 20131226
		statement.close();
	} catch (SQLException e) {		 
		e.printStackTrace();
		System.out.println("删除项目\""+deleteItemName+"\"发生数据库错误");
		out.println("<b>删除项目\""+deleteItemName+"\"发生错误</b>");
		Connect.releaseConnection(connection);//added by dujintao 20131226
		return;
	}
	System.out.println("删除项目"+deleteItemName+"成功！");
	out.println("<b>删除项目\""+deleteItemName+"\"成功！</b>");
  	ul.updatelog(false,sql,"");
    %>  
  </body>
</html>

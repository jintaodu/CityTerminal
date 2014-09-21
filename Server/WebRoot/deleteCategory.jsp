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
   	String deleteCategoryName = (String)request.getParameter("deleteCategoryName");
   	deleteCategoryName =new String(deleteCategoryName.getBytes("ISO-8859-1"), "utf-8");
   	String CategoryLevel = (String)request.getParameter("categorylevel");
   	CategoryLevel =new String(CategoryLevel.getBytes(), "utf-8");
  		
		
	System.out.println(deleteCategoryName+"  "+CategoryLevel);
	String sql = "";
	Connection connection = Connect.getConnected();
	connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
	try {
		
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		if(CategoryLevel.equals("first"))
		    sql = "delete  from FirstLevelCategory where categoryName ='"+deleteCategoryName+"'";
		else if(CategoryLevel.equals("second"))
		    sql = "delete  from SecondLevelCategory where categoryName ='"+deleteCategoryName+"'";
		
		statement.execute(sql);
		//response.sendRedirect("manageCurrentCategories.jsp");
		System.out.println(sql);
		Connect.releaseConnection(connection);//added by dujintao 20131226
		statement.close();
		out.println("<b>删除目录"+deleteCategoryName+"成功！</b>");
		
	} catch (SQLException e) {
	
	    out.println("<b>删除目录"+deleteCategoryName+"失败！</b>");
		e.printStackTrace();
		Connect.releaseConnection(connection);//added by dujintao 20131226
		return;
	}
   
    ul.updatelog(false,sql,"");
    %>  
  </body>
</html>

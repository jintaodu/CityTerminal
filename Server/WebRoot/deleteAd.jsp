<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"  %>
<%@ page language="java" import="dao.*"%>

<jsp:useBean id="ul" scope="application" class="UpdateLog.UpdateLog" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
    
    <title>My JSP 'deleteAdd.jsp' starting page</title>
    
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
   	String deleteAdName = (String)request.getParameter("deleteAdName");
   	deleteAdName =new String(deleteAdName.getBytes("ISO-8859-1"), "utf-8");
   		
	String sql="";
	Connection connection = Connect.getConnected();
	connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
	try {
		
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		sql = "delete  from advertisement where adName ='"+deleteAdName+"'";
		statement.execute(sql);
		statement.close();
		System.out.println(sql);
		
	} catch (SQLException e) {			 
		e.printStackTrace();
		out.println("删除广告"+deleteAdName+"发生错误，错误代码为"+e.toString());
		Connect.releaseConnection(connection);
		return;
	}
  
      out.println("删除广告"+deleteAdName+"成功！");
      Connect.releaseConnection(connection);
      ul.updatelog(false,sql,"");
    %>  
  </body>
</html>

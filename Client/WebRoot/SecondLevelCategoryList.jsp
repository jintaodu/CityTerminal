<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="dao.*"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'SecondLevelCategoryList.jsp' starting page</title>
    <link rel="stylesheet" type="text/css" href="css/home.css" />
	<link rel="stylesheet" type="text/css" href="css/communication.css" />
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
   <table align="center">
    <%
    String selectedcategory = new String(request.getParameter("selectedcategory").getBytes("ISO-8859-1"),"UTF-8");
    Connection connection = Connect.getConnected();
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
    String  sql = "select * from SecondLevelCategory where parentcategoryName='"+selectedcategory+"'";
	ResultSet  resultSet = statement.executeQuery(sql);
	  
	  int count = 0;
	  while(resultSet.next())
	  {
	  	count++;
	  	if(count % 3 == 1)
	  	{
     %>
     <tr>
     <td><a href="ItemList.jsp?selectedcategory=<%=resultSet.getString(1)%>">
	    <img name="" src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=second" width="124" height="134" alt="" /></a></td>
     <%} else if(count % 3 == 0){ %>
	    <td><a href="ItemList.jsp?selectedcategory=<%=resultSet.getString(1)%>">
	    <img name="" src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=second" width="124" height="134" alt="" /></a></td>
	    </tr>
	  <%} else
	  	{ %>
  	<td><a href="ItemList.jsp?selectedcategory=<%=resultSet.getString(1)%>">
  	<img name="" src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=second" width="124" height="134" alt="" /></a></td>
	  <%}
	  	}//end of while
	  Connect.releaseConnection(connection);
	  %>
	  </table>
  </body>
</html>

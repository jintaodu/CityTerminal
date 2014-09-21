<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="dao.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
     
    
    <title>My JSP 'browseItems.jsp' starting page</title>
    
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
    Connection connection = Connect.getConnected();
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	String sql = "select * from Item order by itemCategory";
	ResultSet resultSet =statement.executeQuery(sql);	
    
     %>
     <h1>查看所有项目:</h1>
     <table border=1>
     	<tr>
     		<td width="200px"><b>项目名</b></td>
     		<td width="200px"><b>项目所属二级类别</b></td>
     		<td width="200px"><b>项目图片</b></td>
     		<td width="200px"><b>项目文字描述摘要</b></td>
     		<td width="200px"><b>删除</b></td>
     	</tr>
     	
     		<%
     			while(resultSet.next()){
     			%>
     			<tr>
     			<td ><%=resultSet.getString(1)%></td>
     			<td><%=resultSet.getString(3)%></td>
     			<td width="100px">
         		<img id="img" src="itemPic/image.jsp?itemName=<%=resultSet.getString(1)%>" width="110" height="60">
         		</td>
     			<td><%=resultSet.getString(4)%></td>
     			<td><a href="deleteItem.jsp?deleteItemName=<%=resultSet.getString(1)%>">删除该项目</a></td>
     			</tr>
     			<%
     			}
     			Connect.releaseConnection(connection);//added by dujintao 20131226
     		 %>
     	 
     </table>
  </body>
</html>

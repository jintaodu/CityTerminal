<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="dao.*" %> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
    <title>My JSP 'lookAdd.jsp' starting page</title>
    
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
		String sql = "select * from advertisement order by adPosition";			
		ResultSet resultSet =  statement.executeQuery(sql);		
   %>
   <h1>查看现有广告</h1>
   <form method="post" action="">
    <table border=1>
       <tr>
       	<td width="200px"><b>广告名称</b></td>
       	<td width="200px"><b>广告图片</b></td>
       	<td width="200px"><b>广告位置</b></td>
       	<td width="200px"><b>广告备注</b></td>
       	<td width="200px"><b>删除该广告</b></td>
       </tr>
       
       <%
        while(resultSet.next()){
         %>
         <tr>
         	<td width="100px" align=center ><%=resultSet.getString(1)%></td>
         	<td width="100px">
         	<img id="img" src="adPic/image.jsp?adName=<%=resultSet.getString(1)%>">
         	</td>
         	<td width="100px" align=center ><%=resultSet.getString(3)%></td>
         	<td width="100px" ><%=resultSet.getString(4)%></td>
            <td align=center> <a href="deleteAd.jsp?deleteAdName=<%=resultSet.getString(1)%>">删除</a></td>       	
         </tr>
         <%
        }
        Connect.releaseConnection(connection);
        %>

    </table>
   </form>
  </body>
</html>

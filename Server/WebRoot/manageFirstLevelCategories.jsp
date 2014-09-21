<%@ page language="java" import="java.util.*" import="dao.*" import="java.sql.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head> 
    <title>My JSP 'selectCurrentItems.jsp' starting page</title>
    
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
			//Statement statementD = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sql = "select * from FirstLevelCategory";			
			ResultSet resultSet =  statement.executeQuery(sql);
			
   %>
   <h1>管理现有一级类别</h1>
   <form method="post">
    <table border=1>
       <tr >
       	<td width="200px"><b>一级类别名称</b></td>
       	<td width="200px"><b>类别图片</b></td>
       	<td width="200px"><b>类别描述</b></td>
       	<td width="200px"><b>删除类别</b></td>
       </tr>
       
       <%
              
       while(resultSet.next()){
                
       %>
            <tr>
         	<td width="100px"><%=resultSet.getString(1)%></td>
         	<td width="100px">
         	<img id="img" src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=first">
         	</td>
         	<td width="100px" ><%=resultSet.getString(3)%></td><!-- 类别描述文字-->
         	<td> <a href="deleteCategory.jsp?deleteCategoryName=<%=resultSet.getString(1)%>&categorylevel=first">删除</a></td>         	
         </tr>
         <%
        }
        Connect.releaseConnection(connection);
        statement.close();
        %>
       
        <tr>
        	<td></td>
         	<!--<td><input type="submit" value="修改展示项目" /></td>
         --></tr>
    </table>
   </form>
  </body>
</html>


</script>



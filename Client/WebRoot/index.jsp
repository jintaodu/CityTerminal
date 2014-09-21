<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
    
    <title>一级目录</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" type="text/css" href="css/home.css" />
    <title>伊川信息查询</title>

  </head>

<body>
  <%
    Connection connection = Connect.getConnected();
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	String sql = "select * from FirstLevelCategory";	
	ResultSet resultSet =statement.executeQuery(sql);

  %>
<div class="index_pic_2">
<div class="layout_table">
<table cellspacing="50" style="color:#FFF; font-family:微软雅黑,Arial,Verdana,arial,serif; ">
<%
  int count = 0;
  while(resultSet.next())
  {
  System.out.println("size = "+resultSet.getString(1)+"count = "+count);
  count++;
  if ( count % 3 == 1){
%>
	<tr>
	<td>
	<a href="FirstLevelCategoryList.jsp?selectedcategory=<%=resultSet.getString(1)%>"><img src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=first" width="63" height="74" /></a><br/><%=resultSet.getString(1)%>
	</td>
<%
  }
  else if( count % 3 == 2){
 %>
	<td>
	<a href="FirstLevelCategoryList.jsp?selectedcategory=<%=resultSet.getString(1)%>"><img src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=first" width="63" height="74" /></a><br/><%=resultSet.getString(1)%>
	</td>
<%
	}else if( count % 3 == 0 )
 	{
 %>
	 <td><a href="FirstLevelCategoryList.jsp?selectedcategory=<%=resultSet.getString(1)%>"><img src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=first" width="63" height="74" /></a><br/><%=resultSet.getString(1)%>
	 </td>
	 </tr>
<%
  	}//end of if
 }//end of while
 Connect.releaseConnection(connection);//释放数据库连接
 %>
</table>
</div>
  
</div>
</body>
</html>

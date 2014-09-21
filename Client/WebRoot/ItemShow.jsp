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
    
    <title>My JSP 'ItemShow.jsp' starting page</title>
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
<style type="text/css">
body { text-decoration:none ; }
</style>
  </head>
  
  <body >
  <%
    String itemName = request.getParameter("itemName");
    itemName = new String(itemName.getBytes("ISO-8859-1"),"utf-8");
    Connection connection = Connect.getConnected();
    Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
 
 	System.out.println("查看项目，项目名itemName = "+itemName);
    String sql = "select * from item where itemName = '"+itemName+"'";

  	ResultSet resultSet   =   statement.executeQuery(sql);
  	resultSet.next();
   %>
        <table width="753" border="0" style="margin-left:auto;
	    margin-right:auto;">
	    	<tr>
		    <td width="207" align="center">
		    <img name="" src="itemPic/image.jsp?itemName=<%=resultSet.getString(1)%>" width="550" height="300" alt="" />
		    </td>
		    </tr>
		    <tr>
		    <td width="530"><br/><%=resultSet.getString(4)%></td>
		    </tr>
		    <tr>
		    <td><br/><a href="javascript:;" onClick="javascript:history.back(-1);" style="text-decoration:none ;">返回上一页</a></td>
		    </tr>
		  </table>
    <%
    Connect.releaseConnection(connection);
     %>
  </body>
</html>

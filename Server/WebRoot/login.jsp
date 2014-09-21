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
    
    <title>My JSP 'login.jsp' starting page</title>
    <link rel="stylesheet" type="text/css" href="css/login.css" />
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
    Connect.closeCon();//关闭所有数据库连接，重新建立连接
    
    MD5 md5 = new MD5();
    Connection connection = Connect.getConnected();
    String userName = request.getParameter("username");
	String password  = md5.getMD5ofStr(new String(request.getParameter("password").getBytes("ISo-8859-1"),"UTF-8")); 
    String errormsg = "";
   	try {
		
		connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		String sql = "select * from user where  userName ='"+ userName + "' and password='" + password + "'";
		ResultSet resultSet =statement.executeQuery(sql);
		if(resultSet.next()){
			session.setAttribute("username",userName);
			
			response.sendRedirect("manage.jsp");
			
		}
		else{
		%>
		<script language="javascript"> alert("用户名密码错误，请重新输入")</script>
		<%	
			errormsg = "用户名密码错误，请重新输入";
		}
		
		Connect.releaseConnection(connection);//added by dujintao 20131226
		
	} catch (SQLException e) {
		e.printStackTrace();
		errormsg = e.toString();
		Connect.releaseConnection(connection);//added by dujintao 20131226 
	}

    %>

<div class = "index_container">
<div class="index_pic_2">

<div class="layout_table" >
	<form name="myform" action="login.jsp" method="post">
         <table cellSpacing="0" cellPadding="0" width="100%" border="0" height="143" id="table212">
                     
           <tr>
             <td width="18%" height="38" class="top_hui_text"><span class="login_txt">管理员：&nbsp;&nbsp; </span></td>
             <td height="38" colspan="2" class="top_hui_text"><input name="username" class="editbox4" value="" size="20">                            </td>
           </tr>
           <tr>
             <td width="18%" height="35" class="top_hui_text"><span class="login_txt"> 密 码： &nbsp;&nbsp; </span></td>
             <td height="35" colspan="2" class="top_hui_text"><input class="editbox4" type="password" size="20" name="password"></td>
           </tr>
           
           <tr>
             <td height="35" >&nbsp;</td>
             <td width="15%" height="35" ><input name="Submit" type="submit" class="button" id="Submit" value="登 陆"> </td>
             <td width="67%" class="top_hui_text"><input name="cs" type="button" class="button" id="cs" value="取 消" onClick="showConfirmMsg1()"></td>
           </tr>
         </table>
         <br>
     </form>
</div>
  
</div>
</div>

  </body>
</html>

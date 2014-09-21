<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<script language="javascript">
function callnm() {
    window.open('login.htm','call','top=300,left=400,width=600,height=250')
}
</script>
  <head>
    <base href="<%=basePath%>">
    
    <title>登陆</title>
    
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
<h1>登陆界面</h1>
    
                <form name="form1" method="post" action="LoginCheckServlet">
                     <table>
                      <tr> 
                        <td width="43%"><div align="center">用户名:</div></td>
                        <td width="57%"><input name="user_name" type="text" size="14" maxlength="12"></td>
                      </tr>
                      <tr> 
                        <td><div align="center">密　码:</div></td>
                        <td><input name="user_key" type="password" size="14" maxlength="12"></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td><input type="submit" name="Submit" value="登录">
                          　 			 
                          
                      </tr>
                    </table>
                  </form> 

  <table>
  	<tr>
  		<td width=200px>类型</td>
  		<td width=200px>用户名</td>
  		<td width=200px>密码</td>
  	</tr>
  	<tr>
  		<td width=200px>管理员</td>
  		<td width=200px>admin</td>
  		<td width=200px>admin</td>
  	</tr>
  	<tr>
  		<td width=200px>类别组员</td>
  		<td width=200px>category</td>
  		<td width=200px>category</td>
  	</tr>
  	<tr>
  		<td width=200px>广告组</td>
  		<td width=200px>add</td>
  		<td width=200px>add</td>
  	</tr>
  
  </table>


  </body>
</html>

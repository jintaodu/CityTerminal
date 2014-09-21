<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'GenerateUpdatePackage.jsp' starting page</title>
    
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
  <h1> 一键生成并下载更新包</h1>
    	<FORM METHOD=POST ACTION="downloadUpdatefile.jsp">
		<BR><!--
		<table width="90%" border="1" cellspacing="0" bordercolor="#CCCCFF">

			<tr>
				<td>更新包时间段</td>
				<td>开始时间：<select name="updatepackagestartdate">

						<option value="2013-12-24">2013-12-24</option>
						<option value="2013-12-25">2013-12-25</option>
						<option value="2013-12-26">2013-12-26</option>
				</select></td>
				<td>结束时间：<select name="updatepackageenddate">

						<option value="2013-12-24">2013-12-24</option>
						<option value="2013-12-25">2013-12-25</option>
						<option value="2013-12-26">2013-12-26</option>
				</select></td>
			</tr>

			
			<tr>
				<td></td><td><div align="left">
						<input name="立即生成" type="submit" value="立即生成更新包">
					</div>
				</td>
			</tr>
		</table>
		-->
		<br><b>特别提示:</b><br>
		<br> 1）更新包的名称为"更新包.zip"，请勿进行更改和解压！<br>
		<br> 2）服务器端已经自动保留一份更新包，用于通过网络进行自动更新客户端数据库！<br>
		<br> 3）使用U盘拷贝"更新包.zip"，用于手动更新客户端数据库！<br>
		<br> 4）点击下面的按钮下载更新包，注意您的保存路径！<br>
		<br><br><br>
		<input name="立即生成" type="submit" value="立即生成更新包并下载">
		<br>
		
	</form> <br>
  </body>

</html>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="dao.*"%>

 
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<script LANGUAGE="javascript">
		function check() 
		{ 
		   return true;
		}//end of check

	</script>
<body>

	<h1>更新广告信息</h1>
	<%
		Connection connection = Connect.getConnected();
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		String sql = "select * from advertisement";	
		ResultSet resultSet =  statement.executeQuery(sql); 
	 %>
	<FORM name = "adinfoupdate" METHOD=POST ACTION="DBManipulation/AdInfoUpdateServlet.jsp" ENCTYPE="multipart/form-data" onsubmit = "return check()">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">									
			<tr>
				<td>需要更改的广告：（*）</td>
				<td><select name="oldadName">
						<%
							while (resultSet.next()) {
						%>
						<option value=<%=resultSet.getString(1)%>><%=resultSet.getString(1)%></option>
						<%
						}
						Connect.releaseConnection(connection);//added by dujintao 20131226
						%>
				</select></td>
			</tr>
			<tr>
				<td>新广告名称：</td>
				<td><input type="text" name="newadName"/></td>
			</tr>
			
			<tr>
			    <td>广告图片：（jpg或jpeg格式，位置1最佳像素宽198高280，位置2~5最佳像素宽198高135 ，误差在10%以内可接受）</td>
				<td><input type="file" name="newfilename" onchange="" >
				</td>
			</tr>
			<tr>
			    <td>广告位置：（1~5）</td>
				<td><select name="newadPosition">

					<option value=1>1</option>
					<option value=2>2</option>
					<option value=3>3</option>
					<option value=4>4</option>
					<option value=5>5</option>
					
				</select>
				</td>
			</tr>
			 
			<tr><td>广告描述:</td>
				<td><textarea rows=20 cols=60 name="newdescription"></textarea>
				</td>
			</tr>
						 						
		</table>
		
		<BR> <br>
		<input name="提交" value= "提交更改信息" type="submit">
	</form>
	<%
	Connect.releaseConnection(connection);
	%>
</body>
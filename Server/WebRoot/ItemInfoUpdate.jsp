<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="dao.*"%>

 
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
</head>
	
<body>
	<%
	
	Connection  connection = Connect.getConnected();
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
	String sql = "select * from item";	
	ResultSet resultSet =statement.executeQuery(sql);	
	
	 %>
	<h1>更新现有项目信息:</h1>
	
	
	<FORM name = "iteminfoupdate" METHOD=POST ACTION="DBManipulation/ItemInfoUpdateServlet.jsp" ENCTYPE="multipart/form-data" onsubmit="">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">
			
				<tr><td>需要更改的项目名称为：（*）</td>
			    <td>
			    <select name="olditemName">
					<%							
					 while (resultSet.next()) {
					%>
					 <option value=<%=resultSet.getString(1)%>><%=resultSet.getString(1)%></option>
					<%							 
					}
					%>
				</select>
			    </td>
			</tr>
			<%
				sql = "select * from SecondLevelCategory";	
				resultSet =statement.executeQuery(sql);	
			 %>
			<tr><td>更改该项目所属二级类别为：</td>
			    <td>
			    <select name="newsecondlevelcategoryName">
					<%							
					 while (resultSet.next()) {
					%>
					 <option value=<%=resultSet.getString(1)%>><%=resultSet.getString(1)%></option>
					<%							 
					}
					Connect.releaseConnection(connection);//added by dujintao 20131226
					%>
				</select>
			    </td>
			</tr>
			
			<tr>
				<td>更改项目名为：</td>
				<td><input type="text" name="newitemName"/></td>
			</tr>
			
			<tr>
			    <td>更改项目图片：（jpg格式，最佳像素宽550高300 ）</td>
				<td><input type="file" name="newfilename" onchange="" >
				</td>
			</tr>
			
			<tr><td>更改项目简单描述为（50字以内）:</td>
				<td><textarea name="newabstractdescription" rows=10 cols=60></textarea>
				</td>
			</tr>
			
			<tr><td>更改项目详细描述为:</td>
				<td><textarea rows=20 cols=60 name="newdescription"></textarea>
				</td>
			</tr>
							 
		</table>
		
		<BR> <br>
		<input name="提交" value="提交更改信息" type="submit">
	</form>
</body>
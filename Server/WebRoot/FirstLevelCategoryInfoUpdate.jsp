<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="dao.*"%>
<%@ page language="java" import="java.sql.*"%>

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

	<script LANGUAGE="javascript">
		function check() 
		{ 
		  if(document.firstlevelcategoryupdate.newcategoryName.value.length==0 && document.firstlevelcategoryupdate.filename.value.length==0 && document.firstlevelcategoryupdate.newdescription.value.length==0)
		  {
		     alert("无任何更新信息，请输入需要更新的信息!"); 
		     document.firstlevelcategoryupdate.newcategoryName.focus(); 
		     return false; 
		  }
		 }//end of check

	</script>
	
<body>
	<%
		Connection connection = Connect.getConnected();
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		String sql = "select * from FirstLevelCategory";		
		ResultSet resultSet =  statement.executeQuery(sql);
	%>
	<h1>更改一级类别信息</h1>
	<FORM name = "firstlevelcategoryupdate" METHOD=POST ACTION="DBManipulation/FirstLevelCategoryInfoUpdateServlet.jsp" ENCTYPE="multipart/form-data" onsubmit="return check()">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">

			<tr>
			<td>需要更改信息的一级类别为:</td>
				<td><select name="oldcategoryName">
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
				<td>更改类别名为：</td>
				<td><input type="text" name="newcategoryName"/></td>
			</tr>

			<tr>
			    <td>更改类别类别图片为：（png格式，最佳像素宽63高74，误差在10%以内可接受  ）</td>
				<td><input type="file" name="filename" onchange="" >
				</td>
			</tr>
			
			<tr><td>更改类别备注为:</td>
				<td><textarea rows=20 cols=60 name="newdescription"></textarea>
				</td>
			</tr>


		</table>
		<BR> <br>
		<div align="left">
			<input name="提交更改信息" value="提交更改信息内容" type="submit">
		</div>
	</form>
</body>
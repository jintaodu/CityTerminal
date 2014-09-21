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
		  return true();
		}//end of check
		 
	</script>
	
<body>
	<%
		Connection connection = Connect.getConnected();
		Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		String sql = "select * from SecondLevelCategory";			
		ResultSet resultSet =  statement.executeQuery(sql);
		
	%>
	<h1>更改二级类别信息</h1>
	<FORM METHOD=POST ACTION="DBManipulation/SecondLevelCategoryInfoUpdateServlet.jsp" ENCTYPE="multipart/form-data" onsubmit="return check()">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">

			<tr>
			<td>需要更改信息的二级类别为:</td>
				<td><select name="oldsecondlevelcategoryName">
						<%

							while (resultSet.next()) {
						%>
						<option value=<%=resultSet.getString(1)%>><%=resultSet.getString(1)%></option>
						<%
							
						}//end of while
						%>
				</select></td>
			</tr>
		    <%
		     sql = "select * from FirstLevelCategory";
			 ResultSet resultSet1 =  statement.executeQuery(sql);
		    %>
            <tr>
            <td>更改其所属的一级类别为:</td>
            <td><select name="newparentcategoryName">
				<%
					while (resultSet1.next()) {
				%>
				<option value=<%=resultSet1.getString(1)%>><%=resultSet1.getString(1)%></option>
				<%
				}//end of while
				Connect.releaseConnection(connection);//added by dujintao 20131226
				%>
				</select></td>
            </tr>

			<tr>
				<td>更改该二级类别名称为：</td>
				<td><input type="text" name="newsecondlevelcategoryName"/></td>
			</tr>
			<tr>
			    <td>更改二级类别类别图片为：（png格式，最佳像素宽125高135，误差在10%以内可接受 ）</td>
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
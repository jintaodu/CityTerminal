<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="dao.*"%>

 
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
</head>
<script LANGUAGE="javascript">
		function check() 
		{ 
		  if(document.additem.newitemName.value.length==0){
		     alert("项目名不能为空!"); 
		     document.additem.newitemName.focus(); 
		     return false;
		  }
		  if(document.additem.filename.value.length==0){ 
		     alert("项目图片不能为空，请选择项目图片!"); 
		     document.additem.filename.focus();
		     return false; 
		  }
		  return true;

		 }//end of check

</script>
	
<body>
<%
	Connection  connection = Connect.getConnected();
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	String sql = "select * from SecondLevelCategory";
	ResultSet resultSet =statement.executeQuery(sql);

 %>
	<h1>添加新项目:</h1>
	
	
	<FORM name = "additem" METHOD=POST ACTION="DBManipulation/AddItemServlet.jsp" ENCTYPE="multipart/form-data" onsubmit="return check()">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">
			
			<tr><td>项目所属类别为：</td>
			    <td>
			    <select name="secondlevelcategoryName">
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
				<td>项目名（*）：</td>
				<td><input type="text" name="newitemName"/></td>
			</tr>
			
			<tr>
			    <td>项目图片：（jpg格式，最佳像素宽550高300，误差在10%以内可接受 *）</td>
				<td><input type="file" name="filename" onchange="" >
				</td>
			</tr>
			
			<tr><td>项目简单描述（50字以内）:</td>
				<td><textarea name="abstractdescription" rows=10 cols=60></textarea>
				</td>
			</tr>
			
			<tr><td>项目详细描述（*）:</td>
				<td><textarea name="description" rows=20 cols=60></textarea>
				</td>
			</tr>
			
			 
							 
		</table>
		
		<BR> <br>
		<input name="提交" value="提交" type="submit">
	</form>
</body>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="dao.*"%>
<%@ page language="java" import="java.sql.*"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>My JSP 'addCategory.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
	<script LANGUAGE="javascript">
		function check() 
		{ 
		  if(document.addcategory.parentcategoryname.value.length==0){ 
		     alert("无一级类别，请先添加一级类别!"); 
		     document.addcategory.parentcategoryname.focus(); 
		     return false; 
		  }
		  if(document.addcategory.categoryName.value.length==0){ 
		     alert("二级类别名不能为空!"); 
		     document.addcategory.categoryName.focus(); 
		     return false; 
		  }
		  if(document.addcategory.filename.value.length==0){ 
		     alert("二级类别图片不能为空，请选择类别图片!"); 
		     document.addcategory.filename.focus();
		     return false; 
		  }

			return true;
		 }//end of check
		 
	</script>

<%
      Connection connection = Connect.getConnected();
	  Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	  String sql = "select * from FirstLevelCategory";			
	  ResultSet resultSet =statement.executeQuery(sql);
 %>

  <body>
    <h1>添加“二级”新类别:</h1>
	<FORM name = "addcategory" METHOD=POST ACTION="DBManipulation/AddSecondLevelCategoryServlet.jsp" ENCTYPE="multipart/form-data" onsubmit="return check()">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">

   			<!---------------从数据库中读取有哪些一级类别，将新的二级类别添加到一级类别下面--------------->
			<tr>
			    <td>添加到的一级类别名：(*)</td>
				<td><select name="parentcategoryname">

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
			<!---------------添加新的二级类别--------------->
			<tr>
				<td>新类别名：（*）</td>
				<td><input type="text" name="categoryName"/></td>
			</tr>
			<tr>
			    <td>类别图片：（png格式，最佳像素宽125高135，误差在10%以内可接受 *）</td>
				<td><input type="file" name="filename" onchange="" >
				</td>
			</tr>
			
			<tr><td>类别备注:</td>
				<td><textarea rows=20 cols=60 name="description"></textarea>
				</td>
			</tr>
			<tr><td><b>* 表示必填项</b></td>
			</tr>
	 
		</table>
		
		<BR> <br>
		<input name="提交" value="提交" type="submit">
	</form>
  </body>
</html>

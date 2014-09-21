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
		  if(document.addad.adName.value.length==0){
		     alert("广告名不能为空!"); 
		     document.addad.adName.focus(); 
		     return false;
		  }
		  if(document.addad.filename.value.length==0){ 
		     alert("广告图片不能为空，请选择广告图片!"); 
		     document.addad.filename.focus();
		     return false; 
		  }
        	return true;
		}//end of check

	</script>
<body>

	<h1>添加新广告</h1>
	
	<FORM name = "addad" METHOD=POST ACTION="DBManipulation/AddAdServlet.jsp" ENCTYPE="multipart/form-data" onsubmit = "return check()">
		<BR>
		<table width="40%" border="1" cellspacing="0" bordercolor="#CCCCFF">									
			<tr>
				<td>广告名：（*）</td>
				<td><input type="text" name="adName"/></td>
			</tr>
			
			<tr>
			    <td>广告图片：（jpg或jpeg格式，位置1最佳像素宽198高280，位置2~5最佳像素宽198高135，误差在10%以内可接受 *）</td>
				<td><input type="file" name="filename" onchange="" >
				</td>
			</tr>
			<tr>
			    <td>广告位置：（*，1~5）</td>
				<td><select name="adPosition">

					<option value=1>1</option>
					<option value=2>2</option>
					<option value=3>3</option>
					<option value=4>4</option>
					<option value=5>5</option>
					
				</select>
				</td>
			</tr>
			 
			<tr><td>广告描述:</td>
				<td><textarea name="description" rows=20 cols=60 ></textarea>
				</td>
			</tr>
						 						
		</table>
		
		<BR> <br>
		<input name="提交" type="submit">
	</form>
</body>
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>文件上传</title>
<script language="javascript">
function yanzheng() 
{ 
        var img_1=document.getElementById("img_1"); 
		alert("dddddddddddddddddddddddddddddd");
        img_1.src=myform1.file1.value;//加上这句，获取到的width就是图片的分辨率
        alert(img_1.width);  //图片宽 
         alert(img_1.height);  //图片高 
          if(img_1.width>100) 
        { 
          alert("宽大于100了"); 
          return;//如果宽大于100，返回逼供内提示； 
          } 
} 

</script>
</head>

<body>
<img src="" name="img_1" id="img_1" style="visibility:hidden">
<table width="50%" valign="botom" height="22" border="1">
<!--存在两个不同表单所以需要不同的名字-->
<form  method="post" name="myform1" enctype="multipart/form-data" >
<tr>
  <td><input type="file" name="file1" size="20" /></td>
  <td><input type="button" value="上传" onClick="yanzheng()" >
  </td>
</tr>
</form>
</table> 
</body>
</html>


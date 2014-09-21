<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="dao.*"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <link rel="stylesheet" type="text/css" href="css/home.css" />
	<link rel="stylesheet" type="text/css" href="css/communication.css" />
	<title>伊川信息查询</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<div class="index_pic">
<div class="c">

<img src="pic1/top.jpg" width="1280" height="126" border="0" usemap="#Map" />
  <map name="Map" id="Map">
    <area shape="rect" coords="1154,34,1230,90" href="index.jsp" target="_self" />
  </map>
</div>

    <div class="divLeft">
    <div class="left" ><table width="217" border="0" cellpadding="0" cellspacing="0" class="a_color">
     <tr>
     <td  ><table><tr>
    <td  width="205" height="50"></td>
    
  </tr>
  <%
  
    String selectedcategory = new String(request.getParameter("selectedcategory").getBytes("ISO-8859-1"),"UTF-8");
    Connection connection = Connect.getConnected();
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	String sql = "select * from FirstLevelCategory";	
	ResultSet resultSet =statement.executeQuery(sql);
  %>
  <%
    while(resultSet.next())
    {
   %>
  <tr>
    <td  width="205" height="56" align="center"  style="padding:0px; " ><div class="ctr">
    <table style="color:#FFF; font-family:微软雅黑,Arial,Verdana,arial,serif; ">
    <tr><td height="56">
    <a href="FirstLevelCategoryList.jsp?selectedcategory=<%=resultSet.getString(1)%>">
    <img src="categoryPic/image.jsp?categoryName=<%=resultSet.getString(1)%>&categorylevel=first" width="33" height="40" /></a> </td>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;<%=resultSet.getString(1)%>
    </td></tr>
    </table>
    </div></td>
    <td width="12" class="gap">
    <%if(selectedcategory.equals(resultSet.getString(1)))
    { %>
    <img src="pic1/triangle.png" width="12" height="14" />
    <%
    }//end of if %>
    </td>
  </tr>  
  <%
   }//end of while
   //Connect.releaseConnection(connection);//用完的连接放回连接池
   %>
  </table></td>
  <tr>
</table>
 
</div>
</div>

<div class="divRight">
    
    <div class="right"><table width="200" border="0" cellpadding="0" cellspacing="0" >
    <%
      sql = "select * from advertisement where adPosition='1'";
	  resultSet = statement.executeQuery(sql);
	  resultSet.next();
	  System.out.println("123 = "+resultSet.getString(1));
     %>
  <tr>   
    <td ><img src="adPic/image.jsp?adName=<%=resultSet.getString(1)%>" width="198" height="280" /></td>
  </tr>
      <%
      sql = "select * from advertisement where adPosition='2'";
	  resultSet = statement.executeQuery(sql);
	  resultSet.next();
     %>
  <tr>
    <td><img src="adPic/image.jsp?adName=<%=resultSet.getString(1)%>" width="198" height="135" /></td>
  </tr>
  <%
      sql = "select * from advertisement where adPosition='3'";
	  resultSet = statement.executeQuery(sql);
	  resultSet.next();
     %>
  <tr>
    <td><img class="img_1" src="adPic/image.jsp?adName=<%=resultSet.getString(1)%>" width="199" height="135" /></td>
  </tr>
    <%
      sql = "select * from advertisement where adPosition='4'";
	  resultSet = statement.executeQuery(sql);
	  resultSet.next();
     %>
  <tr>
    <td><img class="img_1" src="adPic/image.jsp?adName=<%=resultSet.getString(1)%>" width="198" height="135" /></td>
  </tr>
  
     <%
      sql = "select * from advertisement where adPosition='5'";
	  resultSet = statement.executeQuery(sql);
	  resultSet.next();
     %>
     
  <tr>
    <td><img  class="img_1" src="adPic/image.jsp?adName=<%=resultSet.getString(1)%>" width="199" height="135" /></td>
  </tr>
</table>
</div>
</div>

  <div class="divCenter">
    <div style="height:15px; background-color:#cacbc5;"></div>
     
    <div class="main">
       
       <div class="bar"><%=selectedcategory%></div>
       <br/><br/><br/><br/>
        <div style="width:845px;"></div>
        
		<table align="center">
        <tr>
            <td>
        <iframe frameborder="0" width="800" height="600" src="SecondLevelCategoryList.jsp?selectedcategory=<%=selectedcategory%>" style="margin-left:auto;
	    margin-right:auto;" scrolling="no"></iframe>
        </td></tr>
        </table>
</div>
</div>

</div>
</body>
</html>

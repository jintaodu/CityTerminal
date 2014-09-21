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
    
    <title>My JSP 'ItemList.jsp' starting page</title>
    <link rel="stylesheet" type="text/css" href="css/home.css" />
<link rel="stylesheet" type="text/css" href="css/communication.css" />
    
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
     <%     
  //变量声明     
   
  int   intPageSize;   //一页显示的记录数       
  int   intPage;   //待显示页码     
  String   strPage;     
  int   i;     
    
  //设置一页显示的记录数    
  intPageSize = 4;
    
  //取得待显示页码
  strPage   =   request.getParameter("page");
  if(strPage == null){//表明在QueryString中没有page这一个参数，此时显示第一页数据     
  	  intPage   =   1;
  }
  else{//将字符串转换成整型     
	  intPage   =   Integer.parseInt(strPage);     
	  if(intPage<1)   intPage   =   1;
  } 
  
  	String selectedsecondcategory =(String)request.getParameter("selectedcategory");
  	selectedsecondcategory = new String(selectedsecondcategory.getBytes("ISO-8859-1"),"utf-8");
   
    Connection connection = Connect.getConnected();
    Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
  //准备SQL语句     
  //strSQL   =   "select * from bmbm";     
    String sql = "select * from item where itemCategory = '"+selectedsecondcategory+"'";
  //执行SQL语句并获取结果集     
  	ResultSet resultSet   =   statement.executeQuery(sql);
    
  //获取记录总数     
  	resultSet.last();     
  	int intRowCount = resultSet.getRow();     
    
  //记算总页数    
  	int intPageCount = (intRowCount+intPageSize-1) / intPageSize;     
    
  //调整待显示的页码     
  	if(intPage > intPageCount) intPage = intPageCount;     
  %>
  
  <div class="divCenter">
    
    <div class="main">

        <div style="width:845px;"></div>
        
        <table width="753" border="0" style="margin-left:auto;
	    margin-right:auto;">
	    <%
	    if(intPageCount>0){
  		//将记录指针定位到待显示页的第一条记录上
	    resultSet.absolute((intPage-1)   *   intPageSize   +   1);
	    i   =   0;     
  		while(i < intPageSize && !resultSet.isAfterLast()){  
	     %> 
		  <tr>
		    <td width="207">
		    <a   href="ItemShow.jsp?itemName=<%=resultSet.getString(1)%>">
		    <img name="" src="itemPic/image.jsp?itemName=<%=resultSet.getString(1)%>" width="198" height="135" alt="" /></a>
		    </td>
		    <td width="530"><%=resultSet.getString(4)%></td>
		  </tr>
			<%
				i++;
				resultSet.next();
				}//end of while
			  }//end of if
			 %>
</table>

	</div>
</div>

<br/>

	<%
	Connect.releaseConnection(connection);
	%>
    
  		第<%=intPage%>页
     	共<%=intPageCount%>页
      <a   href="ItemList.jsp?selectedcategory=<%=selectedsecondcategory%>" style="text-decoration:none ;">首页</a>
        <%if(intPage < intPageCount){%><a   href="ItemList.jsp?page=<%=intPage+1%>&selectedcategory=<%=selectedsecondcategory%>" style="text-decoration:none ;">下一页</a><%}%>   
          <%if(intPage > 1){%><a   href="ItemList.jsp?page=<%=intPage-1%>&selectedcategory=<%=selectedsecondcategory%>" style="text-decoration:none ;">上一页</a><%}%>     
      <a  href="ItemList.jsp?page=<%=intPageCount%>&selectedcategory=<%=selectedsecondcategory%>" style="text-decoration:none ;">末页</a>

  </body>
</html>
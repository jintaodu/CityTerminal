<%@ page language="java" import="java.util.*,java.io.*" pageEncoding="utf-8"%>
<%@ page language="java" import="org.dom4j.Document,org.dom4j.DocumentException,org.dom4j.Element,org.dom4j.io.SAXReader,org.dom4j.io.XMLWriter" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'deleteClientInfo.jsp' starting page</title>
    
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
    request.setCharacterEncoding("UTF-8");
   	response.setCharacterEncoding("UTF-8");
   	
    String clientnumber = (String) request.getParameter("clientnumber");
    clientnumber = new String(clientnumber.getBytes("ISO-8859-1"), "utf-8");
    
    SAXReader sax = new SAXReader();
    File file = new File("C:/clientinfo.xml");
    Document doc = sax.read(new FileInputStream(file));
    Element root = doc.getRootElement();
	List<Element> els = root.elements();
    System.out.println("clientnumber = "+clientnumber);
	for(Element e : els){
	  if(e.attributeValue("Number").equals(clientnumber))
		{ 
			root.remove(e);
			XMLWriter output = new XMLWriter(new FileOutputStream(file));
	    	output.write(doc);
	    	output.close();
			%>
			<script language = "javascript"> alert("删除客户机信息成功！");window.location = "MonitorClientNetworkState.jsp";</script>
			<% 
		}
	}
	%>
	<script language = "javascript"> alert(out.println("删除错误！"));</script>	


     
  </body>
</html>

<%@ page language="java" import="java.util.*,java.io.*,java.text.SimpleDateFormat,java.text.DecimalFormat" pageEncoding="utf-8"%>
<%@ page language="java" import="org.dom4j.Document,org.dom4j.DocumentException,org.dom4j.Element,org.dom4j.io.SAXReader,org.dom4j.io.XMLWriter" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'MonitorClientNetworkState.jsp' starting page</title>
    
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
    <h1>查看客户机网络状态:</h1>
    <div id="ShowDiv"></div> 
    <br>
	<script language='javascript' type='text/javascript'> 
	var secs =30; //倒计时的秒数 
 
	function Timer(){ 
	
	for(var i=secs;i>=0;i--)
	{ 
	window.setTimeout('doUpdate(' + i + ')', (secs-i) * 1000); 
	} 
	} 
	function doUpdate(num) 
	{ 
		document.getElementById('ShowDiv').innerHTML = '将在'+num+'秒后自动刷新 ......' ; 
		if(0 == num) window.location.reload();	
	} 
	</script> 
	</head> 
	
	<script language="javascript"> 
	Timer(); 
	</script> 

     <table border=1>
     	<tr>
     		<td width="200px" align=center><b>客户机编号</b></td>
     		<td width="200px" align=center><b>客户机地址</b></td>
     		<td width="200px" align=center><b>上次更新时间</b></td>
     		<td width="200px" align=center><b>未更新时间</b></td>
     		<td width="200px" align=center><b>删除本条信息</b></td>
     	</tr>
     	
     		<%
     		SimpleDateFormat ft = new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");
     		DecimalFormat df = new DecimalFormat("#.00");
     		//SimpleDateFormat ft = new SimpleDateFormat("yyyy/MM/dd/hh/mm/ss");
     		Date currenttime = new Date();
     		SAXReader sax = new SAXReader();
     		File file = new File("C:/clientinfo.xml");
     		if(!file.exists())
     		{
     			file.createNewFile();
     			BufferedWriter bw = new BufferedWriter(new FileWriter(file));
     			bw.write("<ClientInfo>\r\n</ClientInfo>");
     			bw.flush();
     			bw.close();
     		}
     		Document doc = sax.read(new FileInputStream(file));
     		Element root = doc.getRootElement();
			List<Element> els = root.elements();
			
			for(Element e : els){
		    %>	
		    <tr>
    			<td align=center><%=e.attributeValue("Number")%></td>
    			<td align=center><%=e.attributeValue("Address")%></td>
    			<td align=center><%=ft.format(ft.parse(e.attributeValue("LastUpdateTime")))%></td>
    			<%
    			  double timespan_hour = (currenttime.getTime() - ft.parse(e.attributeValue("LastUpdateTime")).getTime())/1000/60.0/60.0;
    			  if(timespan_hour > 24.0)//超过24小时显示红色
    			  { 
    			%>
    			
    			<td align=center><font size="3" color="red"><%=df.format(timespan_hour)%>小时</font></td>
    			<%
    			}else {
    			 
    			%>
    			
    			<td align=center><%=df.format(timespan_hour)%>小时</td>
    			<%}
    			 %>
    			<td align=center><a href="deleteClientInfo.jsp?clientnumber=<%= e.attributeValue("Number")%>">删除</a></td>
    			</tr>
		   <% 
		   }
		   %>
	
 
     </table>
  </body>
</html>

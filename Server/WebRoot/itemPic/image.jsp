<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="dao.*"%>

<html>
	<head>

	</head>
	<body>

		
		<%
		request.setCharacterEncoding("UTF-8");
   		response.setCharacterEncoding("UTF-8");
		String itemName = (String)request.getParameter("itemName");
		itemName = new String (itemName.getBytes("ISO-8859-1"), "utf-8");
		System.out.println("itemName="+itemName);
		Connection con = Connect.getConnected();
		
		try {
			
			Statement statement = con.createStatement(
			ResultSet.TYPE_SCROLL_SENSITIVE,
			ResultSet.CONCUR_UPDATABLE);

			String sql = "select itemImage from item where itemName='"+ itemName + "'";	
				
			ResultSet r = statement.executeQuery(sql);
			ServletOutputStream sout = response.getOutputStream();
			while (r.next()) {

                System.out.println("从数据库中读取项目图片！");
				InputStream in = r.getBinaryStream("itemImage");
				response.setContentType("image/jpeg");
				response.reset();
				byte b[] = new byte[1024];
				int length = 1024;
				while ((length = in.read(b)) != -1) {
					sout.write(b, 0, length);
				}									 
								 
			}
			sout.flush();
			sout.close();
			statement.close();
			Connect.releaseConnection(con);//added by dujintao 20131226
			 
		} catch (SQLException ee) {
			ee.printStackTrace();
			out.print("读取项目图片时，发生错误！"+ee.toString());
			Connect.releaseConnection(con);//added by dujintao 20131226
		}
		%>
	</body>
</html>
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
		String adName = new String (request.getParameter("adName").getBytes("ISO-8859-1"), "utf-8");
		System.out.println("读取广告图片 adName = "+adName);
		
		try {
			Connection con = Connect.getConnected();
			Statement statement = con.createStatement(
			ResultSet.TYPE_SCROLL_SENSITIVE,
			ResultSet.CONCUR_UPDATABLE);

			String sql = "select adImage from advertisement where adName='"+ adName + "'";	
				
			ResultSet r = statement.executeQuery(sql);
			//ServletOutputStream sout = response.getOutputStream();
			OutputStream os = response.getOutputStream();
			while (r.next()) {

                System.out.println("从数据库中读取广告图片！");
				InputStream in = r.getBinaryStream("adImage");
				response.setContentType("image/jpeg");
				response.reset();
				byte b[] = new byte[1024];
				int length = 1024;
				while((length = in.read(b)) > -1)
				{
				  os.write(b,0,length);
				}
				os.flush();
				os.close();
				in.close();
	
				/*while ((length = in.read(b)) != -1) {
					sout.write(b, 0, length);					
				}*/									 
				//sout.close();					 
			}
			//sout.flush();
			//sout.close();
			 
			Connect.releaseConnection(con);//added by dujintao 20131226
		} catch (SQLException ee) {
			ee.printStackTrace();
			out.print("查看广告，读取图片时，数据库错误！");
		}
		%>
	</body>
</html>
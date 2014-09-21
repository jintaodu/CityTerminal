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
		String categoryName = (String)request.getParameter("categoryName");
		categoryName = new String (categoryName.getBytes("ISO-8859-1"), "utf-8");
		
		String CategoryLevel = (String)request.getParameter("categorylevel");
   		CategoryLevel =new String(CategoryLevel.getBytes(), "utf-8");
   	
		System.out.println("目录名："+categoryName+"  CategoryLevel"+CategoryLevel);
		
		String sql = "";
		try {
			Connection con = Connect.getConnected();
			Statement statement = con.createStatement(
			ResultSet.TYPE_SCROLL_SENSITIVE,
			ResultSet.CONCUR_UPDATABLE);

			if(CategoryLevel.equals("first"))
			 	sql = "select categoryImage from FirstLevelCategory where categoryName='"+ categoryName + "'";
			else if(CategoryLevel.equals("second"))
				sql = "select categoryImage from SecondLevelCategory where categoryName='"+ categoryName + "'";
				
			ResultSet r = statement.executeQuery(sql);
		    //ServletOutputStream sout = response.getOutputStream();
		    OutputStream os = response.getOutputStream();
			while (r.next()) {
                System.out.println("从数据库中读取类别图片！");
				InputStream in = r.getBinaryStream("categoryImage");
				
				response.setContentType("image/jpeg");
				response.reset();
				int length; byte[] b = new byte[1024];
				while((length = in.read(b)) > -1)
				{
				  os.write(b,0,length);
				}
				in.close();
				os.flush();
				os.close();
				/*byte b[] = new byte[1024];
				int length = 1024;
				while ((length = in.read(b)) != -1) {
					sout.write(b, 0, length);						
				}*/
				//sout.close();				 
			}
			//sout.flush();
			//sout.close();	
			Connect.releaseConnection(con);//added by dujintao 20131226		 
		} catch (SQLException ee) {
			ee.printStackTrace();
			System.out.println("数据库连接失败！");
		}
		
		%>
	</body>
</html>
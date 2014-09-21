package ServerSocket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

public class ServerSocketUpdatePackageListener implements ServletContextListener {

	private SocketThread socketThread;
	public void contextDestroyed(ServletContextEvent e) {
		if (socketThread != null && socketThread.isInterrupted()) {
			socketThread.closeServerSocket();
			socketThread.interrupt();
	}
	}
	public void contextInitialized(ServletContextEvent e) {
		ServletContext servletContext = e.getServletContext();
		if ( socketThread == null) {
			socketThread = new SocketThread(null, servletContext);
			socketThread.start(); // servlet上下文初始化时启动socket服务端线程
		}
	}
	
/*	public static void main(String[] args) {
		// TODO Auto-generated method stub

		try{
			ServerSocket server = new ServerSocket(8189);

			int threadid = 0;
			while(true)
			{
				Socket incoming = server.accept();
				Runnable r =  new ThreadEchoHandler(incoming,threadid);
				Thread t = new Thread(r);
				t.start();
				threadid++;
			}
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}*/

}
class SocketThread extends Thread {
	private ServletContext servletContext;
	private ServerSocket serverSocket;
	private int threadid = 0;
	public SocketThread(ServerSocket serverSocket, ServletContext servletContext) {
		this.servletContext = servletContext;
		// 从web.xml中context-param节点获取socket端口
		String port = this.servletContext.getInitParameter("socketPort");
		if (serverSocket == null) {
			try {
				this.serverSocket = new ServerSocket(Integer.parseInt(port));
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	public void run() {
		while (!this.isInterrupted()) { // 线程未中断执行循环
			try {
			Socket socket = serverSocket.accept();
			socket.setSoTimeout(10000);
			if (socket != null)
				new ProcessSocketData(socket, threadid++).start();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	public void closeServerSocket() {
		try {
		if (serverSocket != null && !serverSocket.isClosed())
			serverSocket.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

class ProcessSocketData extends Thread{
	
	private Socket incoming;
	private int threadid;
	
	public ProcessSocketData() {
		super();
	}
	public ProcessSocketData(Socket socket, int threadid) {
		this.incoming = socket;
		this.threadid = threadid;
	}

	public void run()
	{
		System.out.println("111111111111111");
		XMLProcessor.invokexmlprocessor(incoming, threadid);System.out.println("33333333333");
	}

}
class XMLProcessor{
	
	public static int init_count = 0;//被初始化的次数
	public static Document doc = null;
	
	private static File file = new File("C:/clientinfo.xml");
	
	public XMLProcessor() throws DocumentException, InterruptedException, IOException
	{
		SAXReader sax = new SAXReader();

		if(!file.exists())
 		{
 			file.createNewFile();
 			BufferedWriter bw = new BufferedWriter(new FileWriter(file));
 			bw.write("<ClientInfo>\r\n</ClientInfo>");
 			bw.flush();
 			bw.close();
 		}
	    doc = sax.read(new FileInputStream(file));

	}
	public synchronized static void invokexmlprocessor(Socket incoming, int threadid)
	{
		try
		{
			try{
				System.out.println("22222222222222");
				byte[] buffer = new byte[1024];
				int length,index;
				
				InputStream in = incoming.getInputStream();			
				BufferedInputStream bis = new BufferedInputStream(in);
				
				StringBuilder ClientInfo = new StringBuilder();
				System.out.println("444444444444444444");
		        while((length = bis.read(buffer)) != -1)
		        {
		        	String temp = new String(buffer,0,length,"UTF-8");
		        	if((index = temp.indexOf("eof")) != -1)
		        	{
		        		ClientInfo.append(temp.substring(0, index));
		        		break;
		        	}
		        	ClientInfo.append(temp);

		        }//end of while
		        
		        System.out.println("ClientInfo = "+ClientInfo);
		        
		        try{
		        	//System.out.println("1111111112222221111");
		        	XMLProcessor xmlprocessor = new XMLProcessor();
		        	//System.out.println("111111111111666666661");
		        }catch(Exception e)
		        {
		        	e.printStackTrace();
		        }
		        //System.out.println("1111111111111111");
		        String[] info = ClientInfo.toString().split("####");
		        
		               
				OutputStream out = incoming.getOutputStream();
	            BufferedOutputStream bos = new BufferedOutputStream(out);
				
	            if(new File("C://更新包.zip").exists())
	            {
					bis = new BufferedInputStream(new FileInputStream("C://更新包.zip"));
					//System.out.println(1111);
					while((length = bis.read(buffer))!=-1)
					{					
						bos.write(buffer,0,length);
						bos.flush();
						//System.out.println("发送！");
					}
					bis.close();
					bos.close();
					System.out.println("服务端线程"+threadid+"传送结束");
	            }else{
	            	bos.write("NoUpdatePackageeof".getBytes("utf-8"));
	            	bos.flush();
	            	bos.close();
	            	bis.close();
	            	System.out.println("无更新包可以传送！");
	            	return;
	            }
	            
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH时mm分ss秒");
		        
		        if(XMLProcessor.clientexist(info[0]))
		        {
		        	XMLProcessor.setLastUpdateTime(info[0], sdf.format(new Date()));
		        }else
		        {
		        	XMLProcessor.addElement(info[0], info[1], sdf.format(new Date()));
		        }
		        
		        XMLProcessor.SaveXML();
		        				
			}finally
			{
				incoming.close();
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}

	
	public static  boolean addElement(String number, String address, String lastupdatetime)
	{
		Element root = doc.getRootElement();
		
		Element client = root.addElement("Client");
        //添加客户机编号属性值	
        client.addAttribute("Number" , number);
        //添加客户机地址属性值	
        client.addAttribute("Address" , address);
        //添加客户机最新更新时间属性值	
        client.addAttribute("LastUpdateTime" , lastupdatetime);
        
		return true;
	}
	public static boolean clientexist(String number)
	{
		Element root = doc.getRootElement();
		 List<Element> els = root.elements();
		    for(Element e : els){
		    	//System.out.println(e.attributeValue("Number"));
		    	if(e.attributeValue("Number").equals(number))
		    	{
		    		return true;
		    	}
		    }
	
		return false;
	}
	public static boolean setLastUpdateTime(String number, String lastupdatetime)
	{
		 Element root = doc.getRootElement();
		 List<Element> els = root.elements();
		    for(Element e : els){
		    	//System.out.println(e.attributeValue("Number"));
		    	if(e.attributeValue("Number").equals(number))
		    	{
		    		e.attribute("LastUpdateTime").setValue(lastupdatetime);
		    		//System.out.println("+++++++++++");
		    	}
		    }
	
		return true;
	}
	
   public static boolean SaveXML() throws IOException, InterruptedException
   {
		 //重新写入到文件
       System.out.println("保存XML文件！");
	    XMLWriter output = new XMLWriter(new FileOutputStream(file));
	    output.write(doc);
	    output.close();

	    return true;
   }
    		
	

}

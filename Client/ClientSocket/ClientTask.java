package ClientSocket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimerTask;

import yichuan.gov.Servlet.UpdateClientDBServlet;


public class ClientTask extends TimerTask {

	/**
	 * @param args
	 */
	public void run()
	{
		try{

			Socket socket = new Socket("10.171.6.72",8189);
			System.out.println(socket);
			if(socket == null) return;
			
			System.out.println("与服务端连接成功！");
			Date t = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
			System.out.println(sdf.format(t));
			
			BufferedInputStream bis = new BufferedInputStream(socket.getInputStream());
			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(new File("C://更新包.zip")));
			byte[] buffer = new byte[1024];
			int length = bis.read(buffer);
			if(new String(buffer,0,length,"UTF-8").equals("NoUpdatePackage"))
			{
				System.out.println("NoUpdatePackage");
				return;
			}
			else bos.write(buffer,0,length);
			while((length = bis.read(buffer))!=-1)
			{
				bos.write(buffer,0,length);	
			}
			bos.close();
			bis.close();
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println("无法与服务端连接！");
			return;
		}
		
		try {
			System.out.println("开始更新数据库");
			UpdateClientDBServlet updateclient = new UpdateClientDBServlet();
			updateclient.updateclientdb();
			System.out.println("更新数据库结束");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ClientTask clienttask = new ClientTask();
		clienttask.run();
			
	}
}


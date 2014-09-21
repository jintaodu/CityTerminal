package UpdateLog;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;


public class UpdateLog {

	/**
	 * @param args
	 */
	private String updatepackname;
	private static String updatelogpath="C:\\更新日志";
	public UpdateLog()
	{
		File updatelogdir = new File(updatelogpath);
		try{
			if(!updatelogdir.exists())
			{
				updatelogdir.mkdir();
			}
			else{
				//cleanupdatepack();
			}
		}catch(Exception e)
		{
			System.err.println("新建更新包出错");
			e.printStackTrace();
		}
	}
	public  void cleanupdatepack()//将更新包中的内容清除,更新包中不包含文件夹
	{
		File updatepackdir = new File(updatelogpath);
		File[] files = updatepackdir.listFiles();
		for(File f : files)
		{
			f.delete();
		}
	}
	public  static boolean updatelog(boolean bImage,String sql,String filePath)
	{//bImage记录是否是image变更1/0
		Date t = new Date(System.currentTimeMillis());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
		String date = sdf.format(t);
		File updatelogdir = new File(updatelogpath);
		if(!updatelogdir.exists())
		{
			updatelogdir.mkdir();
		}
		File sqlfile = new File(updatelogpath+"\\sql.txt");
		if(!sqlfile.exists()) sqlfile.exists();
		String currentTimesMillis = String.valueOf(System.currentTimeMillis());
		try{
			OutputStreamWriter bw = new OutputStreamWriter(new FileOutputStream(sqlfile,true),"UTF-8");
			String sql_info;
			if(bImage) sql_info = date+"::::1::::"+sql+"::::"+currentTimesMillis+(new File(filePath)).getName()+"\r\n";
			else sql_info = date+"::::0::::"+sql+"::::noFile\r\n";
			bw.write(sql_info);
			bw.flush();
			bw.close();
			
		}catch(Exception e)
		{
			e.printStackTrace();
			return false;
		}
		if(bImage)//如果是图片需要拷贝图片到更新日志目录下
		{
			try
			{
				copyfile(filePath,currentTimesMillis);
			}catch(Exception e)
			{
				System.err.println("拷贝文件"+filePath+"出错！");
				e.printStackTrace();
				return false;
			}
		}
		
		return true;
		
	}
	private  static boolean copyfile(String filePath, String currentTimesMillis)//将filePath文件拷贝到updatepack目录下，文件名保持原样
	{
		try {
	           int bytesum = 0; 
	           int byteread = 0; 
	           File oldfile = new File(filePath);
	           if (oldfile.exists()) { //文件存在时 
	               FileInputStream inStream = new FileInputStream(filePath); //读入原文件
	               File outfile = new File(updatelogpath+"\\"+currentTimesMillis+oldfile.getName());
	               //System.out.println("456123="+ updatepackpath+"\\"+oldfile.getName());
	               if(outfile.exists()) outfile.delete();
	               outfile.createNewFile();
	               FileOutputStream fos = new FileOutputStream(outfile); 
	               
	               byte[] buffer = new byte[1444]; 
	               int length; 
	               while (( byteread = inStream.read(buffer)) != -1) { 
	                   bytesum += byteread; //字节数 文件大小 
	                   //System.out.println(bytesum); 
	                   fos.write(buffer, 0, byteread); 
	                   fos.flush();
	               }
	               fos.close();
	               inStream.close(); 
	           }//end of if 
	           else
	           {
	        	   System.err.println("文件"+filePath+"不存在！");
	        	   return false;
	           }
	       }//end of try
	       catch (Exception e) { 
	           System.err.println("复制单个文件"+filePath+"操作出错"); 
	           e.printStackTrace(); 
               return false;
	       }
		return true;
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		UpdateLog up = new UpdateLog();
		String currentTimesMillis = String.valueOf(System.currentTimeMillis());
		up.copyfile("C:\\Users\\mmdb\\Workspaces\\MyEclipse 9\\Tour\\WebRoot\\images\\001.jpg",currentTimesMillis);
		TimeZone.setDefault(TimeZone.getTimeZone("Asia/Shanghai"));
		Date t = new Date(System.currentTimeMillis());
		SimpleDateFormat matter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
		System.out.println(matter.format(t));
	}

}

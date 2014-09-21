package FileZip;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;

public class ZipUtils {

	/**
	 * @param args
	 */
	/**
	 * ѹ���ļ�-����outҪ�ڵݹ������,���Է�װһ����������
	 * ����ZipFiles(ZipOutputStream out,String path,File... srcFiles)
	 * @param zip
	 * @param path
	 * @param srcFiles
	 * @throws IOException
	 * @author isea533
	 */
	public static void ZipFiles(String zipdir,String path,String updatepackdir) throws IOException{
		File[] srcFiles = (new File(updatepackdir)).listFiles();
		File zip = new File(zipdir);
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zip));
		ZipFiles(out,path,srcFiles);
		out.close();
		System.out.println("*****************ѹ�����*******************");
	}
	/**
	 * ѹ���ļ�-File
	 * @param zipFile  zip�ļ�
	 * @param srcFiles ��ѹ��Դ�ļ�
	 * @author isea533
	 */
	private static void ZipFiles(ZipOutputStream out,String path,File... srcFiles){
		path = path.replaceAll("\\*", "/");
		if(!path.endsWith("/")){
			path+="/";
		}
		byte[] buf = new byte[1024];
		try {
			for(int i=0;i<srcFiles.length;i++){
				if(srcFiles[i].isDirectory()){
					File[] files = srcFiles[i].listFiles();
					String srcPath = srcFiles[i].getName();
					srcPath = srcPath.replaceAll("\\*", "/");
					if(!srcPath.endsWith("/")){
						srcPath+="/";
					}
					out.putNextEntry(new ZipEntry(path+srcPath));
					ZipFiles(out,path+srcPath,files);
				}
				else{
					FileInputStream in = new FileInputStream(srcFiles[i]);
					System.out.println(path + srcFiles[i].getName());
					out.putNextEntry(new ZipEntry(path + srcFiles[i].getName()));
					int len;
					while((len=in.read(buf))>0){
						out.write(buf,0,len);
					}
					out.closeEntry();
					in.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * ��ѹ��ָ��Ŀ¼
	 * @param zipPath
	 * @param descDir
	 * @author isea533
	 */
	public static void unZipFiles(String zipPath,String descDir)throws IOException{
		unZipFiles(new File(zipPath), descDir);
	}
	/**
	 * ��ѹ�ļ���ָ��Ŀ¼
	 * @param zipFile
	 * @param descDir
	 * @author isea533
	 */
	@SuppressWarnings("rawtypes")
	public static void unZipFiles(File zipFile,String descDir)throws IOException{
		//��ѹzip�ļ�
		File pathFile = new File(descDir);
		if(!pathFile.exists()){
			pathFile.mkdirs();
		}
		ZipFile zip = new ZipFile(zipFile);
		for(Enumeration entries = zip.getEntries();entries.hasMoreElements();){
			ZipEntry entry = (ZipEntry)entries.nextElement();
			String zipEntryName = entry.getName();
			System.out.println("zipEntryName = "+zipEntryName);
			InputStream in = zip.getInputStream(entry);
			String outPath = (descDir+zipEntryName).replaceAll("\\*", "/");;
			//�ж�·���Ƿ����,�������򴴽��ļ�·��
			File file = new File(outPath.substring(0, outPath.lastIndexOf('/')));
			if(!file.exists()){
				file.mkdirs();
			}
			//�ж��ļ�ȫ·���Ƿ�Ϊ�ļ���,����������Ѿ�����,����Ҫ��ѹ
			if(new File(outPath).isDirectory()){
				continue;
			}
			//����ļ�·����Ϣ
			System.out.println("outPath = "+outPath);
			
			OutputStream out = new FileOutputStream(outPath);
			byte[] buffer = new byte[1024];
			int len;
			while((len = in.read(buffer))>0){
				out.write(buffer,0,len);
			}
			in.close();
			out.close();
			}//end of for
		System.out.println("******************��ѹ���********************");
	}
	public static void main(String[] args) throws IOException {
		/**
		 * ѹ���ļ�
		 */
		//File[] files = new File[]{new File("d:/English"),new File("d:/��������.xls"),new File("d:/��������.xls")};
		//File zip = new File("d:/ѹ��.zip");
		//ZipFiles("d:/ѹ��.zip","abc","D://���°�");
		
		/**
		 * ��ѹ�ļ�
		 */
		File zipFile = new File("d:/ѹ��.zip");
		String path = "d:/zipfile/";
		unZipFiles(zipFile, path);
	}

}

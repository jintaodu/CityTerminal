package ClientSocket;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Timer;

public class ClientTimer {

	/**
	 * @param args
	 */
	public ClientTimer()
	{
        ClientTask clienttask = new ClientTask();
		
		Timer timer = new Timer();
		
		timer.schedule(clienttask, 100000,150000);
	}
	
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub

		ClientTimer client = new ClientTimer();
		System.out.println("123");
		InputStreamReader isr = new InputStreamReader(new FileInputStream("C:\\updatepackage\\sql.txt"),"UTF-8");
    	BufferedReader br_isr = new BufferedReader(isr);
    	System.out.println(br_isr.readLine());
	}

}

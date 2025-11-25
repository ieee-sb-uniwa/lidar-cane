using Godot;
using System;
using System.Text;  
using System.Net;
using System.Net.Sockets;
using System.Linq;  
using System.IO.Ports;
using System.Runtime.InteropServices;


public partial class automatic_connection : Node
{
	SerialPort serialPort;
	String ipAddress = "";
	public bool ipSent = false;
	public override void _Ready()
	{
		// Getting host name
		string host = Dns.GetHostName();
		// Getting ip address using host name
		IPHostEntry ip = Dns.GetHostEntry(host);
		//lambda function to get the ipv4 and not the ipv6 (internetwork is ipv4)
		var ipv4 = ip.AddressList.FirstOrDefault(a => a.AddressFamily == AddressFamily.InterNetwork);
		GD.Print(ipv4);
		ipAddress = ipv4.ToString();
		//find the available serial ports of the compute
		string[] ports = SerialPort.GetPortNames();

		foreach (string port in ports)
		{
			GD.Print(port);
		}

		//connect to the serial port the raspberry pi is connected
		serialPort = new SerialPort();
		//bad solution, it won't work if there is any other serial comm device connected to the computer
		if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
		{
			serialPort.PortName = ports[1];
		}
		else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
		{
			serialPort.PortName = ports[0];
		}
		//have the same baudrate as in raspi
		serialPort.BaudRate = 9600; 

		serialPort.Open();

	}
	public override void _Process(double delta)
	{ //checks if serial port and the ip hasn't been send already is open, if it's not do nothing.
		if (!serialPort.IsOpen && ipSent == false) return;
		if(ipAddress!=""){}
			serialPort.Write(ipAddress);
			ipSent = true;
	}
}

import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: startConnect())),
    );
  }
}

class startConnect extends StatelessWidget {
  const startConnect({super.key});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (contect) => const QrScannerPage()),
        );
      },
      child: Text('TextButton'),
    );
  }
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

String? parseMacAddress(String qrContent) {
  try {
    // 1. Split by semicolons to get the parts
    // Parts will be: [BT:MAC:90:94:97:9E:A8:40, NAME:HuaweiP9Lite, ...]
    List<String> parts = qrContent.split(';');
    
    // 2. Find the part that starts with 'BT:MAC:'
    String macPart = parts.firstWhere((e) => e.contains('MAC:'));
    
    // 3. Remove the 'BT:MAC:' prefix to get just the address
    return macPart.replaceAll('BT:MAC:', '');
  } catch (e) {
    print("Parsing error: $e");
    return null;
  }
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (result) async {
          if (isProcessing) return;
          final String? rawValue = result.barcodes.first.rawValue;
          if (rawValue != null) {
            // Extract just the MAC address from the Huawei-style string
            String? cleanMac = parseMacAddress(rawValue);

            if (cleanMac != null) {
              setState(() => isProcessing = true);
              
              
              print("Clean MAC Found: $cleanMac");
              await connectBle(context, cleanMac);
              
              if (mounted) Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}

Future<void> connectBle(BuildContext context, String deviceId) async {
  var status = await Permission.bluetoothScan.request();
  var connectStatus = await Permission.bluetoothConnect.request();
  var locationStatus = await Permission.location.request();
  if (status.isGranted && connectStatus.isGranted) {
    print("Permissions granted!");
    

    AvailabilityState state =
        await UniversalBle.getBluetoothAvailabilityState();
    // Start scan only if Bluetooth is powered on
    if (state == AvailabilityState.poweredOn) {
     print("Attempting to connect to: $deviceId");
      // 2. Connect directly using the ID from QR
      await UniversalBle.connect(deviceId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connected to $deviceId")),
        );
        Navigator.pop(context); // Go back to home screen
      }
  } 
  }else {
    print("Permissions denied. Check App Info settings.");
    // Open settings so the user can manually enable "Nearby Devices"
    openAppSettings();
  }
}

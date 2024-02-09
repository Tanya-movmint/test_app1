import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + QR code'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter your URL'),
            ),
          ),
          //This button when pressed navigates to QR code generation
          ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('QR Code'),
                    ),
                    body: Center(
                      child: QrImageView(
                        data: controller.text,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: const Text('GENERATE QR CODE'),
          )
        ],
      ),
    );
  }

}




class QRCodeScannerApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _QRCodeScannerAppState createState() => _QRCodeScannerAppState();
}

class _QRCodeScannerAppState extends State<QRCodeScannerApp> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool canShowQRScanner = false; // Flag to determine if the scanner can be shown

  @override
  void initState() {
    super.initState();
    getCameraPermission(); // Call the method to check camera permission
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
        ),
        body: canShowQRScanner // Show QR scanner only if camera permission is granted
            ? Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: _qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('Scan a QR code'),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(), // Show loading indicator while checking permission
              ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller.scannedDataStream.listen((scanData) {
        print('Scanned data: ${scanData.code}');
        // Handle the scanned data as desired
      });
    });
  }

  Future<void> getCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          canShowQRScanner = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enable camera to scan barcodes')));
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        canShowQRScanner = true;
      });
    }
  }
}

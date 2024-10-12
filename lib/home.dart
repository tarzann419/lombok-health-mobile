import 'package:demo1/screens/nfc_write_screen.dart';
import 'package:demo1/screens/register_user.dart';
import 'package:flutter/material.dart';
import 'nfc_scan_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Lombok project!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterUserScreen(), // Navigate to NfcScanScreen
                  ),
                );
              },
              child: Text('Register User'),
            ),ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NfcScanScreen(), // Navigate to NfcScanScreen
                  ),
                );
              },
              child: Text('Scan NFC Card'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NfcWriteScreen(matricNo: '',), // Navigate to NfcScanScreen
                  ),
                );
              },
              child: Text('Write to Card'),
            ),
          ],
        ),
      ),
    );
  }
}
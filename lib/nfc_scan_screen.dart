// nfc_scan_screen.dart
import 'dart:convert';
import 'package:demo1/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcScanScreen extends StatefulWidget {
  @override
  _NfcScanScreenState createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends State<NfcScanScreen> {
  String _nfcData = 'Scan an NFC card to get details';
  final ApiService _apiService = ApiService(); // Set your base URL

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability();
  }

  Future<void> _checkNfcAvailability() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _nfcData = 'NFC is not available on this device';
      });
    }
  }

  Future<void> _startNfcScan() async {
    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef == null) {
            setState(() {
              _nfcData = 'This tag is not NDEF formatted';
            });
            return;
          }

          NdefMessage? ndefMessage = await ndef.read();
          if (ndefMessage == null || ndefMessage.records.isEmpty) {
            setState(() {
              _nfcData = 'No NDEF records found';
            });
            return;
          }

          // Parse the NDEF message to extract the content
          String nfcContent = ndefMessage.records
              .map((record) => String.fromCharCodes(record.payload.sublist(record.payload[0] + 1)))
              .join('\n');

          Map<String, dynamic> scannedData = _parseNfcData(nfcContent);

          if (scannedData.isNotEmpty) {
            String scannedMatNo = scannedData['mat_no'] ?? '';

            // Fetch user details by mat_no from the API service
            await _fetchUserDetails(scannedMatNo);
          }

          await NfcManager.instance.stopSession();
        },
      );
    } catch (error) {
      setState(() {
        _nfcData = 'Error reading NFC card: $error';
      });
    }
  }

  // Function to parse NFC data as JSON
  Map<String, dynamic> _parseNfcData(String nfcContent) {
    try {
      return Map<String, dynamic>.from(jsonDecode(nfcContent));
    } catch (e) {
      return {};
    }
  }

  // Fetch user details by mat_no from the API service
  Future<void> _fetchUserDetails(String matricNo) async {
    try {
      final userData = await _apiService.fetchUserDetails(matricNo);
      print(userData);

      setState(() {
        _nfcData = 'User found: ${userData['first_name']} ${userData['last_name']}';
      });
    } catch (error) {
      setState(() {
        _nfcData = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Scan Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _nfcData,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNfcScan,
              child: Text('Start NFC Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
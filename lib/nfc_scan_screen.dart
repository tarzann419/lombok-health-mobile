import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcScanScreen extends StatefulWidget {
  @override
  _NfcScanScreenState createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends State<NfcScanScreen> {
  String _nfcData = 'Scan an NFC card to get details';

  // Define a random array of maps to simulate existing data
  List<Map<String, dynamic>> predefinedData = [
    {"id": 1, "mat_no": "item1"},
    {"id": 2, "mat_no": "item2"},
    {"id": 3, "mat_no": "BHU/21/04/05/0079"}, // Example item for matching
    {"id": 4, "mat_no": "item4"},
  ];

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

          // check if tag has ndef data
          var ndef = Ndef.from(tag);
          if (ndef == null) {
            setState(() {
              _nfcData = 'This tag is not NDEF formatted';
            });
            return;
          }

          // read ndef message
          NdefMessage? ndefMessage = await ndef.read();
          if (ndefMessage == null || ndefMessage.records.isEmpty) {
            setState(() {
              _nfcData = 'No NDEF records found';
            });
            return;
          }

          // parse ndef message
          String nfcContent = ndefMessage.records
              .map((record) => String.fromCharCodes(record.payload.sublist(record.payload[0] + 1)))
              .join('\n'); // Join multiple records

          // fetch mat_no from the NFC content
          // assuming the content is JSON formatted
          Map<String, dynamic> scannedData = _parseNfcData(nfcContent);

          if (scannedData.isNotEmpty) {
            String scannedMatNo = scannedData['mat_no'] ?? '';

            // Check if the scanned mat_no exists in predefined data
            bool isMatch = predefinedData.any((item) => item['mat_no'] == scannedMatNo);

            setState(() {
              if (isMatch) {
                _nfcData = 'Match found for mat_no: $scannedMatNo';
              } else {
                _nfcData = 'No match found for mat_no: $scannedMatNo';
              }
            });
          }

          await NfcManager.instance.stopSession();
        },
      );
    } catch (error) {
      setState(() {
        _nfcData = 'Error reading NFC card: $error';
      });
    }

    return; // Explicitly return void
  }

  Map<String, dynamic> _parseNfcData(String nfcContent) {
    try {
      // Parse the NFC content as JSON
      return Map<String, dynamic>.from(jsonDecode(nfcContent));
    } catch (e) {
      // Handle parsing error if the content is not in JSON format
      return {};
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
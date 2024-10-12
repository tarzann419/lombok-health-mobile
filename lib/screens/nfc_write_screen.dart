import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcWriteScreen extends StatefulWidget {
  final String matricNo;

  NfcWriteScreen({required this.matricNo}); // Receiving matric_no from previous screen

  @override
  _NfcWriteScreenState createState() => _NfcWriteScreenState();
}

class _NfcWriteScreenState extends State<NfcWriteScreen> {
  String _statusMessage = 'Tap an NFC card to write JSON data';
  late TextEditingController _matNoController;
  int _id = 1; // Simulating auto-incrementing ID

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the passed matric_no
    _matNoController = TextEditingController(text: widget.matricNo);
  }

  Future<void> _writeNfcData() async {
    if (_matNoController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Matriculation number cannot be empty';
      });
      return;
    }

    // Create the JSON object with the auto-incremented ID and the input mat_no
    Map<String, dynamic> jsonData = {
      'id': _id++,
      'mat_no': _matNoController.text,
    };

    try {
      // Convert the JSON data to a string
      String jsonString = jsonEncode(jsonData);

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef == null || !ndef.isWritable) {
            setState(() {
              _statusMessage = 'This tag is not NDEF writable';
            });
            return;
          }

          // Create an NDEF record containing the JSON string
          NdefRecord ndefRecord = NdefRecord.createText(jsonString);
          NdefMessage ndefMessage = NdefMessage([ndefRecord]);

          // Write the NDEF message to the tag
          await ndef.write(ndefMessage);
          setState(() {
            _statusMessage = 'JSON data written successfully!';
          });

          await NfcManager.instance.stopSession();
        },
      );
    } catch (error) {
      setState(() {
        _statusMessage = 'Failed to write JSON data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Write JSON'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _matNoController,
              decoration: InputDecoration(
                labelText: 'Matriculation Number',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _writeNfcData,
              child: Text('Write JSON to NFC Tag'),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
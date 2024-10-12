import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'nfc_reader.dart'; // Import the reader class
import 'nfc_writer.dart'; // Import the writer
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // Set HomeScreen as the entry point
    );
  }
}


// class MyAppState extends State<MyApp> {
//   ValueNotifier<dynamic> result = ValueNotifier(null);
//   late NfcReader nfcReader;
//   late NfcWriter nfcWriter;
//
//   @override
//   void initState() {
//     super.initState();
//     nfcReader = NfcReader(result); // Initialize the reader
//     nfcWriter = NfcWriter(result); // Initialize the writer
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('NfcManager Plugin Example')),
//         body: SafeArea(
//           child: FutureBuilder<bool>(
//             future: NfcManager.instance.isAvailable(),
//             builder: (context, ss) => ss.data != true
//                 ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
//                 : Flex(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               direction: Axis.vertical,
//               children: [
//                 Flexible(
//                   flex: 2,
//                   child: Container(
//                     margin: EdgeInsets.all(4),
//                     constraints: BoxConstraints.expand(),
//                     decoration: BoxDecoration(border: Border.all()),
//                     child: SingleChildScrollView(
//                       child: ValueListenableBuilder<dynamic>(
//                         valueListenable: result,
//                         builder: (context, value, _) =>
//                             Text('${value ?? ''}'),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   flex: 3,
//                   child: GridView.count(
//                     padding: EdgeInsets.all(4),
//                     crossAxisCount: 2,
//                     childAspectRatio: 4,
//                     crossAxisSpacing: 4,
//                     mainAxisSpacing: 4,
//                     children: [
//                       ElevatedButton(
//                           child: Text('Tag Read'),
//                           onPressed: () => nfcReader.readTag()), // Call the reader
//                       ElevatedButton(
//                           child: Text('Ndef Write'),
//                           onPressed: () => nfcWriter.writeNdef()), // Call the writer
//                       ElevatedButton(
//                           child: Text('Go to Home'),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => HomeScreen(), // Navigate to home.dart
//                               ),
//                             );
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
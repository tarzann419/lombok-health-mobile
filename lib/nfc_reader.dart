import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';


class NfcReader{
  final ValueNotifier<dynamic> result;

  NfcReader(this.result);

  void readTag() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }
}
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class ModalDialog{
  static AwesomeDialog dangerDialog(BuildContext context){
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      title: "Error"
    );
  }
}
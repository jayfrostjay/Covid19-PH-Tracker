import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DialogUtil{
  static ProgressDialog awesomeLoader(BuildContext context, String message) {
    ProgressDialog dialog = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    dialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: AwesomeLoader(loaderType: AwesomeLoader.AwesomeLoader4, color: Colors.blue,),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400)
    );
    return dialog;
  }
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'app_color.dart';

void showAppToast({required String? msg, bool isForError = false}) {
  if (msg == null || msg.isEmpty) {
    return;
  }

  Fluttertoast.cancel();

  Fluttertoast.showToast(
    msg: msg,
    toastLength: isForError ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: isForError ? 1 : 1,
    backgroundColor: isForError ? AppColor.errorColor : AppColor.appColor,
    textColor: Colors.white,
    fontSize: isForError ? 14.0 : 16.0,
  );
}

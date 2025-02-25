import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastCase {
  success,
  error,
}

  void flutterShowToast({required message, required ToastCase toastCase}) {
    switch (toastCase) {
      case ToastCase.success:
        return flutterToast(message: message, state: ToastCase.success);
      case ToastCase.error:
        return flutterToast(message: message, state: ToastCase.error);
    }
  }


void flutterToast({required message, required state}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor(toastCase: state),
      textColor: Colors.white,
      fontSize: 16.0);
}

Color toastColor({required ToastCase toastCase}) {
  switch (toastCase) {
    case ToastCase.success:
      return Colors.green;
    case ToastCase.error:
      return Colors.red;
  }
}

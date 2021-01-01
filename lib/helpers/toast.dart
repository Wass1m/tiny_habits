import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tinyhabits/styles/styles.dart';

void toast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: kSecondaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

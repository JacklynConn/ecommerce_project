import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String mainUrl = "http://192.168.1.4:8000";
String apiUrl = "$mainUrl/api";
String imageUrl = "$mainUrl/repairer/";

alertMsg(
    {required BuildContext context,
    String title = "Message",
    String content = "Message content.",
    String btnName = "OK"}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.red),
              ),
              content: Text(content),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(btnName),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          : AlertDialog(
              title: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.red),
              ),
              content: Text(content),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(btnName),
                )
              ],
            );
    },
  );
}

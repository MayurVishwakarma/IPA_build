import 'package:flutter/material.dart';

class Utils{
  static showSnackbar({required BuildContext context,String? content="Something went wrong"}){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      content: Text(content.toString(),style:const TextStyle(fontSize: 14,fontWeight: FontWeight.normal),)));
  }
}
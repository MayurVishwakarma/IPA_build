import 'package:flutter/material.dart';
import 'package:timesheet/models/login_details.dart';
getDecoration(String hint) {
  return InputDecoration(
    isDense: true,
    filled: true,
    hintText: hint,
    // hintText: hint,
    fillColor: Colors.white,
    border: const OutlineInputBorder()
    // fillColor: const Color.fromARGB(255, 228, 228, 228),
  );
}

class Constants{
  static const conString="ezg3M2ZjNWZlLTBjMDAtMTFlZS1iZTU2LTAyNDJhYzEyMDAwMjk3YTg2ZTc4LTE3NGItNDFmNS05MjEzLWU1ZGRiZjE1YjgzZX0";
}
LoginDetails testLoginDetails=LoginDetails(
  isLatemarked: false,
  isEarlyLeave: false,
  isLateLeave: false,
  isEarlymarked: false,
  
);
SizedBox height10= const SizedBox(height: 10);
SizedBox width5= const SizedBox(width: 5);


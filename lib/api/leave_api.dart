// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/app/constants.dart';
import 'package:timesheet/app/utils.dart';
import 'package:timesheet/models/leave_history.dart';

import 'package:http/http.dart' as http;
import 'package:timesheet/provider/data_provider.dart';

class LeaveApi {
  static getLeavehistory(BuildContext context) async {
    final dtProvider = Provider.of<DataProvider>(context, listen: false);
    await dtProvider.getUserIdFromSharedPred();
    var url =
        "http://timesheet.seprojects.in/api/ver1/leavedata/${Constants.conString}/${dtProvider.userId}/${DateTime.now().year}";

    try {
      var response = await http.get(Uri.parse(url));
      var result = jsonDecode(response.body);

      if (result["Status"] == "Success") {
        var history = LeaveHistoryModel.fromJson(result);
        dtProvider.updateLeaveHistoryModel(history);
      } else {
        Utils.showSnackbar(
          context: context,
        );
      }
    } catch (e) {
      Utils.showSnackbar(context: context, content: e.toString());
    }
  }

  static applyLeave(BuildContext context,String reason) async{
    final dtProvider = Provider.of<DataProvider>(context, listen: false);
    if(dtProvider.fromDate != null && dtProvider.toDate != null && dtProvider.leaveType != null){
      dtProvider.updateIsLoading(value: true,isNotify: true);
    await dtProvider.getUserIdFromSharedPred();
    var leaveData = {
      "uid": dtProvider.userId.toString(),
      "leaveType": dtProvider.getLeaveType(dtProvider.leaveType??"WP"),
      "from": DateFormat("yyyy-MM-dd").format(dtProvider.fromDate??DateTime.now()),
      "to":  DateFormat("yyyy-MM-dd").format(dtProvider.toDate??DateTime.now()),
      "halfOrFull": dtProvider.halfOrFull??"NA",
      "half": dtProvider.halfLeaveType??"NA",
      "reason": reason,
      "IsSystemGen": "0",
      "balance":(dtProvider.balenceLeaves == 0.0) ? "365": dtProvider.balenceLeaves.toString()
    };
    var url ="http://timesheet.seprojects.in/api/ver1/leave/${Constants.conString}";
    try {
      var response=await http.post(Uri.parse(url),body: leaveData);
      var result = jsonDecode(response.body);
        if (result["Status"] == "Success") {
        dtProvider.updateIsLoading(value: false,isNotify: true);
        if(result['data'][0]["Status"]  =="Success" ){
          Utils.showSnackbar(context: context,content: "Leave applied successfully");
        }else{
          Utils.showSnackbar(context: context,content: result['data'][0]["Status"].toString());
        }
        
      } else {
        dtProvider.updateIsLoading(value: false,isNotify: true);
        Utils.showSnackbar(
          context: context,
        );
      }
    } catch (e) {
      dtProvider.updateIsLoading(value: false,isNotify: true);
      Utils.showSnackbar(context: context);
      
    }
    }else{
      Utils.showSnackbar(context: context,content: "All field are mandatory");
    }
    
  }
}

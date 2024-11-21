// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/app/constants.dart';
import 'package:timesheet/app/utils.dart';
import 'package:timesheet/models/login_details.dart';
import 'package:timesheet/screens/calender/calender.dart';

import '../provider/data_provider.dart';

class LoginApi {
  static login(BuildContext context, String username, String password) async {
    // var testUrl =
    //     "http://timesheet.seprojects.in/api/ver1/login/${Constants.conString}/vaibhj/vaibh@1263";
    final dtProvider = Provider.of<DataProvider>(context, listen: false);
    dtProvider.updateIsLoginLoading(value: true, isNotify: true);
    try {
      var url =
          "http://timesheet.seprojects.in/api/ver1/login/${Constants.conString}/$username/$password";

      var response = await http.get(Uri.parse(url));
      final result = json.decode(response.body);
      if (result['Status'] == "Success") {
        bool res = await Provider.of<DataProvider>(context, listen: false)
            .addDataToSharedPref(result['data']['userId'],
                result['data']['firstName'], result['data']['lastName']);
        if (res) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, CalenderScreen.routeName);
          }
        }
        Utils.showSnackbar(context: context, content: "Sign In Successfully");
        dtProvider.updateIsLoginLoading(value: false, isNotify: true);
      } else if (result['Status'] == "Error") {
        dtProvider.updateIsLoginLoading(value: false, isNotify: true);
        Utils.showSnackbar(context: context, content: result['Error']);
      } else {
        dtProvider.updateIsLoginLoading(value: false, isNotify: true);
        Utils.showSnackbar(
            context: context, content: "${response.statusCode} error");
      }
    } catch (e) {
      dtProvider.updateIsLoginLoading(value: false, isNotify: true);
      Utils.showSnackbar(context: context, content: e.toString());
    }
  }

  static loginInSystem(BuildContext context) async {
    final dtProvider = Provider.of<DataProvider>(context, listen: false);

    try {
      dtProvider.updateIsLoginLoading(value: true, isNotify: true);
      if (dtProvider.loginType != null) {
        await dtProvider.getUserIdFromSharedPred();
        Position position = await Geolocator.getCurrentPosition();
        if (!position.isMocked) {
          var curlat =
              19.203352; //position.latitude; //19.218725  Kandivali: 19.203352,72.847511;
          var curlon = 72.864023; // position.longitude; //72.864023;
          var url =
              "http://timesheet.seprojects.in/api/ver1/insertLogin/${Constants.conString}/${dtProvider.userId}/${dtProvider.loginType}/${curlat},${curlon}";
          var response = await http.post(Uri.parse(url));
          var result = jsonDecode(response.body);

          if (response.statusCode == 200) {
            if (result['Status'] == "Success") {
              dtProvider.updateIsLoginLoading(value: false, isNotify: true);
              final loginDetails = LoginDetails.fromJson(result['data']);
              dtProvider.updateLoginDetails(loginDetails);
              Utils.showSnackbar(
                  context: context, content: "logged in successfully");
            } else if (result['Status'] == "Error") {
              dtProvider.updateIsLoginLoading(value: false, isNotify: true);
              Utils.showSnackbar(
                  context: context, content: result['Error'].toString());
            }
          }
        } else {
          dtProvider.updateIsLoginLoading(value: false, isNotify: true);
          dtProvider.showFakeLocationError(context);
        }
      } else {
        dtProvider.updateIsLoginLoading(value: false, isNotify: true);
        Utils.showSnackbar(
            context: context, content: "Please Select Login Type");
      }
    } catch (e) {
      dtProvider.updateIsLoginLoading(value: false, isNotify: true);
      if (e.toString().contains("location")) {
        Utils.showSnackbar(
            context: context, content: "location required to login");
      } else {
        Utils.showSnackbar(context: context, content: e.toString());
      }
    }
  }

  static logoutFromSystem(BuildContext context) async {
    final dtProvider = Provider.of<DataProvider>(context, listen: false);
    try {
      dtProvider.updateIsLoginLoading(value: true, isNotify: true);
      Position position = await Geolocator.getCurrentPosition();

      if (!position.isMocked) {
        var curlat =
            19.203352; //position.latitude; //19.218725  Kandivali: 19.203352,72.847511;
        var curlon = 72.864023; // position.longitude; //72.864023;
        var url =
            "http://timesheet.seprojects.in/api/ver1/insertLogout/${Constants.conString}/${dtProvider.userId}/${curlat},${curlon}";
        var response = await http.patch(Uri.parse(url));
        var result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          if (result['Status'] == "Success") {
            dtProvider.updateIsLoginLoading(value: false, isNotify: true);
            final loginDetails = LoginDetails.fromJson(result['data']);
            dtProvider.updateLoginDetails(loginDetails);
            Utils.showSnackbar(
                context: context, content: "logged out successfully");
          } else if (result['Status'] == "Error") {
            dtProvider.updateIsLoginLoading(value: false, isNotify: true);
            Utils.showSnackbar(
                context: context, content: result['Error'].toString());
          }
        }
      } else {
        dtProvider.updateIsLoginLoading(value: false, isNotify: true);
        dtProvider.showFakeLocationError(context);
      }
    } catch (e) {
      dtProvider.updateIsLoginLoading(value: false, isNotify: true);
      Utils.showSnackbar(context: context, content: e.toString());
    }
  }

  static getLoginInformation(BuildContext context, DateTime date) async {
    final dtProvider = Provider.of<DataProvider>(context, listen: false);
    dtProvider.updateIsLoading(value: true);
    dtProvider.disposeLoginDetails();
    try {
      final formattedDate = DateFormat("yyyyMMdd").format(date);
      var url =
          "http://timesheet.seprojects.in/api/ver1/loginLogoutData/${Constants.conString}/${dtProvider.userId}/$formattedDate";
      var response = await http.get(Uri.parse(url));
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['Status'] == "Success") {
          dtProvider.updateIsLoading(value: false, isNotify: true);
          final loginDetails = LoginDetails.fromJson(result['data']);
          dtProvider.updateLoginTypeValue(loginDetails.loginType);
          dtProvider.updateLoginDetails(loginDetails);
          dtProvider.getLoginLogoutplaces(
              loginDetails.loginCoordinates, loginDetails.logoutCoordinates);
        } else if (result['Status'] == "Error") {
          dtProvider.updateIsLoading(value: false, isNotify: true);
          // Utils.showSnackbar(
          //     context: context, content: result['Error'].toString());
        }
      }
    } catch (e) {
      dtProvider.updateIsLoading(value: false, isNotify: true);
      Utils.showSnackbar(
        context: context,
      );
    }
  }

  static getMonthInformation(BuildContext context, int month, int year) async {
    try {
      final dtProvider = Provider.of<DataProvider>(context, listen: false);
      await dtProvider.getUserIdFromSharedPred();
      // dtProvider.updateMonthDetails([]);
      var url =
          "http://timesheet.seprojects.in/api/ver1/whth_bymonthyear/${Constants.conString}/${dtProvider.userId}/$month/$year";

      var response = await http.get(Uri.parse(url));
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['Status'] == "Success") {
          var list = (result['data'] as List).map((e) {
            return LoginDetails.fromJson(e);
          }).toList();
          dtProvider.updateMonthDetails(list);
        } else if (result['Status'] == "Error") {
          // Utils.showSnackbar(
          //     context: context, content: result['Error'].toString());
        } else {
          Utils.showSnackbar(context: context);
        }
      }
    } catch (e) {
      Utils.showSnackbar(context: context, content: e.toString());
    }
  }
}

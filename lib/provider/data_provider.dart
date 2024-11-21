// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet/app/constants.dart';
import 'package:timesheet/main.dart';
import 'package:timesheet/screens/login.dart';
import 'package:timesheet/screens/resources/color_constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leave_history.dart';
import '../models/login_details.dart';

class DataProvider extends ChangeNotifier {
  int? _userId;
  int? get userId => _userId;

  String? _userName;
  String? _gender;
  String? get userName => _userName;
  String? get gender => _gender;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;

  String? _loginType;
  String? get loginType => _loginType;

  String? _leaveType;
  String? get leaveType => _leaveType;

  String? _halfOrFull;
  String? get halfOrFull => _halfOrFull;

  String? _halfLeaveType;
  String? get halfLeaveType => _halfLeaveType;

  LeaveHistoryModel? _historyModel;
  LeaveHistoryModel? get historyModel => _historyModel;

  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  DateTime fourtDayAfterToday() => DateTime.now().add(const Duration(days: 3));
  String? _logoutPlace = "";
  String? get logoutPlace => _logoutPlace;

  String? _loginPlace = "";
  String? get loginPlace => _loginPlace;

  updateLogoutPlace(String? newValue) {
    _logoutPlace = newValue;
    notifyListeners();
  }

  updateLoginPlace(String? newValue) {
    _loginPlace = newValue;
    notifyListeners();
  }

  DateTime getInitialDate() {
    switch (leaveType) {
      case "Without Pay":
        if (fromDate != null) {
          return fromDate!;
        }
        return DateTime.now();
      case "Sick Leave":
        if (fromDate != null) {
          return fromDate!;
        }
        return DateTime.now();
      case "Casual Leave":
        if (fromDate != null) {
          return fromDate!;
        }
        return DateTime.now();
      case "Paid Leave":
        if (fromDate != null) {
          return fromDate!;
        }
        return fourtDayAfterToday();
      default:
        return DateTime.now();
    }
  }

  DateTime getFirstDateOfLeave() {
    switch (leaveType) {
      case "Without Pay":
        return fromDate ?? DateTime.now();
      case "Sick Leave":
        return fromDate ?? DateTime.now();
      case "Casual Leave":
        return fromDate ?? DateTime.now();
      case "Paid Leave":
        return fromDate ?? fourtDayAfterToday();
      default:
        return DateTime.now();
    }
  }

  DateTime getLastDateOfLeave() {
    switch (leaveType) {
      case "Without Pay":
        return DateTime(2100);
      case "Sick Leave":
        if (fromDate != null) {
          return fromDate!
              .add(Duration(days: balenceLeaves!.ceilToDouble().toInt()));
        } else {
          return DateTime(2100);
        }
      case "Casual Leave":
        if (fromDate != null) {
          return fromDate!
              .add(Duration(days: balenceLeaves!.ceilToDouble().toInt()));
        } else {
          return DateTime(2100);
        }
      case "Paid Leave":
        if (fromDate != null) {
          return fromDate!
              .add(Duration(days: balenceLeaves!.ceilToDouble().toInt()));
        } else {
          return fourtDayAfterToday();
        }

      default:
        return DateTime.now();
    }
  }

  updateHalfOrFullLeave(String? newValue) {
    _halfOrFull = newValue;
    if (newValue == null) {
      _halfLeaveType = null;
    }
    notifyListeners();
  }

  updateHalfLeaveType(String? newValue) {
    _halfLeaveType = newValue;
    notifyListeners();
  }

  getDateString(DateTime? date) {
    if (date != null) {
      return DateFormat("dd-MM-yyyy").format(date);
    } else {
      return "";
    }
  }

  clearApplyLeaveDatails() {
    _balenceLeaves = 0;
    _leaveType = null;
    _toDate = null;
    _fromDate = null;
  }

  updateDate(
      {required DateTime? date, bool? fromDateStatus, bool? toDateStatus}) {
    if (fromDateStatus ?? false) {
      _fromDate = date;
    }
    if (toDateStatus ?? false) {
      _toDate = date;
      updateHalfOrFullLeave(null);
    }
    notifyListeners();
  }

  showNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails("test", "notification",
            priority: Priority.max,
            importance: Importance.high,
            playSound: true);
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var scheduleDate = DateTime.now().add(const Duration(seconds: 5));
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await notificationsPlugin.zonedSchedule(1, "this is notification", "Test",
        tz.TZDateTime.from(scheduleDate, tz.local), notificationDetails,
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime);
  }

  void showFakeLocationError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Fake Location Detected',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: ColorConstant.whiteA700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Your current location is not valid. Please disable any fake location apps and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstant.whiteA700),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: ColorConstant.blueIris,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> loginTypelist = ['Office', "Home", "Site"];
  List<String> leaveTypeList = [
    "Without Pay",
    "Sick Leave",
    "Casual Leave",
    "Paid Leave",
  ];

  double? _balenceLeaves = 0.0;
  double? get balenceLeaves => _balenceLeaves;

  List<LoginDetails> _monthDetails = [];
  List<LoginDetails> get monthDetails => _monthDetails;

  LoginDetails _loginDetails = testLoginDetails;
  LoginDetails get loginDetails => _loginDetails;

  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  updateBalenceLeaves() {
    String temp = getLeaveType(leaveType ?? "");
    int? totalLeaves = 0;
    double? totalRemainingLeaves = 0;
    switch (temp) {
      case "SL":
        totalLeaves = historyModel?.data?.leavesInitial[0].sl;
        totalRemainingLeaves = historyModel?.data?.leavesTaken
            .where((element) {
              return element.leaveType == "SL";
            })
            .toList()[0]
            .days;
        _balenceLeaves = totalLeaves!.toDouble() - totalRemainingLeaves!;
        break;
      case "PL":
        totalLeaves = historyModel?.data?.leavesInitial[0].pl;
        totalRemainingLeaves = historyModel?.data?.leavesTaken
            .where((element) {
              return element.leaveType == "PL";
            })
            .toList()[0]
            .days;
        _balenceLeaves = totalLeaves!.toDouble() - totalRemainingLeaves!;
        break;
      case "CL":
        totalLeaves = historyModel?.data?.leavesInitial[0].cl;
        totalRemainingLeaves = historyModel?.data?.leavesTaken
            .where((element) {
              return element.leaveType == "CL";
            })
            .toList()[0]
            .days;
        _balenceLeaves = totalLeaves!.toDouble() - totalRemainingLeaves!;
        break;
      default:
        _balenceLeaves = 0;
        break;
    }
    notifyListeners();
  }

  updateLeaveType(String value) {
    _leaveType = value;
    _fromDate = null;
    _toDate = null;
    updateBalenceLeaves();
  }

  String getLeaveType(String leave) {
    switch (leave) {
      case "Sick Leave":
        return "SL";
      case "Casual Leave":
        return "CL";
      case "Paid Leave":
        return "PL";
      case "Without Pay":
        return "WP";
      default:
        return "";
    }
  }

  updateLeaveHistoryModel(LeaveHistoryModel? newModel) {
    _historyModel = newModel;
    notifyListeners();
  }

  updateMonthDetails(List<LoginDetails> newMonthDetails) {
    _monthDetails = newMonthDetails;
    notifyListeners();
  }

  updateFocusedDay({required DateTime dateTime, bool? notify}) {
    _focusedDay = dateTime;
    if (notify == true) {
      notifyListeners();
    }
  }

  bool compareDates({required DateTime firstDate, DateTime? secDate}) {
    var date1 = DateFormat('yyyy-MM-dd').format(firstDate);
    var date2 = DateFormat('yyyy-MM-dd').format(secDate ?? DateTime.now());
    if (date1 == date2) {
      return true;
    } else {
      return false;
    }
  }

  bool checkDaysInfoAvailableOrNot(DateTime date) {
    var result = monthDetails
        .where((element) => element.date!.isAtSameMomentAs(date))
        .toList();
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  updateIsLoading({required bool value, bool? isNotify = false}) {
    _isLoading = value;
    if (isNotify!) {
      notifyListeners();
    }
  }

  updateIsLoginLoading({required bool value, bool? isNotify = false}) {
    _isLoginLoading = value;
    if (isNotify!) {
      notifyListeners();
    }
  }

  disposeLoginDetails() {
    _loginDetails = testLoginDetails;
  }

  bool checkInitialLeaves(String leaveTypeValue) {
    String tempLeaveType = getLeaveType(leaveTypeValue);
    int tempRemainingLeaves;
    final leavesInitial = historyModel?.data?.leavesInitial.first;
    switch (tempLeaveType) {
      case "PL":
        tempRemainingLeaves = leavesInitial?.pl ?? 0;
        break;
      case "CL":
        tempRemainingLeaves = leavesInitial?.cl ?? 0;
      case "SL":
        tempRemainingLeaves = leavesInitial?.sl ?? 0;
      case "WP":
        tempRemainingLeaves = 1;
      default:
        tempRemainingLeaves = 0;
    }
    return tempRemainingLeaves > 0;
  }

  updateLoginDetails(LoginDetails newLoginDetails) {
    _loginDetails = newLoginDetails;
    notifyListeners();
  }

  updateLoginTypeValue(String? newvalue) {
    _loginType = newvalue;
    // notifyListeners();
  }

  getUserNameFromSharedPref() async {
    var firstName = await getDataFromPrefString("firstName");
    var lastName = await getDataFromPrefString("lastName");
    _gender = await predictGender(firstName);

    _userName = "$firstName $lastName";
    notifyListeners();
  }

  Future<String> predictGender(String name) async {
    String? gender;
    final response =
        await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      gender = data['gender'] ?? 'Unknown';
    } else {
      throw Exception('Failed to fetch data from Genderize API');
    }
    return gender!;
  }

  getLoginLogoutplaces(
      String? loginCoordinates, String? logoutCoordinates) async {
    String loginPlace = '';
    String logoutPlace = '';
    if (loginCoordinates != null && loginCoordinates != "") {
      //login
      final loginPlacemarks = await placemarkFromCoordinates(
        double.tryParse(loginCoordinates.split(",")[0].toString()) ?? 0,
        double.tryParse(loginCoordinates.split(",")[1].toString()) ?? 0,
      );
      for (final placemark in loginPlacemarks) {
        loginPlace = "$loginPlace ${placemark.name}";
      }
      updateLoginPlace(loginPlace);
    }

    //logout
    if (logoutCoordinates != null && logoutCoordinates != "") {
      final logoutPlacemarks = await placemarkFromCoordinates(
        double.tryParse(logoutCoordinates.split(",")[0].toString()) ?? 0,
        double.tryParse(logoutCoordinates.split(",")[1].toString()) ?? 0,
      );
      for (final placemark in logoutPlacemarks) {
        logoutPlace = "$logoutPlace ${placemark.name}";
      }
      updateLogoutPlace(logoutPlace);
    }
  }

  getUserIdFromSharedPred() async {
    _userId = await getDataFromPref("userId");
  }

  //add date to SharedPreferences
  Future<bool> addDataToSharedPref(
      int userId, String firstName, String lastName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = false;
    result = await preferences.setInt("userId", userId);
    result = await preferences.setString("firstName", firstName);
    result = await preferences.setString("lastName", lastName);
    return result;
  }

  //get value using key in SharedPreferences
  Future<dynamic> getDataFromPref(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? result = preferences.getInt(key);
    return result;
  }

  Future<dynamic> getDataFromPrefString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? result = preferences.getString(key);
    return result;
  }

  //delete all store data in sharedpreferce
  Future<bool> deleteStoreData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.clear();
    return result;
  }

  //show dialog to open setting to allow location
  showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Do you really want to logout?"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel".toUpperCase())),
            ElevatedButton(
                onPressed: () async {
                  bool res = await deleteStoreData();
                  if (res) {
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginPage.routeName, (Route<dynamic> route) => false);
                    }
                  }
                },
                child: Text("Logout".toUpperCase()))
          ],
        );
      },
    );
  }
}

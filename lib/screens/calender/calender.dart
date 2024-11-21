// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/api/login_api.dart';
import 'package:timesheet/provider/data_provider.dart';
import 'package:timesheet/screens/resources/color_constants.dart';
import 'package:timesheet/screens/widgets/mydrawer.dart';
import 'package:timesheet/screens/widgets/profile_card_widget.dart';
import 'info_screen.dart';

class CalenderScreen extends StatefulWidget {
  static const routeName = "/calenderScreen";
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  void initState() {
    // Provider.of<NotificationProvider>(context,listen: false).scheduleNotifications();
    LoginApi.getMonthInformation(
        context, DateTime.now().month, DateTime.now().year);
    Provider.of<DataProvider>(context, listen: false)
        .getUserNameFromSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dtProvider = Provider.of<DataProvider>(context);
    // final ntProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
              )),
          IconButton(
              onPressed: () {
                dtProvider.showLogoutDialog(context);
              },
              icon: const Icon(
                Icons.logout,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileCardWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                rowHeight: 70,
                availableCalendarFormats: const {CalendarFormat.month: "Month"},
                onDaySelected: (selectedDay, focusedDay) {
                  if (dtProvider.checkDaysInfoAvailableOrNot(selectedDay)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationScreen(
                            dateTime: selectedDay,
                          ),
                        ));
                  }
                },
                onPageChanged: (focusedDay) {
                  dtProvider.updateFocusedDay(dateTime: focusedDay);
                  LoginApi.getMonthInformation(
                      context, focusedDay.month, focusedDay.year);
                },
                holidayPredicate: (day) {
                  // bool isSecondOrFourthSaturday(DateTime day) {
                  //   if (day.weekday == DateTime.saturday) {
                  //     final weekOfMonth = (day.day - 1) ~/ 7 + 1;
                  //     return weekOfMonth == 2 || weekOfMonth == 4;
                  //   }
                  //   return false;
                  // }
                  var index = dtProvider.monthDetails.indexWhere(
                      (element) => element.date!.isAtSameMomentAs(day));
                  if (day.weekday == DateTime.sunday) {
                    return true;
                  }

                  if (index != -1) {
                    if (dtProvider.monthDetails[index].isLeave == 1) {
                      return true;
                    }
                    if (dtProvider.monthDetails[index].holidayFlag == true) {
                      return true;
                    }
                  }

                  return false;
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (dtProvider.checkDaysInfoAvailableOrNot(day)) {
                      var today = dtProvider.monthDetails.where(
                        (element) {
                          return element.date!.isAtSameMomentAs(day);
                        },
                      ).toList()[0];
                      return CalenderCell(
                        day: day,
                        totalHour: today.th.toString(),
                        allottedHours: today.ah.toString(),
                        workingHour: today.wh.toString(),
                        isLateMarked: today.isLatemarked ?? false,
                      );
                    } else {
                      return CalenderCell(
                        day: day,
                      );
                    }
                  },

                  //it will add the marks on each date event wise
                  // markerBuilder: (context, day, events) {
                  //   return Text("1");
                  // },
                  headerTitleBuilder: (context, day) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("MMMM yyyy").format(day),
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "Domine",
                              fontWeight: FontWeight.w700),
                        ),
                        GestureDetector(
                          onTap: () => {
                            dtProvider.updateFocusedDay(
                                dateTime: DateTime.now(), notify: true)
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // color: ColorConstant.blueIris,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "Today",
                                // DateFormat('dd MMMM').format(DateTime.now()),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                        )
                      ],
                    );
                  },
                  holidayBuilder: (context, day, focusedDay) {
                    bool isSecondOrFourthSaturday(DateTime day) {
                      if (day.weekday == DateTime.saturday) {
                        final weekOfMonth = (day.day - 1) ~/ 7 + 1;
                        return weekOfMonth == 2 || weekOfMonth == 4;
                      }
                      return false;
                    }

                    var index = dtProvider.monthDetails.indexWhere(
                        (element) => element.date!.isAtSameMomentAs(day));
                    if (index != -1) {
                      if (dtProvider.monthDetails[index].holidayFlag == true &&
                          day.weekday != DateTime.sunday) {
                        return CalenderCell(
                          day: day,
                          color: Colors.amber,
                        );
                      }
                    }

                    if (day.weekday == DateTime.sunday) {
                      return CalenderCell(
                          day: day,
                          color: const Color.fromARGB(255, 236, 16, 0),
                          textColor: Colors.white);
                    }
                    if (day.weekday == DateTime.saturday &&
                        isSecondOrFourthSaturday(day)) {
                      return CalenderCell(
                        day: day,
                        color: ColorConstant.amber500,
                      );
                    }

                    if (day.weekday != DateTime.sunday) {
                      var today = dtProvider.monthDetails.where(
                        (element) {
                          return element.date!.isAtSameMomentAs(day);
                        },
                      ).toList()[0];
                      return CalenderCell(
                        day: day,
                        color: ColorConstant.purpleNew.withAlpha(80),
                        totalHour: today.th.toString(),
                        allottedHours: today.ah.toString(),
                        workingHour: today.wh.toString(),
                        isLateMarked: today.isLatemarked ?? false,
                      );
                    }

                    return CalenderCell(
                      day: day,
                      color: ColorConstant.bluegray100,
                    );
                  },
                  dowBuilder: (context, day) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        alignment: Alignment.center,
                        /*decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),*/
                        child: Text(
                          DateFormat('EEE').format(day),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ));
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return CalenderCell(
                      day: day,
                      color: ColorConstant.lightGrey,
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    if (dtProvider.checkDaysInfoAvailableOrNot(day)) {
                      var today = dtProvider.monthDetails.where(
                        (element) {
                          return element.date!.isAtSameMomentAs(day);
                        },
                      ).toList()[0];
                      return CalenderCell(
                        day: day,
                        color: ColorConstant.mintGreen,
                        totalHour: today.th.toString(),
                        allottedHours: today.ah.toString(),
                        workingHour: today.wh.toString(),
                      );
                    } else {
                      return CalenderCell(
                        day: day,
                        color: ColorConstant.mintGreen,
                      );
                    }
                  },
                ),
                daysOfWeekHeight: 40,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: dtProvider.focusedDay,
              ),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}

/*
class HoursDisplay extends StatelessWidget{
    final DateTime day;
    String? workingHour;
  String? totalHour;
  String? allottedHours;
    HoursDisplay({
      
    required this.day,
   
    this.workingHour,
    this.totalHour,
    this.allottedHours,

    super.key,
  });
 Row getRow({String? title, String? value, double? fontSize,BuildContext? context}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title :"),
          Container(
              margin: const EdgeInsets.all(5),
              alignment: Alignment.center,
              width: MediaQuery.of(context!).size.width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorConstant.purpleNew),
              child: Text(
                value ?? "".toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white, fontSize: fontSize),
              ))
        ],
      );
    }

  @override
    Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8),
          child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(5)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              getRow(
                                title: "Working Hours ",
                                value: '7.5' ?? "NA"),
                                 getRow(
                                title: "Total Hours ",
                                value: '7.5' ?? "NA"),
                                 getRow(
                                title: "Allotted Hours ",
                                value: '7.5' ?? "NA"),
                                
            ],),
          ),
          ),
          ) 
          ;
    }
}
*/
class CalenderCell extends StatelessWidget {
  final DateTime day;
  final Color? color;
  String? workingHour;
  String? totalHour;
  String? allottedHours;
  bool isLateMarked;
  bool isLeave;
  Color? textColor;
  CalenderCell({
    required this.day,
    this.color = Colors.white,
    this.workingHour,
    this.totalHour,
    this.allottedHours,
    this.isLeave = false,
    this.isLateMarked = false,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (allottedHours != null) {
      if (allottedHours.toString().contains("null")) {
        allottedHours = null;
      }
    }
    if (workingHour != null) {
      if (workingHour.toString().contains("null")) {
        workingHour = null;
      }
    }
    if (totalHour != null) {
      if (totalHour.toString().contains("null")) {
        totalHour = null;
      }
    }
    //final nullCheck=(allottedHours == null && workingHour == null && totalHour == null && !isLeave);
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: textColor ?? Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLateMarked)
            const Text(
              "one late mark",
              style: TextStyle(
                  fontSize: 7, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          Text(DateFormat('EEE').format(day).toUpperCase(),
              style: TextStyle(fontSize: 10, color: textColor ?? Colors.black)),
          Text(
            day.day.toString(),
            style: TextStyle(
                fontFamily: "Domine",
                fontWeight: FontWeight.w700,
                color: textColor ?? Colors.black),
            // style: GoogleFonts.abel(),
          ),
          /*
          Text(
            "WH : ${workingHour ?? 'NA'}",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: textColor ?? Colors.black),
          ),
          Text(
            "TH : ${totalHour ?? 'NA'}",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: textColor ?? Colors.black),
          ),
          Text(
            "AH : ${allottedHours ?? 'NA'}",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: textColor ?? Colors.black),
          )
        */
        ],
      ),
    );
  }
}

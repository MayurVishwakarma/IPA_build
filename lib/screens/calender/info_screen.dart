import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/api/login_api.dart';
import 'package:timesheet/app/utils.dart';
import 'package:timesheet/screens/resources/color_constants.dart';
import 'package:timesheet/screens/widgets/custom_widgets.dart';

import '../../provider/data_provider.dart';
import '../widgets/loading.dart';

class InformationScreen extends StatefulWidget {
  final DateTime dateTime;
  static const routeName = "/informationScreen";
  const InformationScreen({super.key, required this.dateTime});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  getLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      getLocationPermission();
    } else if (permissionStatus.isPermanentlyDenied) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Alert"),
              content: const Text(
                  "To Login and Logout from the system you have to give location permission"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                ElevatedButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    child: const Text("Ok"))
              ],
            );
          },
        );
      }
    } else if (permissionStatus.isGranted) {}
  }

  @override
  void initState() {
    final dtProvider = Provider.of<DataProvider>(context, listen: false);
    if (dtProvider.compareDates(firstDate: widget.dateTime)) {
      getLocationPermission();
    }
    dtProvider.getUserIdFromSharedPred();
    LoginApi.getLoginInformation(context, widget.dateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dtProvider = Provider.of<DataProvider>(context);
    var loginDetails = dtProvider.loginDetails;
    var today = dtProvider.monthDetails.where(
                        (element) {
                          return element.date!.isAtSameMomentAs(widget.dateTime);
                        },
                      ).toList()[0];

    Row getRow({String? title, String? value, double? fontSize}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title :"),
          Container(
              margin: const EdgeInsets.all(5),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.6,
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(DateFormat('EEEE').format(widget.dateTime)),
            const Text(","),
            const SizedBox(
              width: 5,
            ),
            Text(DateFormat.yMMMd().format(widget.dateTime))
          ],
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const LoadingWidget();
          } else {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: const Color.fromARGB(255, 236, 236, 236),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  child: Table(
                    children: [
                      TableRow(children: [
                        const Text(
                          "Employee Id",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: "Lato"),
                        ),
                        Text(dtProvider.userId.toString())
                      ]),
                      TableRow(children: [
                        const Text(
                          "Employee Name",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: "Lato"),
                        ),
                        Text(dtProvider.userName.toString())
                      ]),
                      // TableRow(children: [
                      //   const Text(
                      //     "Date",
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.normal,
                      //         fontFamily: "Lato"),
                      //   ),
                      //   Text(DateFormat("yyyy-MM-dd").format(widget.dateTime))
                      // ])
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonFormField(
                          hint: const Text("SELECT LOGIN TYPE"),
                          isExpanded: true,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: ColorConstant.lightGrey,
                          ),
                          value: (dtProvider.loginTypelist
                                  .contains(dtProvider.loginType))
                              ? dtProvider.loginType
                              : null,
                          items: dtProvider.loginTypelist.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Center(child: Text('Work From $e')),
                            );
                          }).toList(),
                          onChanged: (loginDetails.logInTime == null)
                              ? (value) {
                                  dtProvider
                                      .updateLoginTypeValue(value as String);
                                }
                              : null,
                        ),
                      ),
                      if (value.isLoginLoading)
                        const SizedBox(
                          height: 10,
                        ),
                      if (value.isLoginLoading)
                        const CircularProgressIndicator.adaptive(),
                      if ((loginDetails.logOutTime == null))
                        const SizedBox(
                          height: 10,
                        ),
                      if (dtProvider.compareDates(firstDate: widget.dateTime))
                        Row(
                          children: [
                            if (loginDetails.logInTime == null)
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorConstant.indigo,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: () {
                                        if (widget.dateTime
                                            .isBefore(DateTime.now())) {
                                          if (dtProvider
                                                  .loginDetails.logInTime ==
                                              null) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Alert"),
                                                  content: const Text(
                                                      "Are you sure you want to log In "),
                                                  actions: [
                                                    CustomButton(
                                                      title: "LOGIN",
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        LoginApi.loginInSystem(
                                                            context);
                                                      },
                                                    ),
                                                    CustomButton(
                                                      title: "NO",
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            Utils.showSnackbar(
                                                context: context,
                                                content:
                                                    "You are already logged In");
                                          }
                                        } else {
                                          Utils.showSnackbar(
                                              context: context,
                                              content:
                                                  "You are not allowed to modify this data");
                                        }
                                      },
                                      child: Text(
                                        "LogIn".toUpperCase(),
                                        style: TextStyle(
                                            color: ColorConstant.whiteA700,
                                            fontFamily: "Lato",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ))),
                            if (loginDetails.logInTime == null)
                              const SizedBox(
                                width: 5,
                              ),
                            if (loginDetails.logOutTime == null)
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          disabledBackgroundColor:
                                              ColorConstant.indigo.withAlpha(1),
                                          backgroundColor: ColorConstant.indigo,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: () {
                                        if (widget.dateTime
                                            .isBefore(DateTime.now())) {
                                          if (dtProvider
                                                  .loginDetails.logOutTime ==
                                              null) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Alert"),
                                                  content: const Text(
                                                      "Are you sure you want to logout "),
                                                  actions: [
                                                    CustomButton(
                                                      title: "LOG OUT",
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        LoginApi
                                                            .logoutFromSystem(
                                                                context);
                                                      },
                                                    ),
                                                    CustomButton(
                                                      title: "NO",
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            Utils.showSnackbar(
                                                context: context,
                                                content:
                                                    "You are already logged Out");
                                          }
                                        } else {
                                          Utils.showSnackbar(
                                              context: context,
                                              content:
                                                  "You are not allowed to modify this data");
                                        }
                                      },
                                      child: Text(
                                        "Log Out".toUpperCase(),
                                        style: TextStyle(
                                            color: ColorConstant.whiteA700,
                                            fontFamily: "Lato",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))
                          ],
                        ),
                    ],
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       final placemarks = await placemarkFromCoordinates(
                //         //19.218643,72.8640483
                //         double.tryParse(loginDetails.loginCoordinates!.split(",")[0].toString())??0,
                //         double.tryParse(loginDetails.loginCoordinates!.split(",")[1].toString())??0,
                //       );
                //       for (final placemark in placemarks) {
                //         print(placemark.name??"");
                //       }
                //     },
                //     child: child),
                Consumer<DataProvider>(
                  builder: (context, value, child) {
                    loginDetails = value.loginDetails;
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          getRow(
                              title: "Login Type",
                              value: loginDetails.loginType ?? "NA"),
                          getRow(
                              title: "Login Time ",
                              value: (loginDetails.logInTime != null)
                                  ? DateFormat("HH:mm:ss")
                                      .format(loginDetails.logInTime!)
                                  : "NA"),
                          if (loginDetails.loginCoordinates != null &&
                              loginDetails.loginCoordinates != "")
                            getRow(
                                title: "Login Place",
                                value: value.loginPlace.toString(),
                                fontSize: 14),
                          getRow(
                              title: "Logout Time",
                              value: (loginDetails.logOutTime != null &&
                                      loginDetails.logInTime != null)
                                  ? DateFormat("HH:mm:ss")
                                      .format(loginDetails.logOutTime!)
                                  : "NA"),
                          if (loginDetails.logoutCoordinates != null &&
                              loginDetails.logoutCoordinates != "")
                            getRow(
                                title: "Logout Place",
                                value: value.logoutPlace,
                                fontSize: 14),
                          if (loginDetails.logOutTime != null)
                            getRow(
                              title: "Working Hours",
                              value: (loginDetails.half != "NA")
                                  ? dtProvider.format(
                                      loginDetails.logOutTime!
                                          .subtract(const Duration(minutes: 30))
                                          .difference(loginDetails.logInTime!),
                                    )
                                  : dtProvider.format(
                                      loginDetails.logOutTime!
                                          .difference(loginDetails.logInTime!),
                                    ),
                            )
                              ,/*getRow(
                                title: "Working Hours ",
                                value: (today.wh??'NA').toString()),
                                 */getRow(
                                title: "Total Hours ",
                                value: (today.th??'NA').toString()),
                                 getRow(
                                title: "Allotted Hours ",
                                value: (today.ah??'NA').toString() ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

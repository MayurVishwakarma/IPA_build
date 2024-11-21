import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/screens/calender/calender.dart';
import 'package:timesheet/screens/login.dart';

import '../../provider/data_provider.dart';
import '../resources/color_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer(
      const Duration(seconds: 1),
      () {
        Provider.of<DataProvider>(context, listen: false)
            .getDataFromPref('userId')
            .then((value) {
          if (value != null) {
            Navigator.pushReplacementNamed(context, CalenderScreen.routeName);
          } else {
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          }
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Colors.cyan, Colors.deepPurple])),
        child: Stack(
          children: [
            /*Image.asset(
              fit: BoxFit.fitHeight,
              "assets/images/background.jpg",
              height: MediaQuery.of(context).size.height,),
            */
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// Company Logo
                      Image.asset(
                        'assets/images/saisanket12.png',
                        fit: BoxFit.fill,
                        width: 100,
                      ),
                      Text(
                        "ERP TOOL",
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstant.mintGreen,
                          fontSize: 30,
                          fontFamily: "Lato",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Timesheet".toUpperCase(),
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 4,
                          color: ColorConstant.black900,
                          fontSize: 22,
                          // fontFamily: "Domine",
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Version 1.5",
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: 12,
                          fontWeight: FontWeight.w400, 
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

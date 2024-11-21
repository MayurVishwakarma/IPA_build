/*
import 'package:flutter/material.dart';
import 'package:timesheet/screens/leave/history.dart';
import 'package:timesheet/screens/resources/color_constants.dart';
import 'package:timesheet/screens/widgets/custom_widgets.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ColorConstant.mintGreen),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top + 10,
                ),
                CircleAvatar(
                    radius: 50,
                    backgroundColor: ColorConstant.whiteA700,
                    child:
                        Image.asset(height: 80, 'assets/images/saisanket.png')),
                const Text(
                  "ERP TOOL",
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "TIMESHEET",
                  style: TextStyle(
                      fontFamily: "Domine",
                      letterSpacing: 5,
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          CustomButton(
            title: "LEAVE REQUEST",
            onPressed: () {
              Navigator.pushNamed(context, LeaveHistory.routeName);
            },
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/screens/leave/history.dart';
import 'package:timesheet/provider/data_provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final dtProvider = Provider.of<DataProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Colors.cyan, Colors.deepPurple])),
              child: Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.asset(
                        dtProvider.gender == 'female'
                            ? "assets/images/woman.png"
                            : "assets/images/man.png",
                        height: 70,
                        width: 70,
                      ),
                    ),
                    Text(
                      dtProvider.userName!.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )),
          const Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
                child: Text(
                  'Timesheet Mobile Application',
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 10.0),
                child: Text('App Version-v1.5',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    )),
              ),
            ],
          ),
          ListTile(
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(10)),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'Apply Leave',
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            onTap: (() {
              Navigator.pushNamed(context, LeaveHistory.routeName);
            }),
          ),
        ],
      ),
    );
  }
}

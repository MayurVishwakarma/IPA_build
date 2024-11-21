import 'package:flutter/material.dart';
import 'package:timesheet/screens/calender/calender.dart';
import 'package:timesheet/screens/login.dart';

import '../calender/splash_screen.dart';
import '../leave/apply_leave.dart';
import '../leave/history.dart';
import '../todo_list/todo_list.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // final args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case CalenderScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const CalenderScreen(),
        );
      case LeaveHistory.routeName:
        return MaterialPageRoute(
          builder: (context) => const LeaveHistory(),
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (context) =>  LoginPage(),
        );
      case ApplyLeavePage.routeName:
        return MaterialPageRoute(
          builder: (context) =>  const ApplyLeavePage(),
        );
      case Todolist.routeName:
        return MaterialPageRoute(
          builder: (context) =>  Todolist(),
        );
      // case InformationScreen.routeName:
      //   return MaterialPageRoute(builder: (context) => const InformationScreen(dateTime: null,),);
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('page not found!'),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/app/permission_handler.dart';
import 'package:timesheet/provider/data_provider.dart';
// import 'package:timesheet/screens/resources/color_constants.dart';
import 'package:timezone/data/latest_10y.dart';
import 'screens/router/router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workmanager/workmanager.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simplePeriodicTask:
        await PermissionHandler.scheduleNotifications();
        print("test simple periodic task");
        break;
      case "taskOne":
        print("test taskOne");
        break;
      case "taskTwo":
        print("test taskTwo");
        break;
      default:
        print("test task");
        break;
    }
    // print("Native called background task: $backgroundTask"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

const simplePeriodicTask = "simpleTask";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  //request for notification and location
  PermissionHandler.requestPermissionsOnStartup();
  //workmanager call
  //it dosen't allow to execute task under 15 minutes
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    // isInDebugMode:
    //     true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  Workmanager().registerPeriodicTask("login_logout", simplePeriodicTask,
      frequency: const Duration(hours: 6),
      initialDelay: const Duration(seconds: 0),
      existingWorkPolicy: ExistingWorkPolicy.replace);

  //initialize the android setting for notification
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );
  //initialize the ios setting for notification
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  //initialize the notification plugin
  bool? initialized =
      await notificationsPlugin.initialize(initializationSettings);
  print(initialized);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Time sheet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primaryColor: ColorConstant.indigo,
          textTheme: const TextTheme(
              labelSmall: TextStyle(fontSize: 8),
              bodyMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                // fontFamily: "Lato"
              )),
          expansionTileTheme: const ExpansionTileThemeData(
              collapsedShape: RoundedRectangleBorder()),

          appBarTheme: const AppBarTheme(
            // backgroundColor: ColorConstant.blueIris,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: "GoogleFont"),
          ),

          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade700,
          ),
          useMaterial3: true,
        ).copyWith(
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
        onGenerateRoute: RouteGenerator.onGenerateRoute,
      ),
    );
  }
}

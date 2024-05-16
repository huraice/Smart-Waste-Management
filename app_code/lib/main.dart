import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splash_screen/screens/city_lis.dart';
// import 'package:splash_screen/screens/home_screen.dart';
import 'package:splash_screen/screens/poluu_screen.dart';
import 'package:splash_screen/screens/splash_screen.dart';
import 'package:workmanager/workmanager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          enableVibration: true,
          ledColor: Color.fromARGB(255, 255, 9, 9),
          channelName: 'Basic Notification Channel',
          channelDescription: 'Notification channel description',
        )
      ],
      debug: true);

  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

final databaseReference = FirebaseDatabase.instance.reference();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Fetch data from Firebase and check sensor values
      // DatabaseReference sensorsRef =
      FirebaseDatabase.instance.ref().child('sensor_data');
      // DatabaseEvent event = await sensorsRef.once();
      // DataSnapshot snapshot = event.snapshot;
      DatabaseReference sensorDataRef = databaseReference.child('sensor_data');

      var flame1c = '';
      var flame2c = '';
      var flame3c = '';

      sensorDataRef.once().then((DatabaseEvent event) {
        var data =
            event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
        if (data != null) {
          flame1c = data['Flame_1']?.toString() ?? '';
          double flame1 = double.parse(flame1c);
          flame2c = data['Flame_2']?.toString() ?? '';
          double flame2 = double.parse(flame2c);
          flame3c = data['Flame_3']?.toString() ?? '';
          double flame3 = double.parse(flame3c);
          print("Flame");
          print(flame3);

          // perWaste = (num1 * 100) / 100;
          if (flame1 > 10 || flame2 > 10 || flame3 > 10) {
            // Trigger local notification
            _showNotification();
          }
        }
      });

      // if (snapshot.value != null) {
      //   Map<dynamic, dynamic> sensorValues =
      //       snapshot.value as Map<dynamic, dynamic>;
      //   int flame1 = (sensorValues['Flame_1'] as int?) ?? 0;
      //   int flame2 = (sensorValues['Flame_2'] as int?) ?? 0;
      //   int flame3 = (sensorValues['Flame_3'] as int?) ?? 0;

      //   if (flame1 > 10 || flame2 > 10 || flame3 > 10) {
      //     // Trigger local notification
      //     await _showNotification();
      //   }
      // }

      return Future.value(true);
    } catch (e) {
      print("Error in callbackDispatcher: $e");
      return Future.value(false);
    }
  });
}

Future<void> _showNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // Initialize the plugin. This is required.
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your_channel_id', 'your_channel_name',
          importance: Importance.max, priority: Priority.high, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      0,
      'Fire ',
      'One of the flame sensors exceeded the threshold value.',
      platformChannelSpecifics,
      payload: 'item x');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tutorial1 App",
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: SplashScreen(),
      routes: {
        '/cityDetails': (context) => CityDetailsScreen(),
        '/cityDetails1': (context) => polluScreen(),
      },
    );
  }
}

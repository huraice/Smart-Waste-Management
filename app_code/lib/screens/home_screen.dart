// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:splash_screen/main.dart';
import 'package:splash_screen/reusable_widget/reusable_widget.dart';
import 'package:splash_screen/screens/airquality.dart';
import 'package:splash_screen/screens/bin_guide.dart';
import 'package:splash_screen/screens/health_gram.dart';
// import 'package:splash_screen/screens/city_lis.dart';
import 'package:splash_screen/screens/map_screen.dart';
// import 'package:splash_screen/screens/poluu_screen.dart';
// import 'package:splash_screen/screens/trash_values.dart';
// import 'package:splash_screen/screens/trash_map.dart';
import 'package:splash_screen/utils/color_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:splash_screen/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _startMonitoring() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) async {
      await _checkSensorValues();
    });
  }

  Future<void> _checkSensorValues() async {
    DatabaseReference sensorsRef =
        FirebaseDatabase.instance.ref().child('sensor_data');
    DatabaseEvent event = await sensorsRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> sensorValues =
          snapshot.value as Map<dynamic, dynamic>;
      var wastelevel = '';
      double perWaste = 0.0;
      double waste = 0.0;

      var plastic = '';
      double perPla = 0.0;
      double pla = 0.0;
      var paper = '';
      double perPape = 0.0;
      double pape = 0.0;
      var biod = '';
      double perBio = 0.0;
      double bioW = 0.0;
      double avgWaste = 0;
      int flame1 = (sensorValues['Flame_1'] as int?) ?? 0;
      int flame2 = (sensorValues['Flame_2'] as int?) ?? 0;
      int flame3 = (sensorValues['Flame_3'] as int?) ?? 0;
      wastelevel = sensorValues['BioDegradablePer']?.toString() ?? '';
      var num1 = double.parse(wastelevel);

      perWaste = (num1 * 100) / 100;
      waste = perWaste / 100;

      plastic = sensorValues['PlasticPer']?.toString() ?? '';
      num1 = double.parse(plastic);
      perPla = (num1 * 100) / 100;
      pla = perPla / 100;
      paper = sensorValues['PaperWastePer']?.toString() ?? '';
      num1 = double.parse(paper);
      perPape = (num1 * 100) / 100;
      pape = perPape / 100;

      biod = sensorValues['BioDegradablePer']?.toString() ?? '';
      num1 = double.parse(biod);
      perBio = (num1 * 100) / 100;
      bioW = perBio / 100;
      avgWaste = (perBio + perPape + perPla) / 3;
      if (avgWaste >= 60) {
        await _showNotificationW();
      } else if (avgWaste >= 80) {
        // status_a = 'Collect';
        await _showNotificationW();
      } else if (avgWaste >= 90) {
        await _showNotificationW();
      }

      if (flame1 == 0 || flame2 == 0 || flame3 == 0) {
        await _showNotification();
      }
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      // Reference to the custom sound
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Fire Detected',
      'One of the flame sensors detected fire',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _showNotificationW() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      // Reference to the custom sound
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Waste Bin Alert',
      'Waste Level Filling more than 60%',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _requestCall() async {
    const phoneNumber = 'tel:+918848833016'; // Replace with your phone number
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeNotification();
    _startMonitoring();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print("Permission Denied");
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // TODO: implement initState
    super.initState();

    super.initState();
    // Register the periodic task

    super.initState();
    // Register the periodic task
    Workmanager().registerPeriodicTask(
      "1",
      "simplePeriodicTask",
      frequency: Duration(seconds: 15), // Check every 15 minutes
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: size.height * .45,
          decoration: BoxDecoration(
            color: hexStringToColor('7BCCB5'),
            image: const DecorationImage(
              alignment: Alignment.centerLeft,
              image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 89, 184, 138),
                        shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      'assets/icons/menu.svg',
                      height: 15,
                      width: 5,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hai, Have a great day :) ",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Check Nerarest Bin",
                      icon: SvgPicture.asset("assets/icons/search.svg"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13)),
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset('assets/icons/Maxburger.svg')
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: .85,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: <Widget>[
                      menuOptions('assets/images/8244421.png', "Trash Map", () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WasteManagementMap(),
                          ),
                        );
                      }),
                      menuOptions('assets/images/1705243.png', "Bin Guide", () {
                        callbackDispatcher();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const binGuide()));
                      }),
                      menuOptions('assets/images/5024476.png', "Pollu Screen",
                          () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AirQualityPage(),
                          ),
                        );
                      }),
                      menuOptions(
                          'assets/images/vecteezy_gps-tracking-icon-logo-vector-illustration-tracking-symbol_9653632-removebg-preview.png',
                          "Truck Locator", () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MapsPage(),
                          ),
                        );
                      }),
                      menuOptions(
                          'assets/images/callrequest.png', "Call Request ", () {
                        _requestCall();
                      }),
                      menuOptions(
                          'assets/images/information-about-us-icon-16.png',
                          "About Us",
                          () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    )
        //     Center(
        //   child: ElevatedButton(
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut().then((value) {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => const SignInScreen()));
        //         });
        //       },
        //       child: const Text("Log Out")),
        // )
        );
  }
}

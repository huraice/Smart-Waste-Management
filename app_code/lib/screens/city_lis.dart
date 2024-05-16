// import 'dart:ffi';

// import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:splash_screen/notifi_service.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

final databaseReference = FirebaseDatabase.instance.reference();
triggerNotification() {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple Notification'));
}

wasteStatus(String type2) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 2,
    channelKey: 'basic_channel',
    title: 'Warning Message',
    body: '$type2  ',
    wakeUpScreen: true,
  ));
}

class CityListScreen extends StatelessWidget {
  final List<String> cities = ['Panavoor', 'Nedumangad'];

  @override
  Widget build(BuildContext context) {
    // void _launchMap() async {
    //   const latitude = 37.7749;
    //   const longitude = -122.4194;
    //   const url =
    //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    //   if (await canLaunchUrl(url)) {
    //     await launchUrl(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('City List'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/cityDetails',
                arguments: cities[index],
              );
            },
          );
        },
      ),
    );
  }
}

class CityDetailsScreen extends StatefulWidget {
  @override
  State<CityDetailsScreen> createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  DatabaseReference sensorDataRef = databaseReference.child('sensor_data');

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
  var roundedValue;
  var status_a = 'Good';
  int mq135_1 = 0;
  int mq135_2 = 0;
  int mq135_3 = 0;
  //
  final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

  Future<void>? _launched;

  void updateSensorData() {
    sensorDataRef.once().then((DatabaseEvent event) {
      var data =
          event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
      if (data != null) {
        setState(() {
          mq135_1 = data['MQ135_1'] ?? 0;
          mq135_2 = data['MQ135_2'] ?? 0;
          mq135_3 = data['MQ135_3'] ?? 0;
          wastelevel = data['BioDegradablePer']?.toString() ?? '';
          var num1 = double.parse(wastelevel);

          perWaste = (num1 * 100) / 100;
          waste = perWaste / 100;

          plastic = data['PlasticPer']?.toString() ?? '';
          num1 = double.parse(plastic);
          perPla = (num1 * 100) / 100;
          pla = perPla / 100;
          paper = data['PaperWastePer']?.toString() ?? '';
          num1 = double.parse(paper);
          perPape = (num1 * 100) / 100;
          pape = perPape / 100;

          biod = data['BioDegradablePer']?.toString() ?? '';
          num1 = double.parse(biod);
          perBio = (num1 * 100) / 100;
          bioW = perBio / 100;
          avgWaste = (perBio + perPape + perPla) / 3;
          roundedValue = avgWaste.toStringAsFixed(2);
          if (avgWaste <= 25) {
            status_a = 'Normal';
          } else if (avgWaste <= 60) {
            status_a = 'Collect';
            wasteStatus(status_a);
          } else if (avgWaste <= 80) {
            status_a = 'Critical to collect';

            wasteStatus(status_a);
          } else if (avgWaste >= 95) {
            status_a = 'Completely filled,\n Immediatly Collect';
            wasteStatus(status_a);
          }
        });
      }
    });
  }

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        print("Permission Denied");
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // TODO: implement initState

    super.initState();
    // Check for phone call support.
    launcher.canLaunch('tel:123').then((bool result) {
      setState(() {});
    });
    super.initState();
    updateSensorData();
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (!await launcher.launch(
      url,
      useSafariVC: true,
      useWebView: true,
      enableJavaScript: true,
      enableDomStorage: false,
      universalLinksOnly: false,
      headers: <String, String>{},
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch =
        'https://www.google.com/maps/@8.6500447,76.9859326,18.82z?entry=ttu';
    final String cityName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Bin Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Waste Level $cityName',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularPercentIndicator(
                      radius: 50,
                      lineWidth: 10,
                      percent: pape,
                      progressColor: Color.fromARGB(255, 52, 6, 255),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("$perPape%",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Text(
                    "Paper",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text("Air Quality : $mq135_1-")
                ]),
                Column(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularPercentIndicator(
                      radius: 50,
                      lineWidth: 10,
                      percent: bioW,
                      progressColor: Color.fromARGB(255, 5, 165, 0),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("$perBio%",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Text(
                    "Bio Degradable",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text("Air Quality : $mq135_2 ")
                ]),
                Column(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularPercentIndicator(
                      radius: 50,
                      lineWidth: 10,
                      percent: pla,
                      progressColor: Color.fromARGB(255, 250, 0, 54),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("$perPla%",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Text(
                    "Plastic",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text("Air Quality : $mq135_3")
                ]),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Text(
                  "Current Waste Status: $status_a",
                  style: TextStyle(fontSize: 20),
                ),
                Text('Average Level: $roundedValue',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () {
                updateSensorData();
              },
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                _launched = _launchInWebViewWithJavaScript(toLaunch);
              }),
              child: const Text('Open in Maps'),
            ),
          ],
        ),
      ),
    );
  }
}

//

// class SensorDataPage extends StatefulWidget {
//   @override
//   _SensorDataPageState createState() => _SensorDataPageState();
// }

// class _SensorDataPageState extends State<SensorDataPage> {
//   DatabaseReference sensorDataRef = databaseReference.child('sensorData');

//   var wastelevel = '';

//   void updateSensorData() {
//     sensorDataRef.once().then((DatabaseEvent event) {
//       var data =
//           event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
//       if (data != null) {
//         setState(() {

//           wastelevel = data['WasteLevel']?.toString() ?? '';
//         });
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     updateSensorData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sensor Data'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Atmosphere Temperature :$temperature',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//             Text('Air Quality : $airQuality',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

//             Text('Pressure  : $presuree',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

//             Text('Waste Level: $wastelevel',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

//             // Text('Air Quality: $airQuality',
//             //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//             // Text(
//             //   'Atmospheric Pressure: $presuree',
//             //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),

//             SizedBox(height: 20),
           
//           ],
//         ),
//       ),
//     );
//   }
// }

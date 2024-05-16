// import 'dart:ffi';

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:url_launcher/url_launcher.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class CityListScreenpollu extends StatelessWidget {
  final List<String> cities = ['Panavoor'];

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
                '/cityDetails1',
                arguments: cities[index],
              );
            },
          );
        },
      ),
    );
  }
}

class polluScreen extends StatefulWidget {
  const polluScreen({super.key});

  @override
  State<polluScreen> createState() => _polluScreenState();
}

class _polluScreenState extends State<polluScreen> {
  DatabaseReference sensorDataRef = databaseReference.child('sensorData');
  double r0 = 76.63; // Resistance of the sensor at 100 ppm of CO2
  double aiRFACTOR = 4.4;

  var presuree = '';
  var temperature = '';
  var airQuality = '';
  double sensorValue = 0;
  double correctedPPMCO2 = 0.0;
  double voltage = 0.0;
  double rs = 0.0;
  double ratio = 0.0;
  double ppmCO2 = 0.0;
  double ammoniaPPM = 0.0;
  double smokeValue = 0.0;

//

  void updateSensorData() {
    sensorDataRef.once().then((DatabaseEvent event) {
      var data =
          event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
      if (data != null) {
        setState(() {
          presuree = data['Pressure']?.toString() ?? '';
          temperature = data['temperature']?.toString() ?? '';
          airQuality = data['mq135']?.toString() ?? '';
          sensorValue = double.parse(airQuality);
          voltage = sensorValue * (5.0 / 1023.0);
          rs = ((5.0 - voltage) / voltage) * 10.0;
          ratio = rs / r0;
          ppmCO2 = 116.6020682 * pow(ratio, -2.769034857);
          correctedPPMCO2 = ppmCO2 * aiRFACTOR;
          ammoniaPPM = sensorValue * 0.024;
          smokeValue = sensorValue;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Moinitor'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Atmosphere Temperature :$temperature',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Atmosphere Pressure  : $presuree',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('CO2 (ppm):  $correctedPPMCO2',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                'Ammonia (ppm): $ammoniaPPM',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'Smoke: $smokeValue',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              // Text('Air Quality: $airQuality',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              // Text(
              //   'Atmospheric Pressure: $presuree',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),

              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Update'),
                onPressed: () {
                  updateSensorData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class CityDetailsScreen extends StatefulWidget {
//   @override
//   State<CityDetailsScreen> createState() => _CityDetailsScreenState();
// }

// class _CityDetailsScreenState extends State<CityDetailsScreen> {
//   DatabaseReference sensorDataRef = databaseReference.child('sensorData');

//   var wastelevel = '';

//   void updateSensorData() {
//     sensorDataRef.once().then((DatabaseEvent event) {
//       var data =
//           event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
//       if (data != null) {
//         setState(() {
//           wastelevel = data['WasteLevel']?.toString() ?? '';
//           var num1 = int.parse(wastelevel);

//           double perWaste = (num1 * 100) / 100;
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
//     final String cityName =
//         ModalRoute.of(context)!.settings.arguments as String;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Waste Bin Level'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'Details of $cityName',
//               style: TextStyle(fontSize: 30),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             CircularPercentIndicator(
//               radius: 190,
//               lineWidth: 30,
//               percent: 0.4,
//               progressColor: Color.fromARGB(255, 87, 235, 143),
//               circularStrokeCap: CircularStrokeCap.round,
//               center: Text("$wastelevel%",
//                   style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600)),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Current Waste Status",
//               style: TextStyle(fontSize: 20),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 const url = 'https://blog.logrocket.com';
//                 if (await canLaunch(url)) {
//                   await launch(url);
//                 } else {
//                   throw 'Could not launch $url';
//                 }
//               },
//               child: Text("Open Google Map  location"),
//             ),
//             Text('Waste Level: $wastelevel',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//             ElevatedButton(
//               child: Text('Update'),
//               onPressed: () {
//                 updateSensorData();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

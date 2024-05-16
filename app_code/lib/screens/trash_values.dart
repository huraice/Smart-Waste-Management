import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  DatabaseReference sensorDataRef = databaseReference.child('sensorData');
  var presuree = '';
  var temperature = '';
  var airQuality = '';

  var wastelevel = '';
  // var temperature = '';
  // var heartrate = '';

  void updateSensorData() {
    sensorDataRef.once().then((DatabaseEvent event) {
      var data =
          event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
      if (data != null) {
        setState(() {
          presuree = data['Pressure']?.toString() ?? '';
          temperature = data['temperature']?.toString() ?? '';
          airQuality = data['mq135/co2Concentration']?.toString() ?? '';

          wastelevel = data['WasteLevel']?.toString() ?? '';
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
        title: Text('Sensor Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Atmosphere Temperature :$temperature',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text('Air Quality : $airQuality',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

            Text('Pressure  : $presuree',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

            Text('Waste Level: $wastelevel',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

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
    );
  }
}

class trash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash Analyser'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SensorDataPage()),
            );
          },
        ),
      ),
    );
  }
}

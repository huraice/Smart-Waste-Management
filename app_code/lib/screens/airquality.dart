import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AirQualityPage extends StatefulWidget {
  @override
  _AirQualityPageState createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  late Stream<DocumentSnapshot> _sensorDataStream;

  @override
  void initState() {
    super.initState();
    _sensorDataStream = FirebaseFirestore.instance
        .collection('sensor_data')
        .doc('sensorData')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality & Fire Detection'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _sensorDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data available'));
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            int mq135_1 = data['MQ135_1'] ?? 0;
            int mq135_2 = data['MQ135_2'] ?? 0;
            int mq135_3 = data['MQ135_3'] ?? 0;
            bool fireDetected = data['fireDetected'] ?? false;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Air Quality Index:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Sensor 1: $mq135_1'),
                  Text('Sensor 2: $mq135_2'),
                  Text('Sensor 3: $mq135_3'),
                  SizedBox(height: 16),
                  Text('Fire Detection:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(fireDetected ? 'Fire detected!' : 'No fire detected.'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

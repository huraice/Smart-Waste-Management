import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class trashMap extends StatefulWidget {
  const trashMap({super.key});

  @override
  State<trashMap> createState() => _trashMapState();
}

class _trashMapState extends State<trashMap> {
  DatabaseReference _sensorDataRef = databaseReference.child('sensorData');
  var distance = '';
  var temperature = '';
  var airQuality = '';
  String valueFromDatabase = '';

  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('data');

  @override
  void initState() {
    super.initState();
    _sensorDataRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        if (event.snapshot.value != null) {
          valueFromDatabase = event.snapshot.value.toString();
        } else {
          valueFromDatabase = '';
        }
      });
    });
  }

  void updateData() {
    _databaseReference.set(DateTime.now().toString());
  }

  void openNewWindow() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewWindow(valueFromDatabase)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Value from Real-time Database:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              valueFromDatabase,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openNewWindow,
              child: Text('Open New Window'),
            ),
            ElevatedButton(
              onPressed: updateData,
              child: Text('Update Value'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewWindow extends StatelessWidget {
  final String value;

  NewWindow(this.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Window'),
      ),
      body: Center(
        child: Text(
          'Value from Real-time Database:\n$value',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

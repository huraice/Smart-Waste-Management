import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen/screens/city_lis.dart';
// import 'package:splash_screen/screens/trash_details.dart';

class WasteManagementMap extends StatefulWidget {
  @override
  _WasteManagementMapState createState() => _WasteManagementMapState();
}

class _WasteManagementMapState extends State<WasteManagementMap> {
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
  double avgWaste1 = 0.0;
  Avgwaste(double type3) {
    avgWaste1 = type3;
  }
  //
  // final UrlLauncherPlatform launcher = UrlLauncherPlatform.instance;

  // Future<void>? _launched;

  void updateSensorData() {
    sensorDataRef.once().then((DatabaseEvent event) {
      var data =
          event.snapshot.value as Map<dynamic, dynamic>?; // Use nullable type
      if (data != null) {
        setState(() {
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
          Avgwaste(avgWaste);
          // print(avgWaste);
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
        return (avgWaste);
      }
    });
  }

  GoogleMapController? controller;
  Set<Marker> _markers = Set.from([]);
  Map<MarkerId, Bin> _markerBinMap = {};
  List<LatLng> _polyLines = [];
  @override
  void initState() {
    super.initState();
    updateSensorData();
    _addMarkers();
    super.initState();
    updateSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Management Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              controller = controller;
              // Add markers to represent bins
              _addMarkers();
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                8.650105,
                76.988788,
              ), // Initial map position
              zoom: 12,
            ),
            markers: _markers,
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                color: Color.fromARGB(255, 168, 18, 18),
                points: _polyLines,
              ),
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addMarkers();
                    _calculateRoutes;
                    updateSensorData;
                    // print(avgWaste);
                  },
                  child: Text('AI Routing'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _clearRoutes,
                  child: Text('Exit Route'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addMarkers() {
    // double avgWaste1 = 0.0;
    // print(avgWaste1);
    print(avgWaste);

    // Mock data for bins (replace with your actual data)
    List<Bin> bins = [
      Bin(
          id: 'Kalliyod',
          latitude: 8.650105,
          longitude: 76.988788,
          wasteCollected: 80),
      Bin(
          id: 'Heera College',
          latitude: 8.650890,
          longitude: 76.985548,
          wasteCollected: avgWaste1),
      Bin(
          id: 'Nedumangad',
          latitude: 8.610715,
          longitude: 76.997707,
          wasteCollected: 70),
      // Add more bins here
    ];
    // Add markers for each bin
    _markers.clear(); // Clear existing markers
    _markerBinMap.clear(); // Clear existing associations
    bins.forEach((bin) {
      MarkerId markerId = MarkerId(bin.id.toString());
      _markerBinMap[markerId] = bin; // Associate marker with bin
      _markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(bin.latitude, bin.longitude),
          onTap: () {
            _showWasteCollected(bin.wasteCollected);
          },
          infoWindow: InfoWindow(
            title: 'Bin ${bin.id}',
            snippet: 'Waste collected: ${bin.wasteCollected}%',
          ),
        ),
      );
    });
  }

  void _showWasteCollected(double percentage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Waste Collected'),
          content: Text('Waste collected: $percentage%'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CityListScreen(),
                  ),
                );
              },
              child: Text('View'),
            ),
          ],
        );
      },
    );
  }

  void _calculateRoutes() {
    // Filter bins with waste collected more than 60%

    List<Bin> highWasteBins =
        _markerBinMap.values.where((bin) => bin.wasteCollected > 60).toList();

    if (highWasteBins.length < 2) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cannot Show'),
            content:
                Text('Less than two high waste bins, cannot calculate route'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
      // Less than two high waste bins, cannot calculate route
      print('Less than two high waste bins, cannot calculate route');
      return;
    }

    // Calculate routes between high waste bins
    _polyLines.clear();
    for (int i = 0; i < highWasteBins.length - 1; i++) {
      Bin startBin = highWasteBins[i];
      Bin endBin = highWasteBins[i + 1];
      _addPolyline(startBin.latitude, startBin.longitude, endBin.latitude,
          endBin.longitude);
    }
  }

  void _addPolyline(
      double startLat, double startLng, double endLat, double endLng) {
    _polyLines.add(LatLng(startLat, startLng));
    _polyLines.add(LatLng(endLat, endLng));
    setState(() {});
  }

  void _clearRoutes() {
    _polyLines.clear();
    setState(() {});
  }
}

class Bin {
  final String id;
  final double latitude;
  final double longitude;
  final double wasteCollected;

  Bin({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.wasteCollected,
  });
}

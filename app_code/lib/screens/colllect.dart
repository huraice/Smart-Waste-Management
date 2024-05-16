// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:firebase_database/firebase_database.dart';

// class WasteCollectionPage extends StatefulWidget {
//   @override
//   _WasteCollectionPageState createState() => _WasteCollectionPageState();
// }

// class _WasteCollectionPageState extends State<WasteCollectionPage> {
//   GoogleMapController? _mapController;
//   final databaseReference = FirebaseDatabase.instance.reference();
//   List<Map<String, dynamic>> wasteBins = [];

//   @override
//   void initState() {
//     super.initState();
//     _getWasteBinLocations();
//   }

//   void _getWasteBinLocations() {
//     databaseReference.child("waste_bins").once().then((DataSnapshot snapshot) {
//       setState(() {
//         wasteBins = List<Map<String, dynamic>>.from(snapshot.value);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Waste Collection Map'),
//       ),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(0, 0),
//           zoom: 10.0,
//         ),
//         markers: _buildMarkers(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _navigateToWasteBins();
//         },
//         child: Icon(Icons.navigation),
//       ),
//     );
//   }

//   Set<Marker> _buildMarkers() {
//     return wasteBins.map((bin) {
//       return Marker(
//         markerId: MarkerId(bin['id']),
//         position: LatLng(bin['latitude'], bin['longitude']),
//         infoWindow: InfoWindow(
//           title: bin['name'],
//           snippet: 'Waste Level: ${bin['wasteLevel']}%',
//         ),
//       );
//     }).toSet();
//   }

//   void _navigateToWasteBins() {
//     // Sort waste bins by waste level in descending order
//     wasteBins.sort((a, b) => b['wasteLevel'].compareTo(a['wasteLevel']));

//     // Extract locations of waste bins
//     List<LatLng> locations = wasteBins.map((bin) {
//       return LatLng(bin['latitude'], bin['longitude']);
//     }).toList();

//     // Navigate to waste bins starting from those with 100% waste level
//     for (LatLng location in locations) {
//       // Implement navigation logic here
//     }
//   }
// }

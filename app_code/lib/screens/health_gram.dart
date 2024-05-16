import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  Marker? _truckMarker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _locateTruck() {
    // For demonstration, let's use a fixed location for the truck.
    // You can modify this to get real-time truck location data.
    LatLng truckLocation = LatLng(37.7749, -122.4194); // Example: San Francisco

    setState(() {
      _truckMarker = Marker(
        markerId: MarkerId('truck'),
        position: truckLocation,
        infoWindow: InfoWindow(title: 'Truck Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });

    _moveCamera(truckLocation);
  }

  Future<void> _moveCamera(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 14.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Stack(
        children: [
          _buildMap(),
          Positioned(
            bottom: 20,
            right: 15,
            child: FloatingActionButton(
              onPressed: _locateTruck,
              child: Icon(Icons.local_shipping),
              backgroundColor: Colors.blue,
              tooltip: 'Locate Truck',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_currentPosition != null) {
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: _truckMarker != null ? {_truckMarker!} : {},
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

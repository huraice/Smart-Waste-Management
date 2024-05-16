import 'package:flutter/material.dart';

class CityDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String cityName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('City Details'),
      ),
      body: Center(
        child: Text('Details of $cityName'),
      ),
    );
  }
}

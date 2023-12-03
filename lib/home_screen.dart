import 'dart:convert';
import '/repairer/repairer-list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'helper/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // http://192.168.184.247/home_service_backend/public/api/service

  static const IconData access_alarm_sharp =
      IconData(0xe738, fontFamily: 'MaterialIcons');

  bool isGet = true;
  List serviceTypes = [];


  //1. Add these two variables
  double latitude = 0.0;
  double longitude = 0.0;

  getData() async {
    var url = Uri.parse('$apiUrl/service');

    var resp = await http.get(url);

    if (resp.statusCode == 200) {
      setState(() {
        isGet = false;
        serviceTypes = jsonDecode(resp.body);
      });
    }
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    print(position.latitude);
    print(position.longitude);

    setState(() {
      //2. Add these two lines
      latitude = position.latitude;
      longitude = position.longitude;
      isGet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isGet) {
      getData();
      _determinePosition();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          for (int i = 0; i < serviceTypes.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RepairerList(
                        serviceId: serviceTypes[i]['id'].toString(),
                        serviceName: serviceTypes[i]['name'],
                        //3. Add these two lines
                        latitude: latitude,
                        longitude: longitude,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 1,
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconData(
                          int.parse(serviceTypes[i]['icon_code']),
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 50,
                        color: Colors.amber,
                      ),
                      Text(
                        serviceTypes[i]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

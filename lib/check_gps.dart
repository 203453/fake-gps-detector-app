import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

class CheckGps extends StatefulWidget {
  const CheckGps({super.key});

  @override
  State<CheckGps> createState() => _CheckGpsState();
}

class _CheckGpsState extends State<CheckGps> {
  String? latitude;
  String? longitude;
  bool? isMock;
  bool showInfo = false;

  @override
  void initState() {
    requestPermissions();
    super.initState();
  }

  void requestPermissions() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      TrustLocation.start(5);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  }

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) {
        setState(() {
          latitude = result.latitude;
          longitude = result.longitude;
          isMock = result.isMockLocation;
          showInfo = true;
        });
      });
    } catch (e) {
      print("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showInfo
            ? Text(
                "Latitud: $latitude\nLongitud: $longitude\nFake GPS: $isMock")
            : const CircularProgressIndicator(),
      ),
    );
  }
}

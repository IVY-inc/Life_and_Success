import 'package:fitness_flutter/screens/settings/data/models/devices.dart';
import 'package:flutter/material.dart';



class DevicesTile extends StatelessWidget {
  final Devices devices;

  const DevicesTile({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  devices.image,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devices.deviceName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.bluetooth),
                      Text(devices.isConnected ? ' Connected' : ' Disconnected'),
                      SizedBox(width: 10),
                      Icon(Icons.battery_alert), // Use battery_alert or battery_unknown
                      Text(
                        devices.batteryPercentage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
@override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(devices as String),
      onTap: () {
        // Implement onTap behavior if needed
      },
    );
  }

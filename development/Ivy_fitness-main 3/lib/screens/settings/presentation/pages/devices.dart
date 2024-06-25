import 'package:fitness_flutter/screens/settings/data/models/devices.dart';
import 'package:fitness_flutter/screens/settings/presentation/widgets/devices_tile.dart';
import 'package:flutter/material.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  bool isConnected = false;

  void toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text(''),
        // Assuming FitnessAppBar is a custom widget, replace with AppBar if not needed.
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Устройства',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Icon(Icons.drag_indicator),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DevicesTile(devices: devices[index]);
              },
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Добавить устройство',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: toggleConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected ? Colors.red : Colors.green,
                ),
                child: Text(
                  isConnected ? 'Разъединенный' : 'Связанный',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                isConnected ? 'Связанный' : 'Разъединенный',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isConnected ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

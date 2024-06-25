class Devices {
  final String deviceName;
  final String image;
  final String batteryPercentage;
  final bool isConnected;

  Devices(
      {required this.deviceName,
      required this.image,
      required this.batteryPercentage,
      required this.isConnected});
}

final devices = [
  Devices(
      deviceName: 'HUAWEI WATCH FIT 2',
      image: 'assets/images/devices/devices.png',
      batteryPercentage: '85%',
      isConnected: true),
];

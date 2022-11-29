import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_speed/callbacks_enum.dart';
import 'package:internet_speed/internet_speed.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:project_vpn_marist_dev/common/app_colors.dart';
import 'package:project_vpn_marist_dev/common/constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isActive = false;
  late OpenVPN openvpn;
  VpnStatus? status;
  VPNStage? stage;
  bool _granted = false;
  InternetSpeed internetSpeed = InternetSpeed();
  double downloadRate = 0;
  double uploadRate = 0;
  double downloadProgress = 0;
  double uploadProgress = 0;
  String unitText = 'Mb/s';

  @override
  void initState() {
    openvpn = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = data;
        });
      },
    );

    openvpn.initialize(
      groupIdentifier: "group.com.marist.vpn",
      providerBundleIdentifier: "id.marist.openvpnFlutterExample.VPNExtension",
      localizedDescription: "MaristVPN",
      lastStage: (stage) {
        setState(() {
          this.stage = stage;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    super.initState();
  }

  Future<void> initPlatformState() async {
    openvpn.connect(config, "KOREA",
        username: defaultVpnUsername,
        password: defaultVpnPassword,
        certIsRequired: true);
    if (!mounted) return;
  }

  void disconnect() {
    openvpn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: secndryColor),
        actionsIconTheme: const IconThemeData(color: secndryColor),
        title: const Text(
          "Marist",
          style: TextStyle(color: secndryColor),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: const [
            DrawerHeader(
              child: Text(
                'Marist VPN',
                style: TextStyle(
                    color: kPrimaryClr,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.11,
            ),
            Center(
              child: InkWell(
                onTap: (() {
                  setState(
                    () {
                      isActive = !isActive;
                      if (isActive == true) {
                        initPlatformState();
                      } else {
                        disconnect();
                      }
                    },
                  );
                  internetSpeed.startDownloadTesting(
                    onDone: (double transferRate, SpeedUnit unit) {
                      debugPrint('the transfer rate $transferRate');
                      setState(() {
                        downloadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        downloadProgress = 10000000;
                      });
                    },
                    onProgress:
                        (double percent, double transferRate, SpeedUnit unit) {
                      debugPrint('the transfer rate $transferRate');
                      setState(() {
                        downloadRate = transferRate;
                        unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                        downloadProgress = percent.truncateToDouble();
                      });
                    },
                    onError: (String errorMessage, String speedTestError) {
                      downloadProgress = 0;
                      debugPrint(
                          'the errorMessage $errorMessage, the speedTestError $speedTestError');
                    },
                    fileSize: 1000000,
                  );
                }),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                    padding: const EdgeInsets.all(05),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        color: kWhiteClr,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            size: 30,
                            color: isActive == true ? Colors.red : Colors.black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            isActive == true ? "STOP" : "START",
                            style: TextStyle(
                              color:
                                  isActive == true ? Colors.red : Colors.green,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.11,
            ),
            Text(' $downloadRate $unitText'),

            SizedBox(
              height: size.height * 0.11,
            ),
            //connection section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: isActive == true
                      ? kPrimaryClr
                      : kPrimaryClr.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  isActive == true ? "Connected" : "Not Connected",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w200,
                      color: secndryColor),
                ),
              ),
            ),

            if (Platform.isAndroid)
              TextButton(
                child: Text(_granted ? "Granted" : "Request Permission"),
                onPressed: () {
                  openvpn.requestPermissionAndroid().then((value) {
                    setState(() {
                      _granted = value;
                    });
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

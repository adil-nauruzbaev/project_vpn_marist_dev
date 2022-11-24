import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  bool _granted = false;

  void initState() {
    engine = OpenVPN(
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

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
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
    engine.connect(config, "KOREA",
        username: defaultVpnUsername,
        password: defaultVpnPassword,
        certIsRequired: true);
    if (!mounted) return;
  }

  void disconnect() {
    engine.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
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
          children: [
            const DrawerHeader(
              child: Text(
                'Marist',
                style: TextStyle(
                    color: kPrimaryClr,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Container()));
              },
              leading: const Icon(
                Icons.translate,
                color: Colors.black,
              ),
              title: const Text(
                "Select Language",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 12,
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
              height: _size.height * 0.11,
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
                      width:150,
                      decoration: const BoxDecoration(
                        color:kWhiteClr,
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
              height: _size.height * 0.11,
            ),
            //connection section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: isActive == true? kPrimaryClr: kPrimaryClr.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  isActive == true ? "Connected" : "Not Connected",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: secndryColor),
                ),
                 
              ),
      
            ),
            
            
            
            
            if (Platform.isAndroid)
                TextButton(
                  child: Text(_granted ? "Granted" : "Request Permission"),
                  onPressed: () {
                    engine.requestPermissionAndroid().then((value) {
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
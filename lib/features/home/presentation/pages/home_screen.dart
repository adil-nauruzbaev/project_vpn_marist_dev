import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isactive=false;
  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  bool _granted = false;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
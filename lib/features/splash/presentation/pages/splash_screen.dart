import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_vpn_marist_dev/common/app_colors.dart';
import 'package:project_vpn_marist_dev/features/home/presentation/pages/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }); 
    return const Scaffold(
      body: Center(
        child: SpinKitSpinningLines(color: kSpinKitColor, size: 1000,),
      ),
    );
  }
}
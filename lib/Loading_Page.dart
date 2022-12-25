// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 700), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: SpinKitWave(
            color: Colors.white,
            size: 80,
          ),
        ),
      ),
    );
  }
}

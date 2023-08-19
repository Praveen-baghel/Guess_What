// ignore_for_file: overridden_fields, override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:flutter_application_5/HomePage.dart';
import 'package:flutter_application_5/ServerPage.dart';
// import 'package:flutter_application_5/widgets/PaintScreen.dart';

void main() {
  runApp( const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Key key = UniqueKey();

  void restartGame(){
    setState(() {
      key = UniqueKey();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ServerPage(),
    );
  }
}

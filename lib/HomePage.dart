// ignore_for_file: file_names, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_application_5/CreateRoomPage.dart';
import 'package:flutter_application_5/JoinRoomPage.dart';
import 'package:flutter_application_5/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Create/Join room to play",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateRoomPage())),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white)),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2.5, 50))),
                  child: Text("Create", style: TextStyle(fontSize: 16))),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const JoinRoomPage())),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white)),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2.5, 50))),
                  child: Text("Join", style: TextStyle(fontSize: 16)))
            ],
          )
        ],
      ),
    );
  }
}

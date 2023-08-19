// ignore_for_file: file_names, prefer_const_constructors, unused_import, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_5/CreateRoomPage.dart';
import 'package:flutter_application_5/JoinRoomPage.dart';
import 'package:flutter_application_5/main.dart';

class HomePage extends StatefulWidget {
  final String serverIp;
  HomePage({super.key, required this.serverIp});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/set-background-image-flutter-hero.webp'),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
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
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateRoomPage(serverIp: widget.serverIp))),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreenAccent),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(color: Colors.black)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2.5, 50))),
                    child: Text("Create",
                        style: TextStyle(color: Colors.black, fontSize: 16))),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                JoinRoomPage(serverIp: widget.serverIp))),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightGreenAccent),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(color: Colors.black)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2.5, 50))),
                    child: Text("Join",
                        style: TextStyle(color: Colors.black, fontSize: 16)))
              ],
            )
          ],
        ),
      ),
    );
  }
}

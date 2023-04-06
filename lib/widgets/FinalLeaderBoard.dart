// ignore_for_file: file_names, prefer_const_constructors, unused_import, library_prefixes, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_web_libraries_in_flutter, prefer_final_fields, unnecessary_null_comparison, await_only_futures, unused_field, unnecessary_new, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_import, implementation_imports

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_5/main.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:restart_app/restart_app.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FinalLeaderBoard extends StatelessWidget {
  final scoreBoard;
  final String winner;
  const FinalLeaderBoard({super.key, required this.winner, this.scoreBoard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        height: double.maxFinite,
        child: Column(
          children: [
            Center(
              child: Text(
                "LEADERBOARD",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: scoreBoard.length,
                itemBuilder: (context, index) {
                  var data = scoreBoard[index].values;
                  return ListTile(
                    title: Text(
                      data.elementAt(0),
                      style: TextStyle(color: Colors.black, fontSize: 23),
                    ),
                    trailing: Text(
                      data.elementAt(1),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "$winner has won the game.",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Colors.white)),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width / 4, 50))),
                child: Text("Restart game", style: TextStyle(fontSize: 16)))
          ],
        ),
      ),
    );
  }
}

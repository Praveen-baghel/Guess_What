// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_application_5/main.dart';
import 'package:flutter_application_5/widgets/CustomTextField.dart';
import 'package:flutter_application_5/widgets/PaintScreen.dart';

class CreateRoomPage extends StatefulWidget {
  final String serverIp;
  const CreateRoomPage({super.key, required this.serverIp});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _serverIpController = TextEditingController();
  late String? _maxRounds;
  late String? _roomSize;

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRounds != null &&
        _roomSize != null) {
      Map<String, String> data = {
        'nickName': _nameController.text,
        'name': _roomNameController.text,
        'occupancy': _roomSize!,
        'maxRounds': _maxRounds!,
        'serverIp': widget.serverIp
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PaintScreen(data: data, screenFrom: 'createRoom')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Room Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Create Room",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: _nameController,
              hintText: 'Enter your name',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: _roomNameController,
              hintText: 'Enter room name',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            focusColor: Color(0xffF5F5FA),
            items: <String>[
              "1",
              "2",
              "3",
              "4",
              "5",
              "6",
              "7",
              "8",
              "9",
              "10",
              "15"
            ]
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              "Select max rounds",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (String? value) {
              setState(() {
                _maxRounds = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            focusColor: Color(0xffF5F5FA),
            items: <String>["2", "3", "4", "5", "6", "7", "8", "10"]
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
              "Select room size",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            onChanged: (String? value) {
              setState(() {
                _roomSize = value;
              });
            },
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: createRoom,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                textStyle:
                    MaterialStateProperty.all(TextStyle(color: Colors.white)),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width / 2.5, 50))),
            child: Text(
              "Create",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

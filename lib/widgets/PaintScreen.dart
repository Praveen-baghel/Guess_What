// ignore_for_file: file_names, prefer_const_constructors, unused_import, library_prefixes, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_web_libraries_in_flutter, prefer_final_fields, unnecessary_null_comparison, await_only_futures, unused_field, unnecessary_new, non_constant_identifier_names
// import 'dart:html';

import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_5/HomePage.dart';
import 'package:flutter_application_5/Loading_Page.dart';
import 'package:flutter_application_5/ServerPage.dart';
import 'package:flutter_application_5/models/TouchPoints.dart';
import 'package:flutter_application_5/widgets/CustomDrawer.dart';
import 'package:flutter_application_5/widgets/FinalLeaderBoard.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/MyCustomPainter.dart';
import 'WaitingLobbyPage.dart';

class PaintScreen extends StatefulWidget {
  final Map<String, String> data;
  final String screenFrom;
  PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  List<Map> messages = [];
  ScrollController _scrollController = ScrollController();
  late IO.Socket _socket;
  List<TouchPoints> points = [];
  Map dataOfRoom = {};
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  List<Widget> textBlankWidget = [];
  TextEditingController controller = TextEditingController();
  int guessedUserCtr = 0;
  int _start = 60;
  late Timer _timer;
  var scaffold_key = GlobalKey<ScaffoldState>();
  List<Map> scoreBoard = [];
  bool isInputReadOnly = false;
  int maxPoints = 0;
  String winner = "";
  bool showLeaderBoard = false;

  void renderBlankList(String text) {
    textBlankWidget.clear();
    for (int i = 0; i < text.length; i++) {
      textBlankWidget.add(Text(
        '_',
        style: TextStyle(fontSize: 30),
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connect(); // print(widget.data);
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSecond, (Timer time) {
      if (_start == 0) {
        print(
            'requesting change turn due to time limit by ${widget.data["nickName"]}');
        setState(() {
          _timer.cancel();
        });
        _socket.emit('change-turn-time', dataOfRoom['name']);
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void connect() {
    _socket = IO.io(widget.data['serverIp'], <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();
    _socket.onConnect((data) {
      print('Connected!');

      if (widget.screenFrom == 'createRoom') {
        _socket.emit('create-room', widget.data);
      } else {
        _socket.emit('join-room', widget.data);
      }

      _socket.on('updateRoom', (data) {
        setState(() {
          renderBlankList(data['word']);
          dataOfRoom = data;
        });
        if (data['isJoin'] != true) {
          // Start the timer
          startTimer();
        }
        scoreBoard.clear();
        for (int i = 0; i < data['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'userName': data['players'][i]['nickName'],
              'score': data['players'][i]['points'].toString()
            });
          });
        }
      });
      _socket.on(
          'notCorrectGame',
          (data) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ServerPage()),
              (route) => false));
      _socket.on('points', (point) {
        setState(() {
          points.add(TouchPoints(
            points: Offset((point['x']).toDouble(), (point['y']).toDouble()),
            paint: Paint()
              ..strokeCap = strokeType
              ..isAntiAlias = true
              ..color = selectedColor.withOpacity(opacity)
              ..strokeWidth = strokeWidth,
          ));
        });
      });

      _socket.on('clear-screen', (str) {
        setState(() {
          points.clear();
        });
      });

      _socket.on('color-change', (colorString) {
        int val = int.parse(colorString, radix: 16);
        Color otherColor = Color(val);
        setState(() {
          selectedColor = otherColor;
        });
      });
      _socket.on('strokeWidth-change', (val) {
        setState(() {
          strokeWidth = val;
        });
      });
      _socket.on('msg', (obj) {
        setState(() {
          messages.add(obj);
          guessedUserCtr = obj['guessedUserCtr'];
        });
        if (obj['userName'] == widget.data['nickName']) {
          if (guessedUserCtr == dataOfRoom['players'].length - 1) {
            print(
                'requesting change turn due to max guess by ${widget.data["nickName"]}');
            _socket.emit('change-turn-guess', dataOfRoom['name']);
          }
        }
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 40,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      });
      _socket.on('change-turn', (data) {
        String oldWord = dataOfRoom['word'];
        // print("${widget.data['nickName']}=>${data['turn']['nickName']}");
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(milliseconds: 2000), () {
                setState(() {
                  dataOfRoom = data;
                  renderBlankList(data['word']);
                  isInputReadOnly = false;
                  guessedUserCtr = 0;
                  _start = 60;
                  points.clear();
                });
                Navigator.of(context).pop();
                _timer.cancel();
                startTimer();
              });
              return AlertDialog(
                title: Center(
                  child: Text('Word was $oldWord'),
                ),
              );
            });
      });
      _socket.on('closeInput', (_) {
        _socket.emit('updateScore', widget.data['name']);
        setState(() {
          isInputReadOnly = true;
        });
      });
      _socket.on('updateScore', (data) {
        scoreBoard.clear();
        for (int i = 0; i < data['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'userName': data['players'][i]['nickName'],
              'score': data['players'][i]['points'].toString()
            });
          });
        }
      });
      _socket.on('leaderBoard', (players) {
        scoreBoard.clear();
        for (int i = 0; i < players.length; i++) {
          setState(() {
            scoreBoard.add({
              'userName': players[i]['nickName'],
              'score': players[i]['points'].toString()
            });
          });
          if (maxPoints < int.parse(scoreBoard[i]['score'])) {
            winner = scoreBoard[i]['userName'];
            maxPoints = int.parse(scoreBoard[i]['score']);
          }
        }
        setState(() {
          showLeaderBoard = true;
          _timer.cancel();
        });
      });
      // _socket.on('user-disconnected',(data){
      //   scoreBoard.clear();
      //   for (int i = 0; i < data['players'].length; i++) {
      //     setState(() {
      //       scoreBoard.add({
      //         'userName': data['players'][i]['nickName'],
      //         'score': data['players'][i]['points'].toString()
      //       });
      //     });
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffold_key,
      drawer: CustomDrawer(userData: scoreBoard),
      backgroundColor: Colors.white,
      body: dataOfRoom!=null
          ? dataOfRoom['isJoin'] != true
              ? !showLeaderBoard
                  ? Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              height: height * 0.55,
                              child: GestureDetector(
                                onPanStart: (details) {
                                  _socket.emit('paint', {
                                    'x': details.localPosition.dx,
                                    'y': details.localPosition.dy,
                                    'roomName': widget.data['name'],
                                  });
                                },
                                onPanUpdate: (details) {
                                  _socket.emit('paint', {
                                    'x': details.localPosition.dx,
                                    'y': details.localPosition.dy,
                                    'roomName': widget.data['name'],
                                  });
                                },
                                onPanEnd: (details) {
                                  // _socket.emit('paint', {
                                  //   'x'
                                  //   'roomName': widget.data['name'],
                                  // });
                                },
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: RepaintBoundary(
                                      child: CustomPaint(
                                        size: Size.infinite,
                                        painter:
                                            MyCustomPainter(pointsList: points),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Choose color"),
                                              content: SingleChildScrollView(
                                                child: BlockPicker(
                                                  pickerColor: selectedColor,
                                                  onColorChanged: (color) {
                                                    String colorString =
                                                        color.toString();
                                                    String valueString =
                                                        colorString
                                                            .split('(0x')[1]
                                                            .split(')')[0];
                                                    // print(colorString);
                                                    // print(valueString);
                                                    _socket.emit(
                                                        'color-change', {
                                                      'color': valueString,
                                                      'roomName':
                                                          dataOfRoom['name']
                                                    });
                                                  },
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Close"))
                                              ],
                                            ));
                                  },
                                  icon: Icon(Icons.color_lens),
                                  color: selectedColor,
                                ),
                                Expanded(
                                  child: Slider(
                                      min: 1,
                                      max: 10,
                                      label: "StrokeWidth $strokeWidth",
                                      activeColor: selectedColor,
                                      value: strokeWidth,
                                      onChanged: (value) {
                                        _socket.emit('strokeWidth-change', {
                                          'strokeWidth': value,
                                          'roomName': dataOfRoom['name']
                                        });
                                      }),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _socket.emit(
                                        'clear-screen', dataOfRoom['name']);
                                  },
                                  icon: Icon(Icons.layers_clear),
                                  color: selectedColor,
                                )
                              ],
                            ),
                            dataOfRoom['turn']['nickName'] !=
                                    widget.data['nickName']
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: textBlankWidget,
                                  )
                                : Center(
                                    child: Text(
                                      dataOfRoom['word'],
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: ListView.builder(
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  var msg = messages[index].values;
                                  return ListTile(
                                    title: Text(
                                      msg.elementAt(0),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      msg.elementAt(1),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        dataOfRoom['turn']['nickName'] !=
                                widget.data['nickName']
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    readOnly: isInputReadOnly,
                                    controller: controller,
                                    onSubmitted: (value) {
                                      if (value.trim().isNotEmpty) {
                                        Map map = {
                                          'userName': widget.data['nickName'],
                                          'msg': value.trim(),
                                          'word': dataOfRoom['word'],
                                          'roomName': dataOfRoom['name'],
                                          'guessedUserCtr': guessedUserCtr,
                                          'totalTime': 60,
                                          'timeTaken': 60 - _start
                                        };
                                        _socket.emit('msg', map);
                                        controller.clear();
                                      }
                                    },
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                      filled: true,
                                      fillColor: const Color(0xffF5F5FA),
                                      hintText: "Your Guess",
                                      hintStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              )
                            : Container(),
                        SafeArea(
                            child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                          onPressed: () =>
                              scaffold_key.currentState!.openDrawer(),
                        ))
                      ],
                    )
                  : FinalLeaderBoard(
                      scoreBoard: scoreBoard,
                      winner: winner,
                    )
              : WaitingLobbyPage(
                  occupancy: dataOfRoom['occupancy'],
                  roomName: dataOfRoom['name'],
                  noOfPlayers: dataOfRoom['players'].length,
                  players: dataOfRoom['players'])
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 7,
          backgroundColor: Colors.white,
          child: Text(
            "$_start",
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
      ),
    );
  }
}


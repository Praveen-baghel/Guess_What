import 'package:flutter/material.dart';
import 'package:flutter_application_5/HomePage.dart';
import 'package:flutter_application_5/widgets/CustomTextField.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  final TextEditingController _serverIpController = TextEditingController();
  void goHome() {
    if (_serverIpController.text.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(serverIp: _serverIpController.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/set-background-image-flutter-hero.webp'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Server Page",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          backgroundColor: Colors.lightGreen,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: _serverIpController,
                hintText: 'Enter server Ip',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: goHome,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightGreenAccent),
                  textStyle:
                      MaterialStateProperty.all(TextStyle(color: Colors.white)),
                  minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width / 2.5, 50))),
              child: Text(
                "Start Playing",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
        ),
    );
  }
}

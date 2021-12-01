import 'dart:convert';

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var controllerString = TextEditingController();
  var controllerB64 = TextEditingController();
  var controllerByte = TextEditingController();

  var base64String = 'VGVzdGUgZGUgQ29udmVyc2FvIEZsdXR0ZXI=';

  @override
  void initState() {
    controllerB64.text = base64String;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Conversor B64 e Uint8List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Valor em Base 64',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                controller: controllerB64,
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                'Valor em String',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
           padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                controller: controllerString,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                'Valor em Byte',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                controller: controllerByte,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            ElevatedButton(
              onPressed: conversor,
              child: const Text("Converter"),
            ),
          ],
        ),
      ),
    );
  }

  conversor() async {
    Uint8List? bytes = base64Decode(base64String);
    controllerB64.text = base64String;
    controllerString.text = String.fromCharCodes(bytes);
    controllerByte.text = bytes.toString();
  }
}
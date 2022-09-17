import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();
  String movie = "Huckleberry";
  String descrip = "Cuộc phiêu lưu huckle";
  IO.Socket socket = IO.io(
    "http://192.168.1.141:3000",
    IO.OptionBuilder().setTransports(['websocket']).build(),
  );
  connectSocket() {
    socket.onConnect(
      (data) => log("Connection established"),
    );
    socket.onConnectError(
      (data) => log(
        "connection failed + $data",
      ),
    );
    socket.onDisconnect(
      (data) => log(
        "socketio Server disconnected",
      ),
    );
  }

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child:
            // ? const Icon(
            //     Icons.play_arrow,
            //   )
            // :
            const Icon(
          Icons.stop_circle,
        ),
        onPressed: () async {},
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          TextField(
            controller: text1,
            decoration: const InputDecoration(hintText: "Nhập movie: "),
          ),
          const SizedBox(
            height: 100,
          ),
          TextField(
            controller: text2,
            decoration: const InputDecoration(hintText: "Nhập mô tả: "),
          ),
          const SizedBox(
            height: 100,
          ),
          Text(movie),
          Text(descrip),
          const SizedBox(
            height: 100,
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                movie = text1.text;
                descrip = text2.text;
              });
            },
            child: const Text("Upload New Movie to server"),
          ),
        ],
      ),
    );
  }
}

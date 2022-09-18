import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:testapprealtime/movie.dart';

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
  final socketResponse = StreamController<Movie>();
  String descrip = "Cuộc phiêu lưu huckle";
  IO.Socket socket = IO.io(
    "http://192.168.1.142:3000",
    IO.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
        // disable auto-connection
        .build(),
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
    socket.on(
      "message",
      (data) => log(data),
    );
    socket.on(
      "fromServer",
      (data) {
        final mov = Movie.fromMap(data);
        socketResponse.sink.add(mov);
      },
    );
  }

  @override
  void initState() {
    socket.connect();
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
          StreamBuilder<Movie>(
            stream: socketResponse.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final mov = snapshot.data;
                return Column(
                  children: [
                    Text(mov?.movie ?? ""),
                    Text(mov?.description ?? ""),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Text(movie),
                    Text(descrip),
                  ],
                );
              }
            },
          ),
          const SizedBox(
            height: 100,
          ),
          TextButton(
            onPressed: () async {
              socket.emit("message", {
                "movie": text1.text,
                "description": text2.text,
              });
              // setState(() {
              //   movie = text1.text;
              //   descrip = text2.text;
              // });
            },
            child: const Text("Upload New Movie to server"),
          ),
        ],
      ),
    );
  }
}

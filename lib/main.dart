import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const TestScreen());
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<String> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = getDataFuture();
  }

  //future function
  Future<String> getDataFuture() async {
    final result =
        await http.get(Uri.parse('https://random-word-api.herokuapp.com/word'));

    final body = jsonDecode(result.body);
    return (body as List).first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Future Builder'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Random Word',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: dataFuture,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('None');
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.active:
                      return const Text('Active');
                    case ConnectionState.done:
                      return Text(
                        '😂  ${snapshot.data}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              dataFuture = getDataFuture();
            });
          },
          child: const Icon(Icons.refresh),
        ));
  }
}

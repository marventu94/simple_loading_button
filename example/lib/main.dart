import 'package:flutter/material.dart';
import 'package:simple_loading_button/simple_loading_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Simple Loading Button Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Loading Button Demo'),
      ),
      body: Center(
        child: SimpleLoadingButton(
          label: 'Pepe',
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          //fontSize: 14,
        ),
      ),
    );
  }
}

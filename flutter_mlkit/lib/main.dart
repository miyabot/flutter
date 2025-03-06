import 'package:flutter/material.dart';

void main() {
  runApp(const Base());
}

class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:MlkitSample()
    );
  }
}

class MlkitSample extends StatefulWidget {
  const MlkitSample({super.key});

  @override
  State<MlkitSample> createState() => _MlkitSampleState();
}

class _MlkitSampleState extends State<MlkitSample> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
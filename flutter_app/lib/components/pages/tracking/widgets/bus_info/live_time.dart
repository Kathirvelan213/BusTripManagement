import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveTime extends StatefulWidget {
  @override
  _LiveTimeState createState() => _LiveTimeState();
}

class _LiveTimeState extends State<LiveTime> {
  late Timer timer;
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    currentTime = DateFormat('HH:mm').format(DateTime.now());

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateFormat('HH:mm').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      currentTime,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    );
  }
}

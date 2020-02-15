import 'package:flutter/material.dart';

import 'touch_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData.dark(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double indicatorSize;
  @override
  Widget build(BuildContext context) {
    indicatorSize = MediaQuery.of(context).size.width/4;
    return TouchIndicator(
      forceInReleaseMode: true,
      enabled: true,
      indicator: Container(
        height:  indicatorSize,
        width:  indicatorSize,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF121212),
            border: Border.all(width: 2, color: Colors.lightBlueAccent)),
      ),
      indicatorSize: indicatorSize,

      child: Material(
        color: Color(0xFF121212),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
        ),
      ),
    );
  }
}

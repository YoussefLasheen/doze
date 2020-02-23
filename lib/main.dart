import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'touch_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider.value(
        value: ValueNotifier<bool>(false),
        child: MyHomePage(),
      ),
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
    final state = Provider.of<ValueNotifier<bool>>(context);
    indicatorSize = MediaQuery.of(context).size.width/4;
    return TouchIndicator(
      forceInReleaseMode: true,
      enabled: true,
      indicator: Container(
        height:  indicatorSize,
        width:  indicatorSize,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(width: 5, color: Colors.lightBlueAccent)),
      ),
      indicatorSize: indicatorSize,

      child: Material(
        color: state.value?Colors.white:Color(0xFF121212),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
        ),
      ),
    );
  }
}

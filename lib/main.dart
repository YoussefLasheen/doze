import 'package:doze/models/settings.dart';
import 'package:doze/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ValueNotifier<napModeEnum>(napModeEnum.Touch),
      child: MaterialApp(
        home: MainScreen(),
        theme: ThemeData.dark(),
      ),
    );
  }
}

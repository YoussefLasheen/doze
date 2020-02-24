import 'package:doze/screens/nap_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox.fromSize(
          size: Size.square(MediaQuery.of(context).size.width / 2),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (_) => ValueNotifier<bool>(false),
                      child: NapScreen()),
                ),
              );
            },
            backgroundColor: Colors.cyan,
            child: Text(
              "Start your nap",
              style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

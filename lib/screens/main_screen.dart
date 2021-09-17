import 'package:doze/screens/nap_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/state_enum.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Center(
            child: CenterButton(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: HelpButton(),
          )
        ],
      ),
    );
  }
}

class CenterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200, height: 200),
      child: ElevatedButton(
        child: Text(
          'Start your nap',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (_) =>
                      ValueNotifier<stateEnum>(stateEnum.OFF),
                  child: NapScreen()),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Getting Started"),
            content: new Text(
              "Have a quick nap without regrets.\nThis app prevents you from having a deep sleep and risk waking up groggy and have a headache.\nIt wakes you up once you go unconscious.\nThe app uses your phone's sensors and touch screen to know exactly when to wake you up.",
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Understood"))
            ],
          ),
        );
      },
    );
  }
}

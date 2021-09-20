import 'package:doze/screens/main_screen/center_button.dart';
import 'package:doze/screens/main_screen/mode_toggle_buttons.dart';
import 'package:doze/screens/widgets/help_button.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          Center(
            child: CenterButton(),
          ),
          Spacer(),
          ModeToggleButtons(),
          Spacer(
            flex: 2,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: HelpButton(
              title: "Getting Started",
              desc:
                  "Have a quick nap without regrets.\nThis app prevents you from having a deep sleep and risk waking up groggy and have a headache.\nIt wakes you up once you go unconscious.\nThe app uses your phone's sensors and touch screen to know exactly when to wake you up.",
            ),
          )
        ],
      ),
    );
  }
}

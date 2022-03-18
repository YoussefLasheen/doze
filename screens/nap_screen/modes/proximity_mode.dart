import 'package:doze/models/state.dart';
import 'package:doze/screens/widgets/help_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ProximityIndicator extends StatelessWidget {
  final int timeInSeconds;

  const ProximityIndicator({Key key, this.timeInSeconds}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Align(
      alignment: Alignment.bottomRight,
      child: HelpButton(
        title: 'Proximity Censor Mode ',
        desc:
            'Put your hand on the sensor (for >2 seconds) \nto activate the alarm',
      ),
    ));
  }
}

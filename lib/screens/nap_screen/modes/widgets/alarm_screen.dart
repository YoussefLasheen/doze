

import 'package:flutter/material.dart';

import 'package:doze/models/state_enum.dart';
import 'package:provider/provider.dart';


class AlarmScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValueNotifier<stateEnum>>(context);
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Wake up!",
            style: TextStyle(fontSize: 48),
          ),
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
                state.value = stateEnum.OFF;
              },
              child: Text("DISMISS"))
        ],
      ),
    );
  }
}
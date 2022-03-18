

import 'package:flutter/material.dart';

import 'package:doze/models/state.dart';
import 'package:provider/provider.dart';


class AlarmScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<NapState>(context);
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
                _state.switchStatus(NapStateEnum.editingSettings);
              },
              child: Text("DISMISS"))
        ],
      ),
    );
  }
}
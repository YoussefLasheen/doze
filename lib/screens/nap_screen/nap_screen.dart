import 'dart:io';

import 'package:doze/models/settings.dart';
import 'package:doze/screens/nap_screen/modes/proximity_mode.dart';
import 'package:doze/screens/nap_screen/modes/widgets/alarm_screen.dart';
import 'modes/touch_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:provider/provider.dart';

import '../../models/state.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _state = context.select((ValueNotifier<state> s) => s.value.alarmStarted);

    Widget preferedMode() {
      final settings =
          Provider.of<ValueNotifier<Settings>>(context, listen: false);
      switch (settings.value.mode) {
        case napModeEnum.Proximity:
          return ProximityIndicator(timeInSeconds: settings.value.timeInSec,);

        case napModeEnum.Touch:
          {
            final _indicatorSize = MediaQuery.of(context).size.width / 4;
            return TouchIndicator(
              timeInSeconds: settings.value.timeInSec,
              enabled: true,
              indicator: Container(
                height: _indicatorSize,
                width: _indicatorSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(width: 5, color: Colors.cyan)),
              ),
              indicatorSize: _indicatorSize,
              child: Material(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                ),
              ),
            );
          }
      }
    }

    if(!_state){
      stopRing();
    }
    if (_state == true) {
      ring();
        return AlarmScreen();

    }else{
      stopRing();
        return preferedMode();

    }
  }

  void ring() {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.alarm,
      looping: false,
      volume: 1.0,
      asAlarm: true,
    );
    Platform.isAndroid
        ? FlutterScreen.resetBrightness()
        : FlutterScreen.setBrightness(0.5);
  }

  void stopRing() {
    FlutterRingtonePlayer.stop();
    Platform.isAndroid
        ? FlutterScreen.resetBrightness()
        : FlutterScreen.setBrightness(0.5);
  }
}

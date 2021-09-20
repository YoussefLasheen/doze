import 'dart:io';

import 'package:doze/models/settings.dart';
import 'package:doze/screens/nap_screen/modes/proximity_mode.dart';
import 'package:doze/screens/nap_screen/modes/widgets/alarm_screen.dart';
import 'modes/touch_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:provider/provider.dart';

import '../../models/state_enum.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValueNotifier<stateEnum>>(context);

    Widget preferedMode() {
      final settings =
          Provider.of<ValueNotifier<Settings>>(context, listen: false);
      switch (settings.value.mode) {
        case napModeEnum.Proximity:
          return ProximityIndicator();

        case napModeEnum.Touch:
          {
            final _indicatorSize = MediaQuery.of(context).size.width / 4;
            return TouchIndicator(
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

    if (state.value == stateEnum.ON) {
      FlutterScreen.setBrightness(0.0);
      FlutterScreen.keepOn(true);
    }

    switch (state.value) {
      case stateEnum.RING:
        ring();
        return AlarmScreen();

      case stateEnum.ON:
      case stateEnum.OFF:
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

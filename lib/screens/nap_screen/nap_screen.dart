import 'dart:io';

import 'package:doze/models/settings.dart';
import 'package:doze/screens/nap_screen/modes/proximity_mode.dart';
import 'modes/touch_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:provider/provider.dart';

import '../../models/state_enum.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NapScreen extends StatelessWidget {
  const NapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValueNotifier<stateEnum>>(context);
    final settings = Provider.of<ValueNotifier<Settings>>(context);
    final indicatorSize = MediaQuery.of(context).size.width / 4;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (state.value) {
        case stateEnum.ON:
          {
            FlutterScreen.setBrightness(0.0);
            FlutterScreen.keepOn(true);
            break;
          }
        case stateEnum.LOADING:
          {
            break;
          }
        case stateEnum.RING:
          {
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
            break;
          }
        case stateEnum.OFF:
          {
            FlutterRingtonePlayer.stop();
            Platform.isAndroid
                ? FlutterScreen.resetBrightness()
                : FlutterScreen.setBrightness(0.5);
            break;
          }
      }
    });
    switch (settings.value.mode) {
      case napModeEnum.Proximity:
        {
          return ProximityIndicator();
        }
        break;

      case napModeEnum.Touch:
        {
          return TouchIndicator(
            enabled: true,
            indicator: Container(
              height: indicatorSize,
              width: indicatorSize,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(width: 5, color: Colors.cyan)),
            ),
            indicatorSize: indicatorSize,
            child: Material(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
              ),
            ),
          );
        }
        break;

      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }
}

import 'dart:io';

import 'package:doze/models/settings.dart';
import 'package:doze/screens/nap_screen/modes/proximity_mode.dart';
import 'package:doze/screens/nap_screen/modes/widgets/alarm_screen.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';
import 'modes/touch_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/state.dart';


class NapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _state = Provider.of<NapState>(context);

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

    if(!(_state.napState == NapStateEnum.alarmIsOn)){
      stopRing();
    }
    if (_state.napState == NapStateEnum.alarmIsOn) {
      ring();
        return AlarmScreen();

    }else{
      stopRing();
        return preferedMode();

    }
  }

  void ring() {
    IncallManager().startRingtone(RingtoneUriType.DEFAULT, '', 50);

  }

  void stopRing() {
    IncallManager().stopRingtone();
  }
}

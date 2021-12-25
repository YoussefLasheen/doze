import 'package:flutter/material.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';

enum NapStateEnum {
  editingSettings,
  aboutToStartNap,
  napInProgress,
  alarmIsOn
}

class NapState extends ChangeNotifier{
  NapStateEnum napState = NapStateEnum.editingSettings;
  NapState({this.napState});

  void switchStatus(NapStateEnum newStatus) {
    napState = newStatus;
    notifyListeners();
  }

  void startNap(int durationInSec) {
    napState = NapStateEnum.napInProgress;
    notifyListeners();
    IncallManager().turnScreenOff();
    Future.delayed(
      Duration(seconds: durationInSec),
      () {
        switchStatus(NapStateEnum.alarmIsOn);
        IncallManager().turnScreenOn();
      },
    );
  }
}

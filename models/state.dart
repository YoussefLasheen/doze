import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_incall/flutter_incall.dart';


enum NapStateEnum {
  editingSettings,
  aboutToStartNap,
  napInProgress,
  alarmIsOn
}

class NapState extends ChangeNotifier{
  NapStateEnum napState = NapStateEnum.editingSettings;
  late StreamSubscription<dynamic> _streamSubscription;
  NapState({required this.napState});

  Future<void> switchStatus(NapStateEnum newStatus) async {
    napState = newStatus;
    if(newStatus == NapStateEnum.aboutToStartNap){await listenSensor(5);}
    //notifyListeners();
  }

  void startNap(int durationInSec) {
    napState = NapStateEnum.napInProgress;
    //notifyListeners();
    IncallManager().turnScreenOff();
    Future.delayed(
      Duration(seconds: durationInSec),
      () {
        switchStatus(NapStateEnum.alarmIsOn);
        IncallManager().turnScreenOn();
      },
    );
  }


  void ring() {
    IncallManager().startRingtone(RingtoneUriType.DEFAULT, '', 50);

  }

  void stopRing() {
    IncallManager().stopRingtone();
  }
  
  void onEventChange(event){
    if (!event) {
          bool napping = napState == NapStateEnum.napInProgress;
          switchStatus(
              napping ? NapStateEnum.alarmIsOn : NapStateEnum.napInProgress);
        } else {
          startNap(10);
        }
  }

  Future<void> listenSensor( time)async {
    bool _isNear = false;
    bool lastProxState;

    IncallManager().enableProximitySensor(true);

    _streamSubscription = IncallManager().onProximity.stream.listen((bool event) {
      if (_isNear != lastProxState) {
        lastProxState = _isNear;
        onEventChange(_isNear);
      }
    });
    
  }
}

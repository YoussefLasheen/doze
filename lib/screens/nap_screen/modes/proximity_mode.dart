import 'package:doze/models/state.dart';
import 'package:doze/screens/nap_screen/modes/widgets/alarm_screen.dart';
import 'package:doze/screens/widgets/help_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter_incall/flutter_incall.dart';
class ProximityIndicator extends StatefulWidget {
  final int timeInSeconds;

  const ProximityIndicator({Key key, this.timeInSeconds}) : super(key: key);
  @override
  _ProximityIndicatorState createState() => _ProximityIndicatorState();
}

class _ProximityIndicatorState extends State<ProximityIndicator> {
  bool _isNear = false;
  bool lastProxState;
  StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
   // IncallManager().turnScreenOn();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
        final bool _localValue = (event > 0) ? true : false;
        if(_localValue != _isNear){
          _isNear = _localValue;
          setState(() {});
        }
    });
  }



  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NapState>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isNear != lastProxState) {
        lastProxState = _isNear;
        if (!_isNear) {
          bool napping = state.napState == NapStateEnum.napInProgress;
          state.switchStatus(
              napping ? NapStateEnum.alarmIsOn : NapStateEnum.napInProgress);
        } else {
          state.startNap(widget.timeInSeconds);
        }
      }
    });
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

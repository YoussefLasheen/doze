import 'package:doze/models/state.dart';
import 'package:doze/screens/nap_screen/modes/widgets/alarm_screen.dart';
import 'package:doze/screens/widgets/help_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter_incall_manager/flutter_incall_manager.dart';
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
    _timer.cancel();
    IncallManager().turnScreenOn();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        _isNear?IncallManager().turnScreenOff():null;
      });
    });
  }

   Timer _timer;
  
  void startTimer(duration, function) {
    int _start = duration;
    _timer = new Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
            timer.cancel();
            function();
        } else {
            _start--;
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final astate = Provider.of<ValueNotifier<state>>(context);
   WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_isNear != lastProxState){
        lastProxState = _isNear;
      if (!_isNear) {
        if (!astate.value.alarmStarted) {
          if (astate.value.timerStarted) {
            astate.value = state(alarmStarted: true, timerStarted: false);
          } else {
            astate.value = state(timerStarted: false, alarmStarted: false);
          }
        }
      } else {
        astate.value = state(timerStarted: true, alarmStarted: false);
        startTimer(widget.timeInSeconds, (){astate.value = state(timerStarted: false, alarmStarted: true);});
      }
    }});
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

import 'package:doze/models/state_enum.dart';
import 'package:doze/screens/nap_screen/modes/widgets/alarm_screen.dart';
import 'package:doze/screens/widgets/help_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityIndicator extends StatefulWidget {
  @override
  _ProximityIndicatorState createState() => _ProximityIndicatorState();
}

class _ProximityIndicatorState extends State<ProximityIndicator> {
  bool _isNear = false;
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValueNotifier<stateEnum>>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => !_isNear
        ? state.value == stateEnum.RING
            ? null
            : state.value == stateEnum.ON
                ? state.value = stateEnum.RING
                : state.value = stateEnum.OFF
        : () async {
            await Future.delayed(const Duration(seconds: 2), () {
              _isNear ? state.value = stateEnum.ON : null;
            });
          }());
    switch (state.value) {
      case stateEnum.OFF:
        {
          return Material(
            child: Align(
                  alignment: Alignment.bottomRight,
                  child: HelpButton(
                    title: 'Proximity Censor Mode ',
                    desc:
                        'Put your hand on the sensor (for >2 seconds) \nto activate the alarm',
                  ),
                )
          );
        }
      case stateEnum.ON:
        {
          return WillPopScope(
            child: Container(),
            onWillPop: () async => false,
          );
        }
      case stateEnum.RING:
        {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlarmScreen()
          );
        }
      case stateEnum.LOADING:
        {
          break;
        }
    }
  }
}

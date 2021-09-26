import 'dart:async';

import 'package:doze/models/state.dart';
import 'package:doze/screens/widgets/help_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TouchIndicator extends StatefulWidget {
  final int timeInSeconds;

  final Widget child;

  final double indicatorSize;

  final Color indicatorColor;

  final Widget indicator;

  final bool enabled;

  const TouchIndicator({
    Key key,
    @required this.child,
    this.indicator,
    this.indicatorSize,
    this.indicatorColor = Colors.blueGrey,
    this.enabled = true,
    this.timeInSeconds,
  }) : super(key: key);

  @override
  _TouchIndicatorState createState() => _TouchIndicatorState();
}

class _TouchIndicatorState extends State<TouchIndicator> {
  Map<int, Offset> touchPositions = <int, Offset>{};

  Iterable<Widget> buildTouchIndicators() sync* {
    if (touchPositions != null && touchPositions.isNotEmpty) {
      for (var touchPosition in touchPositions.values.take(2)) {
        yield Positioned.directional(
          start: touchPosition.dx - widget.indicatorSize / 2,
          top: touchPosition.dy - widget.indicatorSize / 2,
          child: widget.indicator,
          textDirection: TextDirection.ltr,
        );
      }
    }
  }

  void savePointerPosition(int index, Offset position) {
    setState(() {
      touchPositions[index] = position;
    });
  }

  void clearPointerPosition(int index) {
    setState(() {
      touchPositions.remove(index);
    });
  }

  int noOfFingers = 0;

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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final astate = Provider.of<ValueNotifier<state>>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool twoFingers = touchPositions.values.length >= 2;
      if (noOfFingers != touchPositions.values.length) {
        noOfFingers = touchPositions.values.length;
        if (!twoFingers) {
          if (!astate.value.alarmStarted) {
            if (astate.value.timerStarted) {
              astate.value = state(alarmStarted: true, timerStarted: false);
            } else {
              astate.value = state(timerStarted: false, alarmStarted: false);
            }
          }
        } else {
          astate.value = state(timerStarted: true, alarmStarted: false);
          startTimer(widget.timeInSeconds, () {
            astate.value = state(timerStarted: false, alarmStarted: true);
          });
        }
      }
    });

    var children = [
      widget.child,
    ]..addAll(buildTouchIndicators());

    return Material(
      child: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (opd) {
                savePointerPosition(opd.pointer, opd.position);
              },
              onPointerMove: (opm) {
                savePointerPosition(opm.pointer, opm.position);
              },
              onPointerCancel: (opc) {
                clearPointerPosition(opc.pointer);
              },
              onPointerUp: (opc) {
                clearPointerPosition(opc.pointer);
              },
              child: Stack(children: children),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: HelpButton(
              title: 'Touch Mode',
              desc:
                  'Put your hand on screen with 2 fingers (for >2 seconds) \nto activate the alarm',
            ),
          )
        ],
      ),
    );
  }
}

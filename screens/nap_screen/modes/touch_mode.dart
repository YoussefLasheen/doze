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
    Key? key,
    required this.child,
    required this.indicator,
    required this.indicatorSize,
    this.indicatorColor = Colors.blueGrey,
    this.enabled = true,
    required this.timeInSeconds,
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
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NapState>(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      bool twoFingers = touchPositions.values.length >= 2;
      if (noOfFingers != touchPositions.values.length) {
        noOfFingers = touchPositions.values.length;
        if (!twoFingers) {
          if (!(state.napState == NapStateEnum.alarmIsOn)) {
            if (state.napState == NapStateEnum.napInProgress) {
              state.switchStatus(NapStateEnum.alarmIsOn);
            } else {
              state.switchStatus(NapStateEnum.editingSettings);
            }
          }
        } else {
          state.startNap(widget.timeInSeconds);
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

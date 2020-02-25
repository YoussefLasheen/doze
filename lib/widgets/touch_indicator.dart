import 'package:doze/screens/models/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Adds touch indicators to the screen whenever a touch occurs
///
/// This can be useful when recording videos of an app where you want to show
/// where the user has tapped. Can also be useful when running integration
/// tests or when giving demos with a screencast.
class TouchIndicator extends StatefulWidget {
  /// The child on which to show indicators
  final Widget child;

  /// The size of the indicator
  final double indicatorSize;

  /// The color of the indicator
  final Color indicatorColor;

  /// Overrides the default indicator.
  ///
  /// Make sure to set the proper [indicatorSize] to align the widget properly
  final Widget indicator;

  /// If set to false, disables the indicators from showing
  final bool enabled;

  /// Creates a touch indicator canvas
  ///
  /// Touch indicators are shown on the child whenever a touch occurs
  const TouchIndicator({
    Key key,
    @required this.child,
    this.indicator,
    this.indicatorSize,
    this.indicatorColor = Colors.blueGrey,
    this.enabled = true,
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

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValueNotifier<stateEnum>>(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => touchPositions.values.length < 2
            ? state.value = stateEnum.OFF
            : () async {
                await Future.delayed(const Duration(seconds: 2), () {
                  touchPositions.values.length >= 2 ? state.value = stateEnum.ON : null;
                });
              }());

    var children = [
      widget.child,
    ]..addAll(buildTouchIndicators());
    return Listener(
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
    );
  }
}

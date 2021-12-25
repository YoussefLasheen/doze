import 'package:animations/animations.dart';
import 'package:doze/models/settings.dart';
import 'package:doze/models/state.dart';
import 'package:doze/screens/nap_screen/nap_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CenterButton extends StatefulWidget {
  @override
  _CenterButtonState createState() => _CenterButtonState();
}

class _CenterButtonState extends State<CenterButton> {
  bool updating = false;

  double wheelSize;
  double degree = 0;
  double radius;

  int timeInSec = 0;

   @override
  void initState() {
    super.initState();
    wheelSize = 200;
    radius = wheelSize / 2;
    degree = 0;
  }
  double degreeToRadians(double degrees) => degrees * (3.14 / 180);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ValueNotifier<Settings>>(context,listen: false);
    return OpenContainer(
      closedColor: Colors.blue,
      openColor: Colors.transparent,
      closedElevation: 10,
      closedShape: CircleBorder(),
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (context, action) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 200, height: 200),
              child: Transform.rotate(
                angle: degreeToRadians(degree),
                alignment: Alignment.center,
                child: GestureDetector(
                  onPanUpdate: adjustTimeKnob,
                  onPanEnd: (DragEndDetails) {
                    new Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        updating = false;
                      });
                    });
                    settings.value.timeInSec =timeInSec;
                  },
                  behavior: HitTestBehavior.translucent,
                  child: InkWell(
                    onTap: action,
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.only(top: 5),
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 500),
              crossFadeState: updating
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                'Start',
                style: TextStyle(fontSize: 24),
              ),
              secondChild: Text(
                Duration(seconds: timeInSec).toString().split('.')[0],
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        );
      },
      openBuilder: (context, action) {
        return ChangeNotifierProvider<NapState>(
            create: (_) => NapState(),
            child: NapScreen());
      },
    );
  }

  void adjustTimeKnob(d) {
   /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absolute change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;

    double _value = degree + (rotationalChange / 5);

    setState(() {
      degree = _value > 0 ? _value : 0;
      double percentage = degree/360;
      int secInRevolotion = 300;
      timeInSec = (secInRevolotion * percentage).toInt();
      updating = true;
    });
  }
}

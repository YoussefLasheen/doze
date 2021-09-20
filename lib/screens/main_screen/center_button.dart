import 'package:animations/animations.dart';
import 'package:doze/models/state_enum.dart';
import 'package:doze/screens/nap_screen/nap_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CenterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Colors.blue,
      openColor: Colors.transparent,
      closedElevation: 10,
      closedShape: CircleBorder(),
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (context, action) {
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 200, height: 200),
          child: InkWell(
            onTap: action,
            child: Center(
              child: Text(
                'Start your nap',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
      openBuilder: (context, action) {
        return ChangeNotifierProvider(
            create: (_) => ValueNotifier<stateEnum>(stateEnum.OFF),
            child: NapScreen());
      },
    );
  }
}
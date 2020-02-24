import 'dart:io';

import 'package:doze/widgets/touch_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:provider/provider.dart';

class NapScreen extends StatelessWidget {
  const NapScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValueNotifier<bool>>(context);
    final indicatorSize = MediaQuery.of(context).size.width / 4;
    WidgetsBinding.instance.addPostFrameCallback((_) => state.value
        ? () {
            FlutterScreen.setBrightness(0.0);
            FlutterScreen.keepOn(true);
          }()
        : Platform.isAndroid
            ? FlutterScreen.resetBrightness()
            : FlutterScreen.setBrightness(0.4));
    return TouchIndicator(
      forceInReleaseMode: true,
      enabled: true,
      indicator: Container(
        height: indicatorSize,
        width: indicatorSize,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(width: 5, color: Colors.cyan)),
      ),
      indicatorSize: indicatorSize,
      child: Material(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
        ),
      ),
    );
  }
}

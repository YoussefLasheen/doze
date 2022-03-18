import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final String title;
  final String desc;
  const HelpButton({required this.title, required this.desc
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help),
      onPressed: () {
        showModal(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(title),
            content: new Text(
              desc
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Understood"))
            ],
          ),
        );
      },
    );
  }
}
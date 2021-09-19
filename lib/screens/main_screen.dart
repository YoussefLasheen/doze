import 'package:doze/models/settings.dart';
import 'package:doze/screens/nap_screen/nap_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/state_enum.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          Center(
            child: CenterButton(),
          ),
          Spacer(),
          ModeToggleButtons(),
          Spacer(
            flex: 2,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: HelpButton(),
          )
        ],
      ),
    );
  }
}

class CenterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200, height: 200),
      child: ElevatedButton(
        child: Text(
          'Start your nap',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (_) => ValueNotifier<stateEnum>(stateEnum.OFF),
                  child: NapScreen()),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          elevation: 15,
        ),
      ),
    );
  }
}

class ModeToggleButtons extends StatefulWidget {
  @override
  _ModeToggleButtonsState createState() => _ModeToggleButtonsState();
}

class _ModeToggleButtonsState extends State<ModeToggleButtons> {
  List<bool> isSelected = [false, true];
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ValueNotifier<napModeEnum>>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Expanded(
          child: FittedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: isChecked?Colors.blue:Colors.grey,
                shape: CircleBorder(),
                
              ),
              child: Icon(Icons.calculate_outlined),
              onPressed: () {
                setState(() {
                  isChecked = !isChecked;
                });
              },
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 2,
          child: FittedBox(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(50),
              fillColor: Colors.blue,
              selectedColor: Colors.white,
              borderColor: Colors.white,
              selectedBorderColor: Colors.white,
              children: <Widget>[
                ModeToggleButton("Proximity"),
                ModeToggleButton("Touch"),
              ],
              onPressed: (int index) {
                setState(
                  () {
                    settings.value = napModeEnum.values[index];
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  },
                );
              },
              isSelected: isSelected,
            ),
          ),
        ),
        Spacer()
      ],
    );
  }
}

class ModeToggleButton extends StatelessWidget {
  final String text;
  const ModeToggleButton(
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: Center(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Getting Started"),
            content: new Text(
              "Have a quick nap without regrets.\nThis app prevents you from having a deep sleep and risk waking up groggy and have a headache.\nIt wakes you up once you go unconscious.\nThe app uses your phone's sensors and touch screen to know exactly when to wake you up.",
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

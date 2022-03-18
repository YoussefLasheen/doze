import 'package:doze/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModeToggleButtons extends StatefulWidget {
  @override
  _ModeToggleButtonsState createState() => _ModeToggleButtonsState();
}

class _ModeToggleButtonsState extends State<ModeToggleButtons> {
  List<bool> isSelected = [false, true];
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ValueNotifier<Settings>>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Expanded(
          child: FittedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: isChecked ? Colors.blue : Colors.grey,
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
        SizedBox(
          width: 10,
        ),
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
                    settings.value = Settings(mode:napModeEnum.values[index], timeInSec: 0);
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

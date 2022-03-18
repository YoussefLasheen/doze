enum napModeEnum { Proximity, Touch }

class Settings {
  napModeEnum mode;
  int timeInSec;

  Settings({required this.mode, required this.timeInSec});
}

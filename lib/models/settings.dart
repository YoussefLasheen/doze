enum napModeEnum { Proximity, Touch }

class Settings {
  napModeEnum mode;
  int timeInSec;

  Settings({this.mode, this.timeInSec});
}

/// id, waktu alarm, jangka waktu klik,
///
//

class AlarmModel {
  late int id;
  late String alarmTime;
  late int pressTimePeriod;

  AlarmModel({
    required this.id,
    required this.alarmTime,
    required this.pressTimePeriod,
  });

  @override
  AlarmModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        alarmTime = json["alarm_time"],
        pressTimePeriod = json["press_time_period"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "alarm_time": alarmTime,
        "press_time_period": pressTimePeriod,
      };
}

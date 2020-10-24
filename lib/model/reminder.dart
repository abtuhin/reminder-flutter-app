import 'dart:convert';

class Reminder {
  String id;
  DateTime dateTime;
  String repetition;
  bool isActive;

  Reminder({this.id, this.dateTime, this.repetition, this.isActive});

  factory Reminder.fromJson(Map<String, dynamic> jsonData) {
    return Reminder(
      id: jsonData['id'],
      dateTime: DateTime.parse(jsonData['dateTime']),
      repetition: jsonData['repetition'],
      isActive: jsonData['isActive'],
    );
  }

  static Map<String, dynamic> toMap(Reminder reminder) => {
        'id': reminder.id,
        'dateTime': reminder.dateTime,
        'repetition': reminder.repetition,
        'isActive': reminder.isActive,
      };

  static String encodeReminders(List<Reminder> reminders) => json.encode(
      reminders
          .map<Map<String, dynamic>>((reminder) => Reminder.toMap(reminder))
          .toList(),
      toEncodable: myDateSerializer);

  static List<Reminder> decodeReminders(String reminders) =>
      (json.decode(reminders) as List<dynamic>)
          .map<Reminder>((item) => Reminder.fromJson(item))
          .toList();

  static myDateSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }
}

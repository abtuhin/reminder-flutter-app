import 'package:flutter/material.dart';
import 'package:reminder_app/pages/add_reminder.dart';
import 'package:reminder_app/pages/reminder_list.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    home: ReminderList(),
    initialRoute: '/reminder_list',
    routes: {'/add_reminder': (context) => AddReminder()},
  ));
}

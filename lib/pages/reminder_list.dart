import 'package:flutter/material.dart';
import 'package:reminder_app/model/reminder.dart';
import 'package:reminder_app/pages/add_reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ReminderList> {
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _getStorageData();
  }

  _getStorageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Reminder> decodedData =
        Reminder.decodeReminders(prefs.getString('reminder_app'));
    setState(() {
      _reminders = decodedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    _navigateAndGetReminder(BuildContext context) async {
      try {
        final data = await Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new AddReminder()));

        _reminders.add(data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('reminder_app', Reminder.encodeReminders(_reminders));
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: Colors.green,
      ),
      // body: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index){
      //     return Card(

      //     )
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndGetReminder(context);
        },
        tooltip: 'Add Reminder',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    print('asdkjl');
    print(prefs);
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

        setState(() {
          _reminders.add(data);
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('reminder_app', Reminder.encodeReminders(_reminders));
      } catch (e) {
        print(e);
      }
    }

    print(_reminders.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _reminders.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
              child: Card(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {},
                            title: Text(
                                "${DateFormat('dd-MM-yyyy hh:mm').format(_reminders[index].dateTime)}"),
                            trailing: Switch(
                              value: _reminders[index].isActive,
                              onChanged: (_) {
                                // _toggleReminder(_reminders[index].id);
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 'DAILY',
                                groupValue: _reminders[index].repetition,
                                onChanged: (_) {
                                  // _updateFrequency(_reminders[index].id,
                                  //     Repetition.daily);
                                },
                              ),
                              Text(
                                'Daily',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 'WEEKLY',
                                groupValue: _reminders[index].repetition,
                                onChanged: (_) {
                                  // _updateFrequency(_reminders[index].id,
                                  //     Repetition.weekly);
                                },
                              ),
                              Text(
                                'Weekly',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Radio(
                                value: 'MONTHLY',
                                groupValue: _reminders[index].repetition,
                                onChanged: (_) {
                                  // _updateFrequency(_reminders[index].id,
                                  //     Repetition.monthly);
                                },
                              ),
                              Text(
                                'Monthly',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

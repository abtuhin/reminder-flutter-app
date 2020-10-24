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

  void _syncStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('reminder_app', Reminder.encodeReminders(_reminders));
  }

  _getStorageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      final List<Reminder> decodedData =
          Reminder.decodeReminders(prefs.getString('reminder_app'));
      setState(() {
        _reminders = decodedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _navigateAndGetReminder(BuildContext context) async {
      try {
        final data = await Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new AddReminder()));
        if (data != null) {
          setState(() {
            _reminders.add(data);
          });

          _syncStorage();
        }
      } catch (e) {
        print(e);
      }
    }

    void _toggleReminder(String id) {
      var reminder = _reminders.firstWhere((element) => element.id == id);
      setState(() {
        reminder.isActive = !reminder.isActive;
      });
      _syncStorage();
    }

    void _updateFrequency(String id, String repetition) {
      setState(() {
        _reminders.firstWhere((element) => element.id == id).repetition =
            repetition;
      });
      _syncStorage();
    }

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
                                _toggleReminder(_reminders[index].id);
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 'DAILY',
                                groupValue: _reminders[index].repetition,
                                onChanged: (_) {
                                  _updateFrequency(
                                      _reminders[index].id, 'DAILY');
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
                                  _updateFrequency(
                                      _reminders[index].id, 'WEEKLY');
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
                                  _updateFrequency(
                                      _reminders[index].id, 'MONTHLY');
                                },
                              ),
                              Text(
                                'Monthly',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Radio(
                                value: 'YEARLY',
                                groupValue: _reminders[index].repetition,
                                onChanged: (_) {
                                  _updateFrequency(
                                      _reminders[index].id, 'YEARLY');
                                },
                              ),
                              Text(
                                'Yearly',
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

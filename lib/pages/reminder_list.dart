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
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _getStorageData();
  }

  /// Show snackbar message that passed to it as [text].
  void _showMessage(String text) {
    final snackbar = new SnackBar(content: new Text(text));
    _scafoldKey.currentState.showSnackBar(snackbar);
  }

  /// Sync shared preference with updated data.
  void _syncStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('reminder_app', Reminder.encodeReminders(_reminders));
  }

  /// Update state with repetition cycle
  /// Call sync storage function
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
    /// Callback returns with data from [AddReminder] screen when new reminder added.
    /// Callback return null if goes back from [AddReminder] screen.
    /// Add new data to shared preferences.
    /// Show snackbar when new reminder added.
    _navigateAndGetReminder(BuildContext context) async {
      try {
        final data = await Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new AddReminder()));
        if (data != null) {
          setState(() {
            _reminders.add(data);
          });
          _syncStorage();
          _showMessage("Success! You have added a new reminder.");
        }
      } catch (e) {
        print(e);
      }
    }

    /// Toggle reminder state for a reminder with [id].
    /// Update shared prefernces with updated toggle value.
    void _toggleReminder(String id) {
      var reminder = _reminders.firstWhere((element) => element.id == id);
      setState(() {
        reminder.isActive = !reminder.isActive;
      });
      _syncStorage();
    }

    /// Update reminder state with updated repetition cycle with [id] and [repetition] as params.
    /// Update shared preferences with updated repetition cycle.
    void _updateFrequency(String id, String repetition) {
      setState(() {
        _reminders.firstWhere((element) => element.id == id).repetition =
            repetition;
      });
      _syncStorage();
    }

    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: Colors.lightGreen,
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
                              activeColor: Colors.lightGreen,
                              value: _reminders[index].isActive,
                              onChanged: (_) {
                                _toggleReminder(_reminders[index].id);
                              },
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Colors.lightGreen,
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
                                activeColor: Colors.lightGreen,
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
                                activeColor: Colors.lightGreen,
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
        backgroundColor: Colors.lightGreen,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

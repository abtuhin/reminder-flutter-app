import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/model/reminder.dart';
import 'package:uuid/uuid.dart';

class AddReminder extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddReminder> {
  final GlobalKey _menuKey = new GlobalKey();
  final GlobalKey<ScaffoldState> _scafoldKey = new GlobalKey<ScaffoldState>();

  String schedule = 'NOT SELECTED';
  DateTime _date = DateTime.now();
  DateTime _time;

  void _showErrorMessage(String text) {
    final snackbar = new SnackBar(content: new Text(text));
    _scafoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final button = new PopupMenuButton(
        key: _menuKey,
        itemBuilder: (_) => <PopupMenuItem<String>>[
              new PopupMenuItem<String>(
                  child: const Text('DAILY'), value: 'DAILY'),
              new PopupMenuItem<String>(
                  child: const Text('WEEKLY'), value: 'WEEKLY'),
              new PopupMenuItem<String>(
                  child: const Text('MONTHLY'), value: 'MONTHLY'),
            ],
        onSelected: (val) {
          setState(() {
            schedule = val;
          });
        });

    final tile = new ListTile(
        tileColor: Colors.lightGreen,
        title: new Text('Select Repetition Cycle',
            style: TextStyle(color: Colors.white)),
        trailing: button,
        onTap: () {
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        });

    bool _isValid(Reminder reminder) {
      if (reminder.dateTime == null) {
        _showErrorMessage('Select date and time.');
        return false;
      } else if (reminder.repetition == 'NOT SELECTED') {
        _showErrorMessage('Select repetition cycle.');
        return false;
      }
      return true;
    }

    void _onAddReminder() {
      DateTime _dateTime = _time ??
          new DateTime(_date.year, _date.month, _date.day, DateTime.now().hour,
              DateTime.now().minute);
      Reminder reminder = new Reminder();
      reminder.id = Uuid().v1();
      reminder.dateTime = _dateTime;
      reminder.repetition = schedule;
      reminder.isActive = true;
      if (_isValid(reminder) == true) {
        Navigator.pop(context, reminder);
      }
    }

    return Scaffold(
        key: _scafoldKey,
        appBar: AppBar(
          title: Text('Add Reminder'),
          backgroundColor: Colors.lightGreen,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            theme: DatePickerTheme(
                                headerColor: Colors.green,
                                backgroundColor: Colors.lightGreen,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                cancelStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                doneStyle: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            _date = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'Select Start Date',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      onPressed: () {
                        DatePicker.showTimePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (time) {
                          setState(() {
                            _time = time;
                          });
                        }, currentTime: DateTime.now());
                      },
                      child: Text(
                        'Select Reminder Time',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  tile,
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                              " ${DateFormat('yyyy-MM-dd').format(_date)}"),
                          leading: Icon(
                            Icons.date_range,
                            color: Colors.lightGreen[500],
                          ),
                        ),
                        ListTile(
                          title: Text(
                              " ${DateFormat('HH:mm').format(_time ?? DateTime.now())}"),
                          leading: Icon(
                            Icons.schedule,
                            color: Colors.lightGreen[500],
                          ),
                        ),
                        ListTile(
                          title: Text(schedule),
                          leading: Icon(
                            Icons.alarm,
                            color: Colors.lightGreen[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    color: Colors.lightGreen,
                    textColor: Colors.white,
                    onPressed: _onAddReminder,
                    child: Text("Add"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            )));
  }
}

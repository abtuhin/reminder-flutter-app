import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddReminder extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddReminder> {
  final GlobalKey _menuKey = new GlobalKey();
  String schedule = 'NOT SELECTED';
  String startDate = '01-10-2020';
  String reminderTime = 'NOT SELECTED';

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
              new PopupMenuItem<String>(
                  child: const Text('YEARLY'), value: 'YEARLY'),
            ],
        onSelected: (val) {
          setState(() {
            schedule = val;
          });
        });

    final tile = new ListTile(
        tileColor: Colors.lightGreen,
        title: new Text('Select Reminder Scheduler'),
        trailing: button,
        onTap: () {
          dynamic state = _menuKey.currentState;
          state.showButtonMenu();
        });

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Reminder'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  color: Colors.lightGreen,
                  textColor: Colors.white,
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
                            cancelStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {}, onConfirm: (date) {
                      setState(() {
                        startDate = date.day.toString() +
                            '-' +
                            date.month.toString() +
                            '-' +
                            date.year.toString();
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Select Start Date',
                    style: TextStyle(color: Colors.white),
                  )),
              RaisedButton(
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  onPressed: () {
                    DatePicker.showTimePicker(context, showTitleActions: true,
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      setState(() {
                        reminderTime = date.hour.toString() +
                            ':' +
                            date.minute.toString() +
                            ':' +
                            date.second.toString();
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    'Select Reminder Time',
                    style: TextStyle(color: Colors.white),
                  )),
              tile,
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(startDate),
                      leading: Icon(
                        Icons.date_range,
                        color: Colors.lightGreen[500],
                      ),
                    ),
                    ListTile(
                      title: Text(reminderTime),
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
            ],
          ),
        ));
  }
}

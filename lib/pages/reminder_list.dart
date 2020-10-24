import 'package:flutter/material.dart';

class ReminderList extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ReminderList> {
  @override
  Widget build(BuildContext context) {
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
          Navigator.pushNamed(context, '/add_reminder');
        },
        tooltip: 'Add Reminder',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

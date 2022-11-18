import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/public_activity.dart';

import 'http/api.dart';
import 'utils/condition.dart';

class ActivityBuilder extends StatelessWidget {
  const ActivityBuilder({Key? key}) : super(key: key);

  static const String _title = 'Activity Builder';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          _title,
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _date = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().minute % 15 * 15);
  var _condition = Condition.none;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _condition == Condition.success
          ? 
          CustomePopup(
              title: 'Success',
              message: 'You have created activity succesfully!',
              buttonName: 'Ok',
              onPressed: () => setState(() => _condition = Condition.none))
          : _condition == Condition.fail
              ? 
              CustomePopup(
              title: 'Fail',
              message: 'Something went wrong',
              buttonName: 'Close',
              onPressed: () => setState(() => _condition = Condition.none))
              : ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Title:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(controller: _titleController),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Detail:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(controller: _detailController),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Location:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(controller: _locationController),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Date:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        maximumYear: 2030,
                        minimumYear: 2010,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime value) {
                          _date = DateTime(value.year, value.month, value.day,
                              _date.hour, _date.minute);
                        },
                        use24hFormat: false,
                        minuteInterval: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Time:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime(1, 1, 1, DateTime.now().hour,
                            DateTime.now().minute % 15 * 15),
                        onDateTimeChanged: (DateTime value) {
                          _date = DateTime(_date.year, _date.month, _date.day,
                              value.hour, value.minute);
                        },
                        use24hFormat: true,
                        minuteInterval: 15,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Phone Number:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(controller: _phoneNumberController),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            child: TextButton(
                              child: const Text("Save"),
                              onPressed: () {
                                var dateInput = DateFormat('yyyy-MM-ddTHH:mm')
                                    .format(_date);
                                Api()
                                    .createActivity(
                                        _titleController.text,
                                        _detailController.text,
                                        _locationController.text,
                                        dateInput,
                                        _phoneNumberController.text)
                                    .then(
                                      (isSuccess) => setState(
                                        () {
                                          if (isSuccess) {
                                            _condition = Condition.none;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PublicActivity(),
                                              ),
                                            );
                                          } else {
                                            _condition = Condition.fail;
                                          }
                                        },
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

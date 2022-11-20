import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/public_activity.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:social/utils/helper.dart';

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

  late DateTime _now;
  late DateTime _initDate;

  var _condition = Condition.none;

  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int _currentCapacity = 10;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _initDate = DateTime(_now.year, _now.month, _now.day, _now.hour, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _condition == Condition.success
          ? CustomePopup(
              title: 'Success',
              message: 'You have created activity succesfully!',
              buttonName: 'Ok',
              onPressed: () => setState(() => _condition = Condition.none))
          : _condition == Condition.fail
              ? CustomePopup(
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
                      height: MediaQuery.of(context).copyWith().size.height * 0.25,
                      // MediaQuery.of(context).copyWith().size.height * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        maximumYear: 2030,
                        minimumYear: 2022,
                        initialDateTime: _initDate,
                        onDateTimeChanged: (DateTime value) {
                          year = value.year;
                          month = value.month;
                          day = value.day;
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
                      height: MediaQuery.of(context).copyWith().size.height * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: _initDate,
                        onDateTimeChanged: (DateTime value) {
                          hour = value.hour;
                          minute = value.minute;
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
                      child: TextField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                      child: const Text(
                        "Capacity:",
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
                      child: NumberPicker(
                        value: _currentCapacity,
                        minValue: 0,
                        maxValue: 100,
                        axis: Axis.horizontal,
                        itemWidth: 50,
                        onChanged: (value) =>
                            setState(() => _currentCapacity = value),
                      ),
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
                            child: ElevatedButton(
                              child: const Text("Save"),
                              onPressed: () {
                                var dateInput = DateFormat('yyyy-MM-ddTHH:mm')
                                    .format(DateTime(
                                        year, month, day, hour, minute));
                                Api()
                                    .createActivity(
                                        _titleController.text,
                                        _detailController.text,
                                        _locationController.text,
                                        dateInput,
                                        _phoneNumberController.text,
                                        _currentCapacity)
                                    .then(
                                      (isSuccess) => setState(
                                        () {
                                          if (isSuccess) {
                                            _condition = Condition.none;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PublicActivity(),
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

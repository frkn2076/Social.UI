import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/dashboard.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:social/http/api.dart';
import 'package:social/utils/condition.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ActivityBuilder extends StatelessWidget {
  const ActivityBuilder({Key? key}) : super(key: key);

  static const String _title = 'Activity Builder';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
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
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '(000)000-00-00');
  final TextEditingController _locationController = TextEditingController();

  late DateTime _now;
  late DateTime _initDate;

  var _condition = Condition.none;

  String? _category;

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
    year = _now.year;
    month = _now.month;
    day = _now.day;
    hour = _now.hour;
  }

  String _errorMessage = "Something went wrong";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customeBackground(),
      padding: const EdgeInsets.all(10),
      child: _condition == Condition.success
          ? CustomePopup(
              title: 'Success',
              message: 'You have created activity succesfully!',
              buttonName: 'Ok',
              onPressed: () {
                setState(() => _condition = Condition.none);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                );
              })
          : _condition == Condition.fail
              ? CustomePopup(
                  title: 'Fail',
                  message: _errorMessage,
                  buttonName: 'Ok',
                  onPressed: () => setState(() => _condition = Condition.none))
              : ListView(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: DropdownButton<String>(
                            dropdownColor:
                                const Color.fromARGB(255, 167, 143, 234),
                            hint: const Text('Pick a category'),
                            isExpanded: true,
                            value: _category,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _category = value!;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: 'picnic',
                                child: Row(
                                  children: [
                                    const Text('picnic'),
                                    const Spacer(),
                                    Image.asset(
                                      "assets/images/categories/picnic.jpg",
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'cinema',
                                child: Row(
                                  children: [
                                    const Text('cinema'),
                                    const Spacer(),
                                    Image.asset(
                                      "assets/images/categories/cinema.jpg",
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'sport',
                                child: Row(
                                  children: [
                                    const Text('sport'),
                                    const Spacer(),
                                    Image.asset(
                                      "assets/images/categories/sport.jpg",
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'other',
                                child: Row(
                                  children: [
                                    const Text('other'),
                                    const Spacer(),
                                    Image.asset(
                                      "assets/images/categories/other.jpg",
                                      fit: BoxFit.contain,
                                    )
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          labelText: 'Title',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextField(
                        controller: _detailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          labelText: 'Detail',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          labelText: 'Location',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.20,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
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
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.20,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                              child: TextField(
                                controller: _phoneNumberController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'PhoneNumber',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Capacity',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: NumberPicker(
                                value: _currentCapacity,
                                minValue: 2,
                                maxValue: 100,
                                axis: Axis.horizontal,
                                itemWidth: 45,
                                itemHeight: 20,
                                onChanged: (value) =>
                                    setState(() => _currentCapacity = value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //this enable feedback helps to turn off the sound on click
                              enableFeedback: false,
                            ),
                            child: const Text("Save"),
                            onPressed: () {
                              var dateInput = DateFormat('yyyy-MM-ddTHH:mm')
                                  .format(
                                      DateTime(year, month, day, hour, minute));
                              Api()
                                  .createActivity(
                                      _titleController.text,
                                      _detailController.text,
                                      _locationController.text,
                                      dateInput,
                                      _phoneNumberController.text,
                                      _currentCapacity,
                                      _category)
                                  .then((response) {
                                setState(() => _condition =
                                    response.isSuccessful!.conditionParser());
                                if (response.isSuccessful != true) {
                                  _errorMessage = response.error!;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

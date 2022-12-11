import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/dashboard.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:social/http/api.dart';
import 'package:social/utils/condition.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/helper.dart';
import 'package:social/utils/localization_resources.dart';

class ActivityBuilder extends StatelessWidget {
  const ActivityBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: const Text('Activity Builder'),
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
  final List<String> _categories = ['picnic', 'cinema', 'sport', 'other'];

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

  String _errorMessage = LocalizationResources.somethingWentWrongError;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customeBackground(),
      padding: const EdgeInsets.all(10),
      child: _condition == Condition.success
          ? CustomePopup(
              title: 'Success',
              message: 'You have created activity succesfully!',
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
                  onPressed: () {
                    if (!DiskResources.getBool("isMuteOn")) {
                      Feedback.forTap(context);
                    }
                    setState(() => _condition = Condition.none);
                  })
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
                            hint: Text(LocalizationResources.pickACategory),
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
                            items: _categories
                                .map(
                                  (category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Text(category),
                                        const Spacer(),
                                        Image(
                                          image: Helper.getImageByCategory(
                                              category),
                                          fit: BoxFit.contain,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                .toList()),
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
                              enableFeedback:
                                  !DiskResources.getBool("isMuteOn"),
                            ),
                            child: const Text("Save"),
                            onPressed: () {
                              var pickedDate =
                                  DateTime(year, month, day, hour, minute);
                              var dateInput = DateFormat('yyyy-MM-ddTHH:mm')
                                  .format(pickedDate);

                              if(_category?.isEmpty ?? true){
                                setState(() {
                                  _condition = Condition.fail;
                                  _errorMessage = LocalizationResources
                                      .pleasePickACategory;
                                });
                              }
                              else if(_titleController.text.isEmpty){
                                setState(() {
                                  _condition = Condition.fail;
                                  _errorMessage = LocalizationResources
                                      .pleaseEnterATitle;
                                });
                              } 
                              else if(_detailController.text.isEmpty){
                                setState(() {
                                  _condition = Condition.fail;
                                  _errorMessage = LocalizationResources
                                      .pleaseEnterDetails;
                                });
                              }
                              else if(_locationController.text.isEmpty){
                                setState(() {
                                  _condition = Condition.fail;
                                  _errorMessage = LocalizationResources
                                      .pleaseEnterALocation;
                                });
                              }
                              else if (pickedDate.difference(_now).inHours < 48) {
                                setState(() {
                                  _condition = Condition.fail;
                                  _errorMessage = LocalizationResources
                                      .activityShouldBeCreated48HoursBeforeIt;
                                });
                              } 
                              else if(_phoneNumberController.text.isEmpty || _phoneNumberController.text.length != 14){
                                setState(() {
                                  _condition = Condition.fail;
                                  _errorMessage = LocalizationResources
                                      .pleaseEnterAValidPhoneNumber;
                                });
                              }
                              else {
                                Api()
                                    .createActivity(
                                        _titleController.text,
                                        _detailController.text,
                                        _locationController.text,
                                        dateInput,
                                        _phoneNumberController.text,
                                        _currentCapacity,
                                        _category)
                                    .then(
                                  (response) {
                                    setState(() => _condition = response
                                        .isSuccessful!
                                        .conditionParser());
                                    if (response.isSuccessful != true) {
                                      _errorMessage = response.error!;
                                    }
                                  },
                                );
                              }
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

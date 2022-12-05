import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social/activity_builder.dart';
import 'package:social/activity_detail.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/generic_response.dart';
import 'package:social/login.dart';
import 'package:social/private_profile.dart';
import 'package:social/custome_widgets/custome_searchbar.dart';
import 'package:social/register.dart';
import 'package:social/settings.dart';
import 'package:social/utils/helper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<GenericResponse<List<AllActivityResponse>>> _activities;
  late DateTime _now;
  late DateTime _fromDateFilter;
  late DateTime _toDateFilter;
  late GlobalKey _dropdownKey;

  String? _searchText;
  RangeValues _capacityRange = const RangeValues(2, 100);
  bool _searchBoolean = false;
  bool _showPopupMessage = false;

  // bool _isPicnic = true;
  // bool _isCinema = true;
  // bool _isSport = true;
  // bool _isOther = true;

  // final List<String> _categories = ['picnic', 'cinema', 'sport', 'other'];

  final Map<String, bool> _categories = <String, bool>{
    'picnic': true,
    'cinema': true,
    'sport': true,
    'other': true
  };

  @override
  void initState() {
    super.initState();
    _dropdownKey = GlobalKey();
    _now = DateTime.now();
    _fromDateFilter = _now;
    _toDateFilter = DateTime(_now.year + 2, 1, 1);
    _activities = _getActivities();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: !_searchBoolean
            ? const Text('Activities')
            : CustomeSearchBar(
                onChanged: (String searchText) {
                  setState(() {
                    _searchText = searchText;
                    _activities = _getActivities();
                  });
                },
              ),
        centerTitle: true,
        actions: [
          !_searchBoolean
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                    });
                  })
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = false;
                    });
                  },
                ),
          buildFilterPopup(),
        ],
      ),
      body: _showPopupMessage
          ? AlertDialog(
              backgroundColor: const Color.fromARGB(255, 198, 131, 210),
              title: const Text('Info'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Are you sure to exit?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () => setState(() => _showPopupMessage = false),
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login())),
                )
              ],
            )
          : Container(
              decoration: customeBackground(),
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<GenericResponse<List<AllActivityResponse>>>(
                future: _activities,
                builder: (context, projectSnap) {
                  return projectSnap.connectionState == ConnectionState.done &&
                          projectSnap.data?.isSuccessful == true
                      ? RefreshIndicator(
                          child: ListView.builder(
                            itemCount: projectSnap.data?.response?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Register()),
                                  )
                                },
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      image: DecorationImage(
                                        image: Helper.getImageByCategory(
                                            projectSnap.data!.response![index]
                                                .category!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Text(
                                      projectSnap.data!.response![index].title!,
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 30),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ActivityDetail(
                                              id: projectSnap
                                                  .data!.response![index].id!)),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          onRefresh: () async {
                            setState(() {
                              _activities = _getActivities();
                            });
                          },
                        )
                      : projectSnap.connectionState == ConnectionState.done
                          ? CustomePopup(
                              title: 'Fail',
                              message: projectSnap.data!.error!,
                              buttonName: 'Ok',
                              onPressed: () => setState(
                                () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                },
              ),
            ),
      bottomNavigationBar: buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityBuilder(),
                ),
              )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildFilterPopup() {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      icon: const Icon(Icons.filter_list_outlined),
      itemBuilder: (innerContext) => [
        PopupMenuItem(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: StatefulBuilder(
            builder: (builderContext, innerSetState) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Text('From: '),
                      Text(DateFormat('dd-MM-yyyy').format(_fromDateFilter)),
                      TextButton(
                        child: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: builderContext,
                              initialDate: _fromDateFilter,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            innerSetState(() => _fromDateFilter = pickedDate);
                          }
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('To     : '),
                      Text(DateFormat('dd-MM-yyyy').format(_toDateFilter)),
                      TextButton(
                        child: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: builderContext,
                              initialDate: _toDateFilter,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            innerSetState(() => _toDateFilter = pickedDate);
                          }
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Capacity:'),
                      RangeSlider(
                        values: _capacityRange,
                        max: 100,
                        divisions: 100,
                        labels: RangeLabels(
                          _capacityRange.start.round().toString(),
                          _capacityRange.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          innerSetState(() {
                            _capacityRange = values;
                          });
                        },
                      )
                    ],
                  ),
                  buildCategoryDropdown(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //this enable feedback helps to turn off the sound on click
                            enableFeedback: false,
                          ),
                          child: const Text("Reset"),
                          onPressed: () {
                            innerSetState(() {
                              _capacityRange = const RangeValues(2, 100);
                              _fromDateFilter = _now;
                              _toDateFilter = DateTime(_now.year + 2, 1, 1);
                              _resetCategories();
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(top: 20, right: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //this enable feedback helps to turn off the sound on click
                            enableFeedback: false,
                          ),
                          child: const Text('Search'),
                          onPressed: () {
                            setState(() {
                              _activities = _getActivities();
                              Navigator.pop(context);
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ],
      offset: const Offset(0, 50),
      color: const Color.fromARGB(255, 194, 159, 239),
      elevation: 2,
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomAppBar(
      child: Container(
        decoration: customeBackground(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  }),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Color(0xffE6E6E6),
                  radius: 30,
                  child:
                      Icon(Icons.person, color: Colors.blue //Color(0xffCCCCCC),
                          ),
                ),
                tooltip: 'Go to profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivateProfile()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.only(top: 10, right: 20),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: DropdownButton<String>(
            key: _dropdownKey,
            dropdownColor: const Color.fromARGB(255, 167, 143, 234),
            hint: const Text('Pick a category'),
            isExpanded: true,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {},
            items: _categories.keys.map((categoryKey) {
              return DropdownMenuItem(
                value: categoryKey,
                child: Row(
                  children: [
                    Text(categoryKey),
                    const Spacer(),
                    StatefulBuilder(
                      builder: (builderContext, setDropdownState) {
                        return Checkbox(
                          onChanged: (bool? value) => setDropdownState(
                            () {
                              _categories[categoryKey] =
                                  !(_categories[categoryKey] == true);
                            },
                          ),
                          value: _categories[categoryKey],
                        );
                      },
                    )
                  ],
                ),
              );
            }).toList()
              ..add(
                DropdownMenuItem(
                  value: '',
                  child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(_dropdownKey.currentContext!);
                          });
                        },
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              )),
      ),
    );
  }

  Future<GenericResponse<List<AllActivityResponse>>> _getActivities() {
    return Api().getActivitiesRandomlyByFilter(
        _fromDateFilter,
        _toDateFilter,
        _capacityRange.start.round(),
        _capacityRange.end.round(),
        _searchText,
        _categories.keys.where((key) => _categories[key] == true).toList());
  }

  void _resetCategories() {
    for (var category in _categories.entries) {
      if (category.value == false) {
        _categories[category.key] = true;
      }
    }
  }
}

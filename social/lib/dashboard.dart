import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:social/activity_builder.dart';
import 'package:social/activity_detail.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/generic_response.dart';
import 'package:social/private_profile.dart';
import 'package:social/custome_widgets/custome_searchbar.dart';
import 'package:social/settings.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/helper.dart';
import 'package:social/utils/holder.dart';
import 'package:social/utils/localization_resources.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DateTime _now;
  late DateTime _fromDateFilter;
  late DateTime _toDateFilter;
  late GlobalKey _dropdownKey;

  String? _searchText;
  RangeValues _capacityRange = const RangeValues(2, 100);
  bool _searchBoolean = false;

  bool _isAlertDialogOn = false;
  String _errorMessage = LocalizationResources.somethingWentWrongError;

  final Map<String, bool> _categories = <String, bool>{
    'picnic': true,
    'cinema': true,
    'sport': true,
    'other': true
  };

  Timer? _debounce;

  final PagingController<int, AllActivityResponse> _pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 2);

  @override
  void initState() {
    super.initState();
    _dropdownKey = GlobalKey();
    _now = DateTime.now();
    _fromDateFilter = _now;
    _toDateFilter = DateTime(2030, 1, 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, false);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pagingController.dispose();
    super.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: !_searchBoolean
              ? const Text('Activities')
              : CustomeSearchBar(
                  onChanged: (String searchText) {
                    setState(() {
                      _searchText = searchText;
                    });
                    if (_debounce?.isActive ?? false) {
                      _debounce?.cancel();
                    }
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      _pagingController.refresh();
                    });
                  },
                ),
          centerTitle: true,
          actions: [
            !_searchBoolean
                ? IconButton(
                    enableFeedback: !DiskResources.getBool("isMuteOn"),
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() => _searchBoolean = true);
                    })
                : IconButton(
                    enableFeedback: !DiskResources.getBool("isMuteOn"),
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
                        _searchText = null;
                      });
                    },
                  ),
            buildFilterPopup(),
          ],
        ),
        body: Container(
            decoration: customeBackground(),
            padding: const EdgeInsets.all(10),
            child: _isAlertDialogOn
                ? CustomePopup(
                    title: 'Error',
                    message: _errorMessage,
                    onPressed: () {
                      if (!DiskResources.getBool("isMuteOn")) {
                        Feedback.forTap(context);
                      }
                      setState(() => _isAlertDialogOn = false);
                    },
                  )
                : RefreshIndicator(
                    child: PagedListView<int, AllActivityResponse>(
                      pagingController: _pagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<AllActivityResponse>(
                        itemBuilder: (context, item, index) {
                          return GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                image: DecorationImage(
                                  image:
                                      Helper.getImageByCategory(item.category!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Text(
                                item.title!,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30),
                              ),
                            ),
                            onTap: () {
                              if (!DiskResources.getBool("isMuteOn")) {
                                Feedback.forTap(context);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityDetail(id: item.id!)),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    onRefresh: () async {
                      _pagingController.refresh();
                    },
                  )),
        bottomNavigationBar: buildBottomNavigationBar(),
        floatingActionButton: FloatingActionButton(
            enableFeedback: !DiskResources.getBool("isMuteOn"),
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivityBuilder(),
                  ),
                )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
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
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2030));
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
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2030));
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
                            enableFeedback: !DiskResources.getBool("isMuteOn"),
                          ),
                          child: const Text("Reset"),
                          onPressed: () {
                            innerSetState(() {
                              _capacityRange = const RangeValues(2, 100);
                              _fromDateFilter = _now;
                              _toDateFilter = DateTime(2030, 1, 1);
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
                            enableFeedback: !DiskResources.getBool("isMuteOn"),
                          ),
                          child: const Text('Search'),
                          onPressed: () {
                            Navigator.pop(context);
                            if (_toDateFilter.compareTo(_fromDateFilter) < 0) {
                              setState(() {
                                _isAlertDialogOn = true;
                                _errorMessage = LocalizationResources
                                    .fromDateShouldBeBeforeOrEqualToToDate;
                              });
                            } else {
                              _pagingController.refresh();
                            }
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
                  enableFeedback: !DiskResources.getBool("isMuteOn"),
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
                enableFeedback: !DiskResources.getBool("isMuteOn"),
                icon: const CircleAvatar(
                  backgroundColor: Color(0xffE6E6E6),
                  radius: 30,
                  child:
                      Icon(Icons.person, color: Colors.blue //Color(0xffCCCCCC),
                          ),
                ),
                tooltip: 'Go to profile',
                onPressed: () {
                  if (Holder.userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivateProfile()),
                    );
                  }
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
            hint: Text(LocalizationResources.pickACategory),
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
                              if (!DiskResources.getBool("isMuteOn")) {
                                Feedback.forTap(context);
                              }
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

  Future<GenericResponse<List<AllActivityResponse>>> _getActivities(
      bool isRefresh) {
    // setState() or markNeedsBuild() called during build Error wihout delayed
    Future.delayed(Duration.zero, () {
      if (_searchText?.isEmpty ?? true) {
        setState(() => _searchBoolean = false);
      }
    });

    return Api().getActivitiesByFilterPagination(
        isRefresh,
        _fromDateFilter,
        _toDateFilter,
        _capacityRange.start.round(),
        _capacityRange.end.round(),
        _searchText,
        _categories.keys.where((key) => _categories[key] == true).toList());
  }

  Future<void> _fetchPage(int pageKey, bool isRefresh) async {
    try {
      if (isRefresh) {
        _pagingController.itemList = null;
      }
      var response = await _getActivities(isRefresh);
      if (response.isSuccessful == true) {
        var isLastPage = (response.response?.length ?? 0) < 10;
        if (isLastPage) {
          _pagingController.appendLastPage(response.response!);
        } else {
          _pagingController.appendPage(
              response.response!, pageKey + (response.response?.length ?? 0));
        }
      } else {
        _pagingController.error = response.error ?? 'Something went wrong';
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _resetCategories() {
    for (var category in _categories.entries) {
      if (category.value == false) {
        _categories[category.key] = true;
      }
    }
  }
}

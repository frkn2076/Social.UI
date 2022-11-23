import 'package:flutter/material.dart';
import 'package:social/activity_builder.dart';
import 'package:social/activity_detail.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/private_profile.dart';
import 'package:social/custome_widgets/custome_searchbar.dart';
import 'package:social/register.dart';

class PublicActivity extends StatefulWidget {
  const PublicActivity({Key? key}) : super(key: key);

  @override
  State<PublicActivity> createState() => _PublicActivityState();
}

class _PublicActivityState extends State<PublicActivity> {
  late Future<List<AllActivityResponse>> _activities;
  String? _searchText;

  @override
  void initState() {
    super.initState();
    _activities = Api().getActivitiesRandomly();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: !_searchBoolean
            ? const Text('Activities')
            : CustomeSearchBar(
                onChanged: (String searchText) {
                  setState(() {
                    _searchText = searchText;
                    if (searchText.isNotEmpty) {
                      _activities =
                          Api().getActivitiesRandomlyByKey(searchText);
                    } else {
                      _activities = Api().getActivitiesRandomly();
                    }
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<AllActivityResponse>>(
          future: _activities,
          builder: (context, projectSnap) {
            return projectSnap.connectionState == ConnectionState.done
                ? RefreshIndicator(
                    child: ListView.builder(
                      itemCount: projectSnap.data?.length,
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
                                border: Border.all(color: Colors.blueAccent),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/ada.jpeg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Text(
                                projectSnap.data![index].title!,
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
                                        id: projectSnap.data![index].id!)),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    onRefresh: () async {
                      setState(() {
                        if (_searchText != null && _searchText!.isNotEmpty) {
                          _activities =
                              Api().getActivitiesRandomlyByKey(_searchText!);
                        } else {
                          _activities = Api().getActivitiesRandomly();
                        }
                      });
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.blue),
                  onPressed: () {}),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: IconButton(
                // do not remove below comments
                // icon: const CircleAvatar(
                //   radius: 20,
                //   backgroundImage: AssetImage('assets/images/foto1.jpeg'),
                // ),
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
}

import 'package:flutter/material.dart';
import 'package:social/activity_detail.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/private_profile.dart';

import 'register.dart';

class PublicActivity extends StatelessWidget {
  const PublicActivity({Key? key}) : super(key: key);

  static const String _title = 'Activities';

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
        title: const Text(_title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/foto1.jpeg'),
            ),
            tooltip: 'Go to profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivateProfile()),
              );
            },
          ),
        ],
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
  late Future<List<AllActivityResponse>> _activities;

  @override
  void initState() {
    super.initState();
    _activities = Api().getActivitiesRandomly();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      _activities = Api().getActivitiesRandomly();
                    });
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

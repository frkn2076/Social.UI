import 'package:flutter/material.dart';
import 'package:social/activity.dart';
import 'package:social/http/api.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/profile.dart';

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
                MaterialPageRoute(builder: (context) => const Profile(id: 1)),
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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var activities = Api().getAllActivities(true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<AllActivityResponse>>(
        future: Api().getAllActivities(true),
        builder: (context, projectSnap) {
          return projectSnap.connectionState == ConnectionState.done
              ? ListView.builder(
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
                                builder: (context) => Activity(id: projectSnap.data![index].id!)),
                          );
                        },
                      ),
                    );
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

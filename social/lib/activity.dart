import 'package:flutter/material.dart';
import 'package:social/http/models/activity_detail_response.dart';
import 'package:social/private_profile.dart';
import 'package:social/profile.dart';

import 'http/api.dart';

class Activity extends StatelessWidget {
  final int id;
  const Activity({Key? key, required this.id}) : super(key: key);

  static const String _title = 'Social';

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
      body: MyStatefulWidget(id: id),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final int id;
  const MyStatefulWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<ActivityDetailResponse?>(
        future: Api().getActivityDetail(widget.id),
        builder: (context, projectSnap) {
          return projectSnap.connectionState == ConnectionState.done
              ? ListView(
                  children: <Widget>[
                    Container(
                      height: 120,
                      width: 100,
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
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15.0),
                      child: Text(
                        projectSnap.data!.title!,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(15.0),
                      child: Text(
                        projectSnap.data!.detail!,
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 300,
                      width: 100,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: projectSnap.data!.joiners!.map((joiner) {
                          bool isPrivate =
                              joiner.id! == projectSnap.data!.userId!;
                          return GestureDetector(
                              onTap: () => {
                                    if (isPrivate)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PrivateProfile(
                                                      id: joiner.id!)),
                                        )
                                      }
                                    else
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile(id: joiner.id!)),
                                        )
                                      }
                                  },
                              child: isPrivate
                                  ? Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(1),
                                      child: Text(
                                        joiner.userName!,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(1),
                                      child: Text(
                                        joiner.userName!,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                    ));
                        }).toList(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: ElevatedButton(
                        child: const Text(
                          "Join",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        onPressed: () => {
                          Api().joinActivity(widget.id).then(
                                (isSuccess) => setState(
                                  () {},
                                ),
                              )
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

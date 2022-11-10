import 'package:flutter/material.dart';
import 'package:social/http/models/private_profile.dart';

import 'http/api.dart';

class Profile extends StatelessWidget {
  final int id;
  const Profile({Key? key, required this.id}) : super(key: key);

  static const String _title = 'Profile';

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
    return FutureBuilder<PrivateProfileResponse?>(
      future: Api().getProfileById(widget.id),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          return ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(100.0, 80.0, 100.0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Image(
                  image: AssetImage('assets/images/foto1.jpeg'),
                  height: 150,
                  width: 150,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
                child: const Text(
                  "User:",
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
                child: Text(projectSnap.data?.name ?? ""),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0),
                child: const Text(
                  "About me:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Text(projectSnap.data?.about ?? ""),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

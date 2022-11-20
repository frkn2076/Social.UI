import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social/http/models/private_profile.dart';
import 'package:social/owner_activity.dart';
import 'package:social/joined_activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/utils/helper.dart';

import 'http/api.dart';

class PrivateProfile extends StatelessWidget {
  const PrivateProfile({Key? key}) : super(key: key);

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
        actions: [
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {
                if (Api.profileId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinedActivity(id: Api.profileId!),
                    ),
                  );
                }
              },
              child: const Text(
                "Joined Ones",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () {
                if (Api.profileId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnerActivity(id: Api.profileId!),
                    ),
                  );
                }
              },
              child: const Text(
                "Created Ones",
              ),
            ),
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
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _photoController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrivateProfileResponse?>(
      future: Api().getPrivateProfile(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          _nameController.text = projectSnap.data?.name ?? "Your name...";
          _aboutController.text =
              projectSnap.data?.about ?? "Tell me about yourself...";

          return ListView(
            children: <Widget>[
              Stack(
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
                  Positioned(
                    right: 100.0,
                    bottom: 0.0,
                    child: GestureDetector(
                      child: Icon(
                        size: 40,
                        Icons.add_circle_outline,
                        color: Colors.blue,
                      ),
                      onTap: () async {
                        var pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                      },
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(50),
                child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name & Surname',
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _aboutController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'About me',
                  ),
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
                      child: TextButton(
                        child: const Text("Save"),
                        onPressed: () => {
                          Api()
                              .updatePrivateProfile(null, _nameController.text,
                                  _aboutController.text)
                              .then(
                                (isSuccess) => setState(
                                  () {},
                                ),
                              )
                        },
                      ),
                    ),
                  ],
                ),
              )
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

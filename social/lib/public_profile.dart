import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_focused_textfield.dart';
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/owner_activity.dart';
import 'package:social/joined_activity.dart';
import 'package:social/http/api.dart';

class PublicProfile extends StatelessWidget {
  final int id;
  const PublicProfile({Key? key, required this.id}) : super(key: key);

  static const String _title = 'Profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: const Text(_title),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.nordic_walking_outlined),
              tooltip: 'Joined Ones',
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
            ),
          ),
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.supervised_user_circle_outlined),
              tooltip: "Created Ones",
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
            ),
          ),
        ],
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
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: const Image(
                      image: AssetImage('assets/images/foto1.jpeg'),
                    ),
                  ),
                  Positioned(
                    right: 100.0,
                    bottom: 0.0,
                    child: IconButton(
                      // ignore: prefer_const_constructors
                      icon: Icon(
                        size: 40,
                        Icons.add_circle_outline,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        var pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              CustomeFocusedTextField(
                padding: const EdgeInsets.fromLTRB(20, 50, 150, 0),
                readOnly: true,
                labelText: 'Name & Surname',
                controller: TextEditingController(text: projectSnap.data?.name),
              ),
              CustomeFocusedTextField(
                readOnly: true,
                labelText: 'About',
                controller: TextEditingController(text: projectSnap.data?.about),
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

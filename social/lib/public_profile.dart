import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_focused_textfield.dart';
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/owner_activity.dart';
import 'package:social/joined_activity.dart';
import 'package:social/http/api.dart';
import 'package:social/utils/helper.dart';
import 'package:social/utils/holder.dart';

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
                if (Holder.userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinedActivity(id: id),
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
                if (Holder.userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OwnerActivity(id: id),
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
  Image? _image;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrivateProfileResponse?>(
      future: Api().getProfileById(widget.id),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done) {
          if (projectSnap.data?.photo?.isNotEmpty ?? false) {
            _image = Helper.imageFromBase64String(projectSnap.data!.photo!);
          }
          return Container(
            decoration: customeBackground(),
            child: ListView(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: _image ??
                          const Image(
                            fit: BoxFit.contain,
                            image:
                                AssetImage('assets/images/empty_profile.jpg'),
                          ),
                    ),
                  ],
                ),
                CustomeFocusedTextField(
                  padding: const EdgeInsets.fromLTRB(20, 50, 150, 0),
                  readOnly: true,
                  labelText: 'Name & Surname',
                  controller:
                      TextEditingController(text: projectSnap.data?.name),
                ),
                CustomeFocusedTextField(
                  readOnly: true,
                  labelText: 'About',
                  controller:
                      TextEditingController(text: projectSnap.data?.about),
                )
              ],
            ),
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

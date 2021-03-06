import 'package:flutter/material.dart';
import 'package:social/private_activity.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivateActivity(),
                  ),
                );
              },
              child: const Text(
                "My Activities",
              ),
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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          child: const Text("Furkan ??zt??rk"),
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
          child: const Text("About yourself..."),
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'http/api.dart';

class ActivityBuilder extends StatelessWidget {
  const ActivityBuilder({Key? key}) : super(key: key);

  static const String _title = 'Activity Builder';

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
            child: const Text(
              "Title:",
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
            child: TextField(controller: _titleController),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
            child: const Text(
              "Detail:",
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
            child: TextField(controller: _detailController),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
            child: const Text(
              "Location:",
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
            child: TextField(controller: _locationController),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
            child: const Text(
              "Date:",
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
            child: TextField(controller: _dateController),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0),
            child: const Text(
              "Phone Number:",
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
            child: TextField(controller: _phoneNumberController),
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
                      Api().createActivity(_titleController.text,
                       _detailController.text,
                       _locationController.text,
                       _dateController.text,
                       _phoneNumberController.text).then(
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
      ),
    );
  }
}

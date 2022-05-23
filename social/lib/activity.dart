import 'package:flutter/material.dart';

class Activity extends StatelessWidget {
  final int id;
  const Activity({Key? key, required this.id}) : super(key: key);

  static const String _title = 'Sample App';

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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(15.0),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Text(
            'Etkinlik ${widget.id} \nDetaylar... \n ...' +
                '\n Katılımcılar: \n Furkan \n Tuba \n Öztürk',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 30),
          ),
        ),
      ]),
    );
  }
}

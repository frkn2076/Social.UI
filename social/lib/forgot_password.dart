import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_backbutton.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/utils/holder.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  static const String _title = 'Forgot Password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomeBackButton(),
        title: const Text(_title),
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
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customeBackground(),
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 100, 10, 20),
            child: Text(
              'Forgot Password',
              style: TextStyle(fontSize: Holder.titleFontSize),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            height: Holder.buttonHeight,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                //this enable feedback helps to turn off the sound on click
                enableFeedback: false,
              ),
              child: const Text('Send email for password'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

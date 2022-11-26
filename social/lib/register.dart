import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/http/api.dart';
import 'package:social/login.dart';
import 'package:social/public_activity.dart';
import 'package:social/utils/holder.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/utils/condition.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);
  static const String _title = 'Social';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _title,
            style: TextStyle(fontSize: Holder.pageFontSize),
          ),
          centerTitle: true,
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController userNameController =
      TextEditingController(text: Holder.userName);
  TextEditingController passwordController =
      TextEditingController(text: Holder.password);
  var _condition = Condition.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customeBackground(),
      padding: const EdgeInsets.all(10),
      child: _condition == Condition.success
          ? CustomePopup(
              title: 'Success',
              message: 'You have registered succesfully',
              buttonName: 'Ok',
              onPressed: () => setState(() => _condition = Condition.none))
          : _condition == Condition.fail
              ? CustomePopup(
                  title: 'Fail',
                  message: 'Something went wrong',
                  buttonName: 'Close',
                  onPressed: () => setState(() => _condition = Condition.none))
              : ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 100, 10, 20),
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: Holder.titleFontSize),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: userNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                      height: Holder.buttonHeight,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Sign in'),
                        onPressed: () {
                          var response = Api().register(
                              userNameController.text, passwordController.text);
                          response.then(
                            (isSuccess) {
                              setState(
                                () {
                                  if (isSuccess) {
                                    _condition = Condition.none;
                                    Holder.userName = userNameController.text;
                                    Holder.password = passwordController.text;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PublicActivity()),
                                    );
                                  } else {
                                    _condition = Condition.fail;
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Have account?'),
                        TextButton(
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: Holder.titleFontSize),
                          ),
                          onPressed: () {
                            Holder.userName = userNameController.text;
                            Holder.password = passwordController.text;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
    );
  }
}

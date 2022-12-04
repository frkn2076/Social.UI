import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/forgot_password.dart';
import 'package:social/utils/holder.dart';
import 'package:social/http/api.dart';
import 'dashboard.dart';
import 'package:social/register.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const String _title = 'Social';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  bool _isAlertDialogOn = false;
  String _errorMessage = "Something went wrong";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customeBackground(),
      padding: const EdgeInsets.all(10),
      child: _isAlertDialogOn
          ? CustomePopup(
              title: 'Wrong credentials',
              message: _errorMessage,
              buttonName: 'Close',
              onPressed: () => setState(() => _isAlertDialogOn = false))
          : ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 100, 10, 20),
                  child: Text(
                    'Login',
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password',
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
                    child: const Text('Login'),
                    onPressed: () {
                      Api()
                          .login(
                              userNameController.text, passwordController.text)
                          .then(
                        (response) {
                          setState(
                            () {
                              if (response.isSuccessful == true) {
                                _isAlertDialogOn = false;
                                Holder.userName = userNameController.text;
                                Holder.password = passwordController.text;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dashboard()),
                                );
                              } else {
                                _isAlertDialogOn = true;
                                _errorMessage = response.error!;
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
                    const Text('Does not have account?'),
                    TextButton(
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: Holder.titleFontSize),
                      ),
                      onPressed: () {
                        Holder.userName = userNameController.text;
                        Holder.password = passwordController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
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

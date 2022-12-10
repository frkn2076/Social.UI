import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/http/api.dart';
import 'package:social/login.dart';
import 'package:social/dashboard.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/holder.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/utils/localization_resources.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
        centerTitle: true,
      ),
      body: const RegisterStatefulWidget(),
    );
  }
}

class RegisterStatefulWidget extends StatefulWidget {
  const RegisterStatefulWidget({Key? key}) : super(key: key);

  @override
  State<RegisterStatefulWidget> createState() => _RegisterStatefulWidgetState();
}

class _RegisterStatefulWidgetState extends State<RegisterStatefulWidget> {
  TextEditingController userNameController =
      TextEditingController(text: Holder.userName);
  TextEditingController passwordController =
      TextEditingController(text: Holder.password);
  bool _isPopup = false;
  String _errorMessage = LocalizationResources.somethingWentWrongError;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Container(
        decoration: customeBackground(),
        padding: const EdgeInsets.all(10),
        child: _isPopup
            ? CustomePopup(
                title: 'Fail',
                message: _errorMessage,
                onPressed: () {
                  if (!DiskResources.getBool("isMuteOn")) {
                    Feedback.forTap(context);
                  }
                  setState(() => _isPopup = false);
                },
              )
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
                        labelText: 'UserName',
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
                      style: ElevatedButton.styleFrom(
                        enableFeedback: !DiskResources.getBool("isMuteOn"),
                      ),
                      child: const Text('Sign in'),
                      onPressed: () {
                        Api()
                            .register(userNameController.text,
                                passwordController.text)
                            .then(
                          (response) {
                            setState(
                              () {
                                if (response.isSuccessful!) {
                                  _isPopup = false;
                                  Holder.userName = userNameController.text;
                                  Holder.password = passwordController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Dashboard()),
                                  );
                                } else {
                                  _isPopup = true;
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
                      const Text('Have an account?'),
                      TextButton(
                        child: const Text('Login'),
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
      ),
    );
  }
}

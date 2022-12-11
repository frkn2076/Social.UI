import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/forgot_password.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/holder.dart';
import 'package:social/http/api.dart';
import 'package:social/utils/localization_resources.dart';
import 'dashboard.dart';
import 'package:social/register.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
        centerTitle: true,
      ),
      body: const LoginStatefulWidget(),
    );
  }
}

class LoginStatefulWidget extends StatefulWidget {
  const LoginStatefulWidget({Key? key}) : super(key: key);

  @override
  State<LoginStatefulWidget> createState() => _LoginStatefulWidgetState();
}

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  final TextEditingController _userNameController =
      TextEditingController(text: Holder.userName);
  final TextEditingController _passwordController =
      TextEditingController(text: Holder.password);
  bool _isAlertDialogOn = false;
  String _errorMessage = LocalizationResources.somethingWentWrongError;

  bool _isPasswordVisible = true;

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
        child: _isAlertDialogOn
            ? CustomePopup(
                title: LocalizationResources.wrongCredentials,
                message: _errorMessage,
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
                      maxLength: 15,
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                        labelText: 'UserName',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      maxLength: 15,
                      obscureText: _isPasswordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        counterText: '',
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () => setState(() =>
                                _isPasswordVisible = !_isPasswordVisible)),
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
                    child: const Text('Forgot Password'),
                  ),
                  Container(
                    height: Holder.buttonHeight,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        enableFeedback: !DiskResources.getBool("isMuteOn"),
                      ),
                      child: const Text('Login'),
                      onPressed: () {
                        Api()
                            .login(_userNameController.text,
                                _passwordController.text)
                            .then(
                          (response) {
                            setState(
                              () {
                                if (response.isSuccessful == true) {
                                  _isAlertDialogOn = false;
                                  Holder.userName = _userNameController.text;
                                  Holder.password = _passwordController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Dashboard()),
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
                      Text(LocalizationResources.deosntHaveAnAccount),
                      TextButton(
                        child: const Text('Sign in'),
                        onPressed: () {
                          Holder.userName = _userNameController.text;
                          Holder.password = _passwordController.text;
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
      ),
    );
  }
}

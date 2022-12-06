import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/forgot_password.dart';
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
        title: Text(
          'Social',
          style: TextStyle(fontSize: Holder.pageFontSize),
        ),
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
  TextEditingController userNameController =
      TextEditingController(text: Holder.userName);
  TextEditingController passwordController =
      TextEditingController(text: Holder.password);
  bool _isAlertDialogOn = false;
  String _errorMessage = LocalizationResources.somethingWentWrongError;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    controller: userNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'UserName',
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
                    Text(LocalizationResources.deosntHaveAnAccount),
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

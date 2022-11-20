import 'package:flutter/material.dart';
import 'package:social/custome_widgets/custome_popup.dart';
import 'package:social/forgot_password.dart';
import 'package:social/utils/holder.dart';
import 'package:social/http/api.dart';
import 'public_activity.dart';
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
          title: const Text(
            _title,
            style: TextStyle(fontSize: 30),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _isAlertDialogOn
          ? CustomePopup(
              title: 'Wrong credentials',
              message: 'Your username or password is wrong',
              buttonName: 'Close',
              onPressed: () => setState(() => _isAlertDialogOn = false))
          : ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(height: 20),
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
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      var response = Api().login(
                          userNameController.text, passwordController.text);
                      response.then(
                        (isSuccess) {
                          setState(() {
                            if (isSuccess) {
                              _isAlertDialogOn = false;
                              Holder.userName = userNameController.text;
                              Holder.password = passwordController.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PublicActivity()),
                              );
                            } else {
                              setState(() {
                                _isAlertDialogOn = true;
                              });
                            }
                          });
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
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
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

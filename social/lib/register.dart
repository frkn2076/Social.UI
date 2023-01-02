import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/custome_widgets/custome_background.dart';
import 'package:social/http/api.dart';
import 'package:social/login.dart';
import 'package:social/dashboard.dart';
import 'package:social/utils/condition.dart';
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
  final TextEditingController _userNameController =
      TextEditingController(text: Holder.userName);
  final TextEditingController _passwordController =
      TextEditingController(text: Holder.password);

  var _condition = Condition.none;
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
        child: _condition == Condition.success
            ? CustomePopup(
                title: LocalizationResources.success,
                message:
                    LocalizationResources.youHaveCreatedAccountSuccessfully,
                buttonName: LocalizationResources.ok,
                onPressed: () {
                  setState(() => _condition = Condition.none);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                })
            : _condition == Condition.fail
                ? CustomePopup(
                    title: LocalizationResources.fail,
                    message: _errorMessage,
                    buttonName: LocalizationResources.ok,
                    onPressed: () {
                      setState(() => _condition = Condition.none);
                    })
                : ListView(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(10, 100, 10, 20),
                        child: Text(
                          LocalizationResources.signIn,
                          style: TextStyle(fontSize: Holder.titleFontSize),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          maxLength: 15,
                          controller: _userNameController,
                          decoration: InputDecoration(
                            counterText: '',
                            border: const OutlineInputBorder(),
                            labelText: LocalizationResources.userName,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                        child: TextField(
                          maxLength: 15,
                          obscureText: _isPasswordVisible,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            counterText: '',
                            border: const OutlineInputBorder(),
                            labelText: LocalizationResources.password,
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
                      Container(
                        height: Holder.buttonHeight,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            enableFeedback: !DiskResources.getBool("isMuteOn"),
                          ),
                          child: Text(LocalizationResources.signIn),
                          onPressed: () {
                            if (_userNameController.text.length < 5) {
                              setState(() {
                                _condition = Condition.fail;
                                _errorMessage = LocalizationResources
                                    .userNameLengthShouldBe5OrGreater;
                              });
                            } else if (_passwordController.text.length < 5) {
                              setState(() {
                                _condition = Condition.fail;
                                _errorMessage = LocalizationResources
                                    .passwordLengthShouldBe5OrGreater;
                              });
                            } else {
                              Api()
                                  .register(_userNameController.text,
                                      _passwordController.text)
                                  .then(
                                (response) {
                                  setState(
                                    () {
                                      _condition = response.isSuccessful
                                          .conditionParser();
                                      if (response.isSuccessful == true) {
                                        Holder.userName =
                                            _userNameController.text;
                                        Holder.password =
                                            _passwordController.text;
                                      } else {
                                        _errorMessage = response.error;
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(LocalizationResources.haveAnAccount),
                          TextButton(
                            child: Text(LocalizationResources.login),
                            onPressed: () {
                              Holder.userName = _userNameController.text;
                              Holder.password = _passwordController.text;
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

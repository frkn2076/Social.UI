import 'package:flutter/material.dart';
import 'package:social/http/api.dart';
import 'package:social/public_activity.dart';

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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var condition = _condition.none;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: condition == _condition.success
          ? AlertDialog(
              title: const Text('Success'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('You have registered succesfully')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    setState(() {
                      condition = _condition.none;
                    });
                  },
                ),
              ],
            )
          : condition == _condition.fail
              ? AlertDialog(
                  title: const Text('Fail'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[Text('Something went wrong')],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        setState(() {
                          condition = _condition.none;
                        });
                      },
                    ),
                  ],
                )
              : ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
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
                    Container(height: 40),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Sign in'),
                        onPressed: () {
                          var response = Api().register(
                              emailController.text, passwordController.text);
                          response.then(
                            (isSuccess) {
                              setState(() {
                                if (isSuccess) {
                                  condition = _condition.success;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const PublicActivity()),
                                  );
                                } else {
                                  condition = _condition.fail;
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
                        const Text('Have account?'),
                        TextButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
    );
  }
}

enum _condition { none, success, fail }

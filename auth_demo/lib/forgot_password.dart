import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _instructions = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new Text(
            'Reset Password',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        new Text(
          '''Enter your email address then press "Submit".''',
        ),
      ],
    );

    Widget _signUpForm() {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 15.0),
            child: new TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
          ),
          new RaisedButton(
            child: new Text('Submit'),
            onPressed: () {
              /*_handleCreateUserWithEmailAndPassword()
              .then((FirebaseUser user) => _sendEmailVerification(user))
              .catchError((e) => _handleExceptions(e));*/
            },
          ),
        ],
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Auth Demo Forgot Password'),
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
        child: new ListView(
          children: <Widget>[
            _instructions,
            _signUpForm(),
          ],
        ),
      ),
    );
  }
}

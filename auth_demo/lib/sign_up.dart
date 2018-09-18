import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SignUpState();
}

class SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<FirebaseUser> _handleCreateUserWithEmailAndPassword() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    return user;
  }

  @override
  Widget build(BuildContext context) {
    Widget _signUpForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 15.0),
          child: new Column(
            children: <Widget>[
              new TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              new TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Choose a password',
                ),
                obscureText: true,
              ),
              new TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Confirm password',
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        new RaisedButton(
          child: new Text('Submit'),
          onPressed: () {
            _handleCreateUserWithEmailAndPassword()
                .then((FirebaseUser user) => print(user))//_handleValidSignIn(user))
                .catchError((e) => print(e));
          },
        ),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Auth Demo Sign Up'),
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(32.0, 25.0, 32.0, 32.0),
        child: new ListView(
          children: <Widget>[
            new Text(
              'Create new account:',
              style: Theme.of(context).textTheme.title,
            ),
            _signUpForm,
          ],
        ),
      ),
    );
  }
}

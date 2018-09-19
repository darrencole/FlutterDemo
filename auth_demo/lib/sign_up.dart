import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:auth_demo/custom_widgets.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SignUpState();
}

class SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _showVerificationMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
    _showVerificationMessage = false;
  }

  bool _validationPassed(
      String email, String password, String confirmPassword) {
    setState(() {
      _errorMessage = '';
      if (email == null || email == '') {
        _errorMessage = 'Email required. ';
      }
      if (password == null || password == '') {
        _errorMessage = '${_errorMessage}Password required. ';
      }
      if (confirmPassword == null || confirmPassword == '') {
        _errorMessage = '${_errorMessage}Password confirmation required.';
      }
      if (_errorMessage == '' && password != confirmPassword) {
        _errorMessage = 'Password and Confirmed Password do not match.';
      }
    });

    return _errorMessage == '';
  }

  void _handleExceptions(Exception e) {
    final List<String> message = e.toString().split(',');
    setState(() {
      _errorMessage = message[1].substring(1);
    });
    print(e);
  }

  Future<FirebaseUser> _handleCreateUserWithEmailAndPassword() async {
    FirebaseUser user;
    if (_validationPassed(
      _emailController.text,
      _passwordController.text,
      _confirmPasswordController.text,
    )) {
      user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }

    return user;
  }

  void _sendEmailVerification(FirebaseUser user) async {
    print(user);
    user.sendEmailVerification();
    setState(() {
      _showVerificationMessage = true;
    });
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Widget _signUpForm() {
      if (_showVerificationMessage) {
        return new Text('');
      } else {
        return new Column(
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
                    .then((FirebaseUser user) => _sendEmailVerification(user))
                    .catchError((e) => _handleExceptions(e));
              },
            ),
          ],
        );
      }
    }

    Widget _verificationMessage() {
      if (_showVerificationMessage) {
        return VerificationMessage(
          message:
              '''An email was sent to your email address. Open the email and click on the link provided to complete the sign-up process.''',
        );
      } else {
        return new Text('');
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Auth Demo Sign Up'),
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
        child: new ListView(
          children: <Widget>[
            new ErrorMessageSection(
              errorMessage: _errorMessage,
            ),
            new Subtitle(
              text: 'Create new account:',
            ),
            _signUpForm(),
            _verificationMessage(),
          ],
        ),
      ),
    );
  }
}

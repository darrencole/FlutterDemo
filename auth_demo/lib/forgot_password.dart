import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage;
  TextEditingController _emailController = TextEditingController();
  bool _showVerificationMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
    _showVerificationMessage = false;
  }

  Future<void> _handlePasswordReset() async {
    await _auth.sendPasswordResetEmail(email: _emailController.text);
  }

  void _handleInvalidEmail(Exception e) {
    setState(() {
      _errorMessage = 'Invalid email entered.';
    });
    print(e);
  }

  void _handleValidReset() {
    setState(() {
      _showVerificationMessage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _subtitle = new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
      child: new Text(
        'Reset Password',
        style: Theme.of(context).textTheme.title,
      ),
    );

    Widget _resetPasswordForm() {
      if (_showVerificationMessage) {
        return new Text('');
      } else {
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: new Text(
                '''Enter your email address then press "Submit".''',
              ),
            ),
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
                _handlePasswordReset()
                    .then((blank) => _handleValidReset())
                    .catchError((e) => _handleInvalidEmail(e));
              },
            ),
          ],
        );
      }
    }

    Widget _verificationMessage() {
      if (_showVerificationMessage) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 15.0),
              child: new Text(
                '''An email was sent to your email address. Open the email and follow the instructions to reset your password.''',
                style: new TextStyle(
                  color: Colors.green,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
            ),
            new RaisedButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      } else {
        return new Text('');
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Auth Demo Forgot Password'),
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
        child: new ListView(
          children: <Widget>[
            _subtitle,
            _resetPasswordForm(),
            _verificationMessage(),
          ],
        ),
      ),
    );
  }
}

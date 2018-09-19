import 'package:flutter/material.dart';

class ErrorMessageSection extends StatelessWidget {
  ErrorMessageSection({this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return new Text(
      errorMessage,
      style: new TextStyle(
        color: Colors.red,
        fontSize: 15.0,
      ),
      softWrap: true,
    );
  }
}

class Subtitle extends StatelessWidget {
  Subtitle({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
      child: new Text(
        text,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}

class VerificationMessage extends StatelessWidget {
  VerificationMessage({this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 15.0),
          child: new Text(
            message, //'''An email was sent to your email address. Open the email and follow the instructions to reset your password.''',
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
  }
}

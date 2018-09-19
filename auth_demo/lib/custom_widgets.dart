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
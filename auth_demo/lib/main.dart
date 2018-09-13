import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Auth Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Auth Demo Sign In'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _displayName;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future _setDisplayName() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      if (currentUser != null) {
        _displayName = '${currentUser.displayName}';
      } else {
        _displayName = 'Not logged in';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setDisplayName();
  }

  Future<FirebaseUser> _handleCreateUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _setDisplayName();

    return user;
  }

  Future<FirebaseUser> _handleSignInWithEmailAndPassword() async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    _setDisplayName();

    return user;
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    await _googleSignIn.disconnect();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    _setDisplayName();

    return user;
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    _setDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Welcome',
              style: Theme.of(context).textTheme.display1,
            ),
            new Text(
              _displayName,
              style: Theme.of(context).textTheme.display1,
            ),
            new TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            new TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            new RaisedButton(
              child: new Text('Sign in'),
              onPressed: () {
                _handleSignInWithEmailAndPassword()
                    .then((FirebaseUser user) => print(user))
                    .catchError((e) => print(e));
              },
            ),
            new RaisedButton(
              child: new Text('Sign in with Google'),
              onPressed: () {
                _handleGoogleSignIn()
                    .then((FirebaseUser user) => print(user))
                    .catchError((e) => print(e));
              },
            ),
            new RaisedButton(
              child: new Text('Sign out'),
              onPressed: () => _signOut(),
            ),
          ],
        ),
      ),
    );
  }
}

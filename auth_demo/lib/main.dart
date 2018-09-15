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
  String errorMessage = '';
  String _screenName;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future _setScreenName() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    setState(() {
      if (currentUser != null) {
        _screenName = '${currentUser.email}';
      } else {
        _screenName = 'Not logged in';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setScreenName();
  }

  Future<FirebaseUser> _handleCreateUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _setScreenName();

    return user;
  }

  bool _validationPassed(String email, String password) {
    setState(() {
      errorMessage = '';
      if (email == null || email == '') {
        errorMessage = 'Email required. ';
      }
      if (password == null || password == '') {
        errorMessage = '${errorMessage}Password required.';
      }
    });

    return errorMessage == '';
  }

  void _handleInvalidCredentials(Exception e) {
    setState(() {
      errorMessage = 'Invalid email or password entered.';
    });
    print(e);
  }

  void _handleValidSignIn(FirebaseUser user) {
    print(user);
  }

  Future<FirebaseUser> _handleSignInWithEmailAndPassword() async {
    FirebaseUser user;
    if (_validationPassed(
      _emailController.text,
      _passwordController.text,
    )) {
      user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _setScreenName();
    }

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
    _setScreenName();

    return user;
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    _setScreenName();
  }

  @override
  Widget build(BuildContext context) {
    Widget _errorMessageSection = new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
      child: new Text(
        errorMessage,
        style: new TextStyle(
          color: Colors.red,
          fontSize: 15.0,
        ),
        softWrap: true,
      ),
    );

    Widget _welcomeSection = new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
            child: new Text(
              'Welcome',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          new Text(
            _screenName,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );

    Widget _signInForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
            hintText: 'Password',
          ),
          obscureText: true,
        ),
        new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 15.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new InkWell(
                child: new Text(
                  'Forgot your password?',
                  style: new TextStyle(
                    color: Colors.orange,
                    fontSize: 15.0,
                  ),
                  softWrap: true,
                ),
                onTap: () {}, //IMPLEMENT FORGOT PASSWORD!!!
              ),
              new RaisedButton(
                child: new Text('Sign in'),
                onPressed: () {
                  _handleSignInWithEmailAndPassword()
                      .then((FirebaseUser user) => _handleValidSignIn(user))
                      .catchError((e) => _handleInvalidCredentials(e));
                },
              ),
            ],
          ),
        ),
        new RaisedButton(
          child: new Text('Sign in with Google'),
          onPressed: () {
            _handleGoogleSignIn()
                .then((FirebaseUser user) => _handleValidSignIn(user))
                .catchError((e) => print(e));
          },
        ),
      ],
    );

    Widget _signUpSection = new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Don't have an account? ",
            style: new TextStyle(
              color: Colors.blueAccent,
              fontSize: 15.0,
            ),
            softWrap: true,
          ),
          new InkWell(
            child: new Text(
              'Sign up!',
              style: new TextStyle(
                color: Colors.blueAccent,
                fontSize: 15.0,
                decoration: TextDecoration.underline,
              ),
              softWrap: true,
            ),
            onTap: () {}, //IMPLEMENT SIGN UP!!!
          ),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
        child: new ListView(
          children: <Widget>[
            _errorMessageSection,
            _welcomeSection,
            _signInForm,
            _signUpSection,
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

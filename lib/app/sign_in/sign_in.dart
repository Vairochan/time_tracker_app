import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker/app/sign_in/sign_in_with_email.dart';
import 'package:time_tracker/app/sign_in/social_button.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/servises/auth.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignIn(
              manager: manager, isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) {
          return EmailSignInPage();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: Text("TIme Tracker"),
        centerTitle: true,
      ),
      body: _buildContainer(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Container(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildHeader(),
              SizedBox(
                height: 40,
              ),
              SocialSignInButton(
                text: "Sign in with Google",
                textColor: Colors.black,
                color: Colors.white,
                onPressed: isLoading ? null : () => _signInWithGoogle(context),
                assetName: "images/google-logo.png",
              ),
              SizedBox(
                height: 15,
              ),
              SocialSignInButton(
                text: "Sign in with Facebook",
                textColor: Colors.white,
                color: Colors.indigo,
                assetName: "images/facebook-logo.png",
                onPressed:
                    isLoading ? null : () => _signInWithFacebook(context),
              ),
              SizedBox(
                height: 15,
              ),
              SignInButton(
                text: "Sign in with email",
                textColor: Colors.white,
                color: Colors.teal,
                onPressed: isLoading ? null : () => _signInWithEmail(context),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "--OR--",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SignInButton(
                text: "Anonomous",
                textColor: Colors.white,
                color: Colors.lightGreen,
                onPressed: () => isLoading ? null : _signInAnonymously(context),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

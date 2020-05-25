import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/common_widgets/form_submit_button.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/servises/auth.dart';
import 'package:flutter/services.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidator {

  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  String get _email => _emailEditingController.text;
  String get _password => _passwordEditingController.text;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose(){
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    }on PlatformException catch(e) {
      print(e.toString());
      showDialog(context: context,builder: (context){
        return AlertDialog(
          title: Text("Sign in failed"),
          content: Text(e.message),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            )
          ],
        );
      }
      );
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _emailEditingComplete(){
    final newFocus = widget.emailValidator.isValid(_email)
    ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
  void _toggleFormType(){
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailEditingController.clear();
    _passwordEditingController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? "Sign in "
        : "Create an account";
    final secondaryTest = _formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have an account ? Sign in";
    bool submitEnable = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password) && !_isLoading;

    bool showEmailErrorText = _submitted && !widget.emailValidator.isValid(_email);
    bool showPasswordErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    return [
      TextField(
        focusNode: _emailFocusNode,
        controller: _emailEditingController,
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "test@test.com",
          enabled: _isLoading == false,
          errorText: showEmailErrorText ? widget.invalidEmailErrorText : null,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (email) => _updateState(),
        onEditingComplete: _emailEditingComplete,

      ),
      SizedBox(
        height: 8,
      ),
      TextField(
        focusNode: _passwordFocusNode,
        controller: _passwordEditingController,
        decoration: InputDecoration(
          labelText: "password",
          enabled: _isLoading == false,
          errorText: showPasswordErrorText ? widget.invalidPasswordErrorText : null,
        ),
        obscureText: true,
        onEditingComplete: _submit,
        onChanged: (password) => _updateState(),
        textInputAction: TextInputAction.done,
      ),
      SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit: null,
      ),
      SizedBox(
        height: 8,
      ),
      FlatButton(
        child: Text(secondaryTest),
        onPressed: !_isLoading ? _toggleFormType : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}

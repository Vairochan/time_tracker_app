import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_bloc_bassed.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_change_notifier.dart';

import 'email_sign_in_form_stateful.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Sign In"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              child: EmailSignInFormNotifier.create(context),
            )
          ],
        )
      ),
    );
  }

  }

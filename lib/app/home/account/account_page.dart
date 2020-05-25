import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/common_widgets/avatar.dart';
import 'package:time_tracker/app/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker/servises/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return  Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Account"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: new Text("Logout",
              style: TextStyle(
                  color: Colors.white
              ),),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _builUserInfo(user),
        ),
      ),

    );
  }

  Widget _builUserInfo(User user) {
    return Column(
      children: <Widget>[
          Avatar(
            photoUrl: user.photoUrl,
            radius: 50,
          ),
        SizedBox(height: 8),
        if(user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8)
      ],
    );




  }
}

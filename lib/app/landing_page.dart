import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/home_page.dart';
import 'package:time_tracker/app/home/jobs/jobs_page.dart';
import 'package:time_tracker/app/sign_in/sign_in.dart';
import 'package:time_tracker/servises/auth.dart';
import 'package:time_tracker/servises/database.dart';

class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot){
       if (snapshot.connectionState == ConnectionState.active){
         User user = snapshot.data;
         if (user == null){
           return SignIn.create(context);
         }
           return Provider<User>.value(
             value: user,
             child: Provider<Database>(
                 create: (_) => FirestoreDatabase(uid: user.uid),
                 child: HomePage()),
           );
       }else{
         return Scaffold(
           body: Center(
             child: CircularProgressIndicator(),
           ),
         );
       }
      }
    );

  }
}

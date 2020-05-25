import 'package:flutter/material.dart';
import 'package:time_tracker/app/landing_page.dart';
import 'package:time_tracker/servises/auth.dart';
import 'package:provider/provider.dart';



void main(){
  runApp(MyApp());
  
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: "Time Tracker",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}

//  runApp(AuthProvider(
//    auth: Auth(),
//    child: new MaterialApp(
//      title: 'time traker',
//      theme: new ThemeData(
//        primarySwatch: Colors.grey
//      ),
//      home: LandingPage(),
//    ),
//  ));
//}
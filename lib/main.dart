import 'package:discovery_store/ui/pages/ranking_page.dart';
import 'package:discovery_store/ui/pages/submit_app_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RankingPage(),
      routes: {
        'submit_app' : (context) => SubmitAppPage(),
        'ranking_page' : (context) => RankingPage(),
      },
    );
  }
}



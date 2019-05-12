import 'dart:io';

import 'package:discovery_store/ui/pages/detail_page.dart';
import 'package:discovery_store/ui/pages/ranking_page.dart';
import 'package:discovery_store/ui/pages/submit_app_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'data/models.dart';
import 'data/network.dart';
import 'data/network_response.dart';

void main() {
  _setTargetPlatformForDesktop();
  runApp(new MyApp());
}
/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }

}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  Future<GetAllTagsResponse> future;


  @override
  void initState() {
    super.initState();
    future = network.getPossibleTags();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetAllTagsResponse>(
      future: future,
      builder: (context, snapshot) {

        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(!snapshot.requireData.success) {
          return Center(
            child: Material(
              child: Text("Ups, something went wrong (yes we actually did error handling)"),
            ),
          );
        }


        return TagHolder(
          tags: snapshot.requireData.tags,
          child: MaterialApp(
            title: 'Discovery Store',
            theme: new ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,

            ),
            home: RankingPage(),
            routes: {
              'submit_app' : (context) => SubmitAppPage(),
              'ranking_page' : (context) => RankingPage(),
            },
          ),
        );
      }
    );
  }
}


class TagHolder extends StatelessWidget {
  final List<Tag> tags;
  final Widget child;

  static List<Tag> getTags(BuildContext context) {
    return (context.ancestorWidgetOfExactType(TagHolder) as TagHolder).tags;
  }

  const TagHolder({Key key, this.tags, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}



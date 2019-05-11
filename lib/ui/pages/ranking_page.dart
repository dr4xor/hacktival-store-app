
import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/ui/widgets/app_item.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {


  final List<App> apps = [
    App(
      id: 1,
      score: 234,
      link: "Bacon – The Game",
      tags: [
        Tag(id: 3, name: "Game"),
        Tag(id: 4, name: "Ads"),
        Tag(id: 4, name: "Casual"),
      ]
    ),
    App(
      id: 1,
      score: 209,
      link: "Dungeon Cards",
      tags: [
        Tag(id: 3, name: "Game"),
        Tag(id: 4, name: "Ads"),
        Tag(id: 4, name: "Casual"),
        Tag(id: 4, name: "Turn based"),
        Tag(id: 4, name: "2D"),
        Tag(id: 4, name: "Pixel Art"),
      ]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: List<int>.generate(apps.length, (i) => i)
          .map((it) {
            return AppItem(
              app: apps[it],
              position: it,
            );
        }).toList(),
      ),
    );
  }
}


import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/ui/widgets/app_item.dart';
import 'package:discovery_store/ui/widgets/tag_chips.dart';
import 'package:discovery_store/ui/widgets/taggable_scaffold.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {


  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {

  bool searching = false;

  final TextEditingController textEditingController = TextEditingController();

  Set<Tag> filter = Set();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {

      });
    });
  }

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
        title: getAppBarContent(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            setState(() {
              searching = true;
            });
          })
        ],
      ),
      body: getContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("submit_app");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getAppBarContent() {
    if(searching) {
      return TextField(
        controller: textEditingController,
      );
    } else {
      return Text("Home");
    }
  }

  Widget getContent() {
    if(searching) {
      return TagList(
        possibleTags: [
          Tag(id: 3, name: "Hallo"),
        ],
        input: textEditingController.text,
        onTagSelected: (tag) {
          setState(() {
            searching = false;
          });
          filter.add(tag);
        },
      );
    } else {
      return Column(
        children: <Widget>[
          TagChips(
            tags: filter.toList(),
            editable: true,
            onTagsChanged: (it) {
              setState(() {
                filter = it.toSet();
              });
            },
          ),
          Expanded(
            child: ListView(
              children: List<int>.generate(apps.length, (i) => i)
                  .map((it) {
                return AppItem(
                  app: apps[it],
                  position: it,
                );
              }).toList(),
            ),
          ),
        ],
      );
    }
  }
}

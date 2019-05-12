import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/data/network.dart';
import 'package:discovery_store/data/network_response.dart';
import 'package:discovery_store/ui/widgets/app_item.dart';
import 'package:discovery_store/ui/widgets/tag_chips.dart';
import 'package:discovery_store/ui/widgets/taggable_scaffold.dart';
import 'package:discovery_store/utils.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final TextEditingController textEditingController = TextEditingController();

  Set<Tag> filter = Set();


  List<App> apps;

  bool canOpenTagSelector = false;

  bool error = false;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {});
    });
    refreshApps();
  }


  void refreshApps() {
    network.getAllApps().then((it) {
      if(!it.success) {
        error = true;
      } else {
        apps = it.apps;
      }
      setState(() {});
    });
  }


  Widget getContent() {
    if(error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                "Ups, something went wrong (yes we did error handling)"),
            MaterialButton(
              onPressed: () {
                refreshApps();
              },
              child: Text("Try again"),
            ),
          ],
        ),
      );
    }

    if(apps == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }


    List<App> appsToShow =
    apps.where((it) => containsAll(it.tags, filter)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          snap: true,
          title: Text("Discovery Store",),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () async {
                  Tag tag = await Navigator.push<Tag>(
                      context,
                      FadeRoute<Tag>(
                          builder: (context) => _SelectTagPage(
                            possibleTags:
                            TagHolder.getTags(context),
                          )));
                  if (tag == null) return;
                  filter.add(tag);
                  setState(() {});
                })
          ],
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, bottom: 8),
                child: TagChips(
                  tags: filter.toList(),
                  editable: true,
                  onTagsChanged: (it) {
                    setState(() {
                      filter = it.toSet();
                    });
                  },
                ),
              ),
              preferredSize: Size(0, filter.isEmpty ? 0 : 56)),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index % 2 == 1) return Divider();
            index = (index / 2).floor();
            return AppItem(
              key: ObjectKey(index),
              app: appsToShow[index],
              position: index,
              onNaviagateBack: () {
                refreshApps();
              },
              onUpvote: () {
                _vote(appsToShow[index].id, true);
              },
              onDownvote: () {
                _vote(appsToShow[index].id, false);
              },
            );
          }, childCount: appsToShow.length * 2 - 1),
        )
      ],
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: getContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed("submit_app");
        },
        icon: Icon(Icons.add),
        label: Text("Submit App"),
      ),
    );
  }

  _vote(int id, bool upvote) {
    network.vote(id, upvote);
    setState(() {
      apps.firstWhere((it) => it.id == id).score += upvote? 1: -1;
    });
  }

  bool containsAll<E>(Iterable<E> list, Iterable<E> filter) {
    for (E e in filter) {
      if (!list.contains(e)) return false;
    }
    return true;
  }
}

class _SelectTagPage extends StatefulWidget {
  _SelectTagPage({Key key, this.possibleTags}) : super(key: key);

  final List<Tag> possibleTags;

  @override
  __SelectTagPageState createState() => __SelectTagPageState();
}

class __SelectTagPageState extends State<_SelectTagPage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textEditingController,
          decoration: InputDecoration(hintText: "Start typing a tag"),
        ),
      ),
      body: TagList(
        possibleTags: widget.possibleTags,
        input: textEditingController.text,
        onTagSelected: (tag) {
          Navigator.of(context).pop(tag);
        },
      ),
    );
  }
}

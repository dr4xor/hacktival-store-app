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

  Future<GetAllAppsResponse> allApps;

  bool canOpenTagSelector = false;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {});
    });
    allApps = network.getAllApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<GetAllAppsResponse>(
                future: allApps,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.data.success) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              "Ups, something went wrong (yes we did error handling)"),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                allApps = network.getAllApps();
                              });
                            },
                            child: Text("Try again"),
                          ),
                        ],
                      ),
                    );
                  }
                  List<App> apps = snapshot.requireData.apps;

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
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          height: 64,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "Check out the top apps of the day!",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index % 2 == 1) return Divider();
                          index = (index / 2).floor();
                          return AppItem(
                            key: ObjectKey(index),
                            app: appsToShow[index],
                            position: index,
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
                  return ListView.custom(
                      childrenDelegate: SliverChildListDelegate([
                    ListView.separated(
                      itemBuilder: (context, index) {
                        return AppItem(
                          app: appsToShow[index],
                          position: index,
                          onUpvote: () {
                            _vote(appsToShow[index].id, true);
                          },
                          onDownvote: () {
                            _vote(appsToShow[index].id, false);
                          },
                        );
                      },
                      itemCount: appsToShow.length,
                      separatorBuilder: (_, o) => Divider(),
                    ),
                  ]));
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    SliverToBoxAdapter(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return AppItem(
                            app: appsToShow[index],
                            position: index,
                            onUpvote: () {
                              _vote(appsToShow[index].id, true);
                            },
                            onDownvote: () {
                              _vote(appsToShow[index].id, false);
                            },
                          );
                        },
                        itemCount: appsToShow.length,
                        separatorBuilder: (_, o) => Divider(),
                      ),
                    ),
                  ]));
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return AppItem(
                        app: appsToShow[index],
                        position: index,
                        onUpvote: () {
                          _vote(appsToShow[index].id, true);
                        },
                        onDownvote: () {
                          _vote(appsToShow[index].id, false);
                        },
                      );
                    },
                    itemCount: appsToShow.length,
                    separatorBuilder: (_, o) => Divider(),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("submit_app");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _vote(int id, bool upvote) {
    network.vote(id, upvote);
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


import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/data/network.dart';
import 'package:discovery_store/data/network_response.dart';
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

  Future<GetAllAppsResponse> allApps;

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
      appBar: AppBar(
        title: getAppBarContent(),
        actions: <Widget>[
          IconButton(icon: Icon(searching? Icons.delete : Icons.search), onPressed: () {
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

  _vote(int id, bool upvote) {
    network.vote(id, upvote);
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
            child: FutureBuilder<GetAllAppsResponse>(
              future: allApps,
              builder: (context, snapshot) {

                if(!snapshot.hasData || !snapshot.data.success) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Ups, something went wrong (yes we did error handling)"),
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
                return ListView(
                  children: List<int>.generate(apps.length, (i) => i)
                      .where((index) => containsAny(apps[index].tags, filter))
                      .map((it) {
                    return AppItem(
                      app: apps[it],
                      position: it,
                      onUpvote: () {
                        _vote(apps[it].id, true);
                      },
                      onDownvote: () {
                        _vote(apps[it].id, false);
                      },
                    );
                  }).toList(),
                );
              }
            ),
          ),
        ],
      );
    }
  }


  bool containsAny<E>(Iterable<E> list, Iterable<E> filter) {
    for(E e in filter) {
      if(!list.contains(e)) return false;
    }
   return true;
  }
}

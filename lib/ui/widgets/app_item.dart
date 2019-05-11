import 'dart:math';

import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/data/network.dart';
import 'package:discovery_store/data/network_response.dart';
import 'package:discovery_store/ui/widgets/tag_chips.dart';
import 'package:flutter/material.dart';

class AppItem extends StatefulWidget {

  const AppItem({Key key, this.position, this.app, this.onUpvote, this.onDownvote}) : super(key: key);


  /// For the size of of the item
  final int position;

  final App app;

  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  @override
  _AppItemState createState() => _AppItemState();
}

class _AppItemState extends State<AppItem> {



  Future<ParseAppResponse> playStoreEntryFuture;

  @override
  void initState() {
    super.initState();
    playStoreEntryFuture = scraper.getAppInfo(widget.app.link);
  }

  double _getHeightFactor() {
    return (max(0, 3-widget.position) * 0.2) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<ParseAppResponse>(
          future: playStoreEntryFuture,
          builder: (context, snapshot) {

            if(!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(!snapshot.requireData.success) {
              return Center(
                child: Text("Ups, something went wrong, (yes we actually did error handling)"),
              );
            }

            PlayStoreEntry entry = snapshot.requireData.playStoreEntry;

            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    VoteWidget(
                      onDownvote: widget.onDownvote,
                      onUpvote: widget.onUpvote,
                      score: widget.app.score,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Card(
                      child: Image.network("${entry.icon}=s128", height: 80 * _getHeightFactor(),),
                    ),
                    SizedBox(width: 16,),
                    Expanded(child: Text(entry.title, maxLines: 3, style: TextStyle(
                      fontSize: (15 * _getHeightFactor())
                    ),)),
                  ],
                ),
                /*Align(
                  alignment: Alignment.centerLeft,
                  child: TagChips(
                    editable: false,
                    tags: app.tags,
                  ),
                )*/
              ],
            );
          }
        ),
      ),
    );
  }
}

class VoteWidget extends StatelessWidget {

  const VoteWidget({Key key, this.onUpvote, this.onDownvote, this.score}) : super(key: key);

  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          child: Icon(Icons.keyboard_arrow_up),
          onTap: onUpvote,
        ),
        Text(score.toString()),
        InkWell(
          child: Icon(Icons.keyboard_arrow_down),
          onTap: onDownvote,
        )
      ],
    );
  }
}

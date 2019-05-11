import 'dart:math';

import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/ui/widgets/tag_chips.dart';
import 'package:flutter/material.dart';

class AppItem extends StatelessWidget {

  const AppItem({Key key, this.position, this.app, this.onUpvote, this.onDownvote}) : super(key: key);


  /// For the size of of the item
  final int position;

  final App app;

  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  // Todo implement marco server connection


  double _getHeightFactor() {
    return (max(0, 3-position) * 0.1) + 1;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _VoteWidget(
                onDownvote: onDownvote,
                onUpvote: onUpvote,
                score: app.score,
              ),
              Card(
                child: Image.network(
                    "https://lh3.googleusercontent.com/t2jjIr7yp9nveftXSZqfB0fa0O2gE_2bYHMhYHq-YLJBydKX9K0NhgWRaBqBvgcsNGFu=s360-rw",
                  height: 80 * _getHeightFactor(),
                ),
              ),
              Text("App name"),
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
      ),
    );
  }
}

class _VoteWidget extends StatelessWidget {

  const _VoteWidget({Key key, this.onUpvote, this.onDownvote, this.score}) : super(key: key);

  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          child: Icon(Icons.arrow_upward),
          onTap: onUpvote,
        ),
        Text(score.toString()),
        InkWell(
          child: Icon(Icons.arrow_downward),
          onTap: onDownvote,
        )
      ],
    );
  }
}

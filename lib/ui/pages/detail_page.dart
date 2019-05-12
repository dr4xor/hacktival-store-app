import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/data/network.dart';
import 'package:discovery_store/ui/widgets/app_item.dart';
import 'package:discovery_store/ui/widgets/tag_chips.dart';
import 'package:discovery_store/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class DetailPage extends StatelessWidget {

  final App app;
  final PlayStoreEntry entry;

  const DetailPage({Key key, @required this.app, @required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              onSharePressed();
            },
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          _HeaderCard(
            iconLink: smalifyLink(entry.icon),
            appName: entry.title,
            id: app.id,
            ratingScore: app.score,
            price: entry.price,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _TagsListEntry(
                  tags: app.tags,
                ),
                _DescriptionListEntry(
                    description: entry.description
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onOpenStorePressed();
        },
        tooltip: "Go to Play Store",
        child: Icon(Icons.shop),
      ),
    );
  }

  void onSharePressed() {
    Share.share(app.link);
  }

  void onOpenStorePressed() async {
    if(await canLaunch(app.link)) {
      launch(app.link);
    }
  }
}

class _HeaderCard extends StatefulWidget {

  final String iconLink;
  final String appName;
  final String price;
  final int ratingScore;
  final int id;

  const _HeaderCard({Key key, @required this.iconLink, @required this.appName, this.id, this.ratingScore, this.price}) : super(key: key);

  @override
  __HeaderCardState createState() => __HeaderCardState();
}

class __HeaderCardState extends State<_HeaderCard> {
  String _get_price_tag() {

    if (widget.price == "0") {
      return "FREE";
    }

    return widget.price;
  }

  int score;

  @override
  void initState() {
    super.initState();
    score = widget.ratingScore;
  }

  @override
  Widget build(BuildContext context) {

    return Material(
        elevation: 2,
        child: Container(

        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: 128,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // Left Align
            Hero(
              tag: widget.id,
              child: Image.network(
                widget.iconLink,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.appName,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _get_price_tag(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),
                  )
                ],
              ),
            ),
            VoteWidget(
              score: score,
              onUpvote: () => vote(true),
              onDownvote: () => vote(false),
            )
          ],
        ),
      ),
    );
  }


  void vote(bool up) {
    network.vote(widget.id, up);
    setState(() {
      score += up? 1: -1;
    });
  }
}

abstract class _DetailsListEntry extends StatelessWidget {

  const _DetailsListEntry({Key key}) : super(key: key);

  final TextStyle titleStyle = const TextStyle(
      fontWeight: FontWeight.bold,

      fontSize: 16
  );

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.black12, width: 1)
            )
        ),
        child: contentColumn(context)
    );
  }

  Widget contentColumn(BuildContext context);
}

class _DescriptionListEntry extends _DetailsListEntry {

  final String description;

  const _DescriptionListEntry({Key key, this.description}) : super(key: key);

  @override
  Widget contentColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Description",
          style: Theme.of(context).textTheme.body2,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          Uri.decodeFull(description).replaceAll("<br/>", "\n"), overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.body1,),
      ],
    );
  }
}

class _TagsListEntry extends _DetailsListEntry {

  final List<Tag> tags;

  const _TagsListEntry({Key key, this.tags}) : super(key: key);

  @override
  Widget contentColumn(BuildContext context) {
    return TagChips(
      editable: false,
      tags: tags,
    );
  }
}
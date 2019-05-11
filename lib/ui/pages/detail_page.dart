import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),

      ),

      body:
        _HeaderCard(
          iconLink: "https://lh3.googleusercontent.com/akv2Bdp7i5Vv-sl9FuP3_dhWpUO80zULf-Pkh6RFleomEp6pZorHuCNm3FbR9oAMunVK=s360",
          appName: "Clash of Clans",
        )
    );
  }
}

class _HeaderCard extends StatelessWidget {

  final String iconLink;
  final String appName;

  const _HeaderCard({Key key, @required this.iconLink, @required this.appName}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 15, 15, 15),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_up, size: 35),
                    Text("1231"),
                    Icon(Icons.keyboard_arrow_down, size: 35)
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[

                Expanded(
                  
                  child: Image.network(
                      iconLink,
                      fit: BoxFit.contain
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => {

                    }
                )
              ],
            )



          ],
        ),
      ),
    );
  }
}

class _RatingBox extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          width: 90.0,
          height: 38.0,
          alignment: Alignment(0, 0),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              Icon(Icons.thumb_up, size: 15),
              Text("999"),
              Icon(Icons.thumb_down, size: 15),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        )
      ],

    );
  }


}
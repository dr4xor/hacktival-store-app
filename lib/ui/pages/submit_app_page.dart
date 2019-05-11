import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/data/network.dart';
import 'package:discovery_store/data/network_response.dart';
import 'package:flutter/material.dart';

class SubmitAppPage extends StatelessWidget {

  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Enter to link to the App store page",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Hero(
                tag: "_",
                child: Material(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Give us your best App",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String text = textEditingController.text;

          ParseAppResponse response = await scraper.getAppInfo(text);
          if(!response.success || response.playStoreEntry == null) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Something went wrong (Yes we actually did"
                " error handling")));
            return;
          }


          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return _ConfirmAndChooseTagsPage(
                entry: response.playStoreEntry,
                appLink: text,
              );
            }
          ));
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class _ConfirmAndChooseTagsPage extends StatelessWidget {

  const _ConfirmAndChooseTagsPage({Key key, this.appLink, this.entry}) : super(key: key);

  final String appLink;
  final PlayStoreEntry entry;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: "_",
              child: Material(
                child: TextField(
                  controller: TextEditingController(text: appLink),
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            Row(
              children: <Widget>[
                Image.network("${entry.icon}=s128"),
                SizedBox(width: 16,),
                Text(entry.title),
              ],
            ),
            SizedBox(height: 16,),
            Text(Uri.decodeFull(entry.description).replaceAll("<br/>", "\n"), maxLines: 8, overflow: TextOverflow.ellipsis,),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                },
                child: Text("Submit")
              ),
            ),
          ],
        ),
      ),
    );
  }
}

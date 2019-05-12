import 'package:discovery_store/data/models.dart';
import 'package:discovery_store/data/network.dart';
import 'package:discovery_store/data/network_response.dart';
import 'package:discovery_store/main.dart';
import 'package:discovery_store/ui/widgets/tag_chips.dart';
import 'package:discovery_store/ui/widgets/taggable_scaffold.dart';
import 'package:discovery_store/utils.dart';
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

          ParseAppResponse response = await repository.getAppInfo(text);
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

class _ConfirmAndChooseTagsPage extends StatefulWidget {

  const _ConfirmAndChooseTagsPage({Key key, this.appLink, this.entry}) : super(key: key);

  final String appLink;
  final PlayStoreEntry entry;

  @override
  __ConfirmAndChooseTagsPageState createState() => __ConfirmAndChooseTagsPageState();
}

class __ConfirmAndChooseTagsPageState extends State<_ConfirmAndChooseTagsPage> {


  final TextEditingController textEditingController = TextEditingController();


  Set<Tag> tags = Set();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {setState(() {});});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Hero(
              tag: "_",
              child: Material(
                child: TextField(
                  controller: TextEditingController(text: widget.appLink),
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
                Image.network(smalifyLink(widget.entry.icon)),
                SizedBox(width: 16,),
                Text(widget.entry.title),
              ],
            ),
            SizedBox(height: 16,),
            Text(Uri.decodeFull(widget.entry.description).replaceAll("<br/>", "\n"), maxLines: 8, overflow: TextOverflow.ellipsis,),
            TextField(
              controller: textEditingController,
            ),
            textEditingController.text.isEmpty? SizedBox():
                TagList(
                  input: textEditingController.text,
                ),
            TagChips(
              editable: false,
              tags: tags.toList(),
            ),
            SizedBox(
              height: 200,
              child: TagList(
                onTagSelected: (tag) {
                  setState(() {
                    tags.add(tag);
                  });
                },
                possibleTags: TagHolder.getTags(context),
                input: textEditingController.text,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () async {
                  network.createApp(widget.appLink, tags.toList());
                  Navigator.of(context).pushReplacementNamed('ranking_page');
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

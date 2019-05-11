import 'package:flutter/material.dart';

class SubmitAppPage extends StatelessWidget {

  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return _ConfirmAndChooseTagsPage(
                appLink: textEditingController.text,
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

  const _ConfirmAndChooseTagsPage({Key key, this.appLink}) : super(key: key);

  final String appLink;


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
            )
          ],
        ),
      ),
    );
  }
}


import 'package:discovery_store/data/models.dart';
import 'package:flutter/material.dart';

class TaggableScaffold extends StatefulWidget {

  const TaggableScaffold({Key key, this.mainBody}) : super(key: key);

  final Widget mainBody;


  @override
  _TaggableScaffoldState createState() => _TaggableScaffoldState();
}

class _TaggableScaffoldState extends State<TaggableScaffold> {





  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TagList extends StatelessWidget {

  const TagList({Key key, this.possibleTags, this.input, this.onTagSelected}) : super(key: key);

  final List<Tag> possibleTags;
  final String input;

  final ValueChanged<Tag> onTagSelected;


  Iterable<Tag> tagsToShow() {
    return possibleTags.where((tag) => tag.name.toLowerCase().startsWith(input.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    var tags = tagsToShow().toList();
    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tags[index].name),
          onTap: () => onTagSelected(tags[index]),
        );
      }
    );
  }
}

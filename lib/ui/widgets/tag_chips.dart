import 'package:discovery_store/data/models.dart';
import 'package:flutter/material.dart';

class TagChips extends StatelessWidget {


  const TagChips({Key key, this.editable, this.tags, this.onTagsChanged}) : super(key: key);

  final bool editable;

  final List<Tag> tags;

  final ValueChanged<List<Tag>> onTagsChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: _chips().toList(),
      ),
    );
  }


  Iterable<Widget> _chips() sync*{
    for(Tag tag in tags) {
      if(editable) {
        yield Padding(
          padding: const EdgeInsets.all(2.0),
          child: Chip(
            label: Text(tag.name),
            onDeleted: () {
              List<Tag> newTags = List.from(tags)..remove(tag);
              onTagsChanged(newTags);
            },
          ),
        );
      } else {
        yield Padding(
          padding: const EdgeInsets.all(2.0),
          child: Chip(
            label: Text(tag.name),
          ),
        );
      }
    }
  }
}

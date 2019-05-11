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
    int i = 0;
    for(Tag tag in tags) {
      i++;
      if(i % 2 == 0) {
        yield Divider();
      }
      if(editable) {
        yield Chip(
          label: Text(tag.name),
          onDeleted: () {
            List<Tag> newTags = List.from(tags)..remove(tag);
            onTagsChanged(newTags);
          },
        );
      } else {
        yield Chip(
          label: Text(tag.name),
        );
      }
    }
  }
}

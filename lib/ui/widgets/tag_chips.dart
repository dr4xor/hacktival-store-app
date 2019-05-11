import 'package:discovery_store/data/models.dart';
import 'package:flutter/material.dart';

class TagChips extends StatelessWidget {


  const TagChips({Key key, this.editable, this.tags, this.onTagsChanged}) : super(key: key);

  final bool editable;

  final List<Tag> tags;

  final ValueChanged<List<Tag>> onTagsChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _chips().toList(),
    );
  }


  Iterable<Widget> _chips() sync*{
    for(Tag tag in tags) {
      if(editable) {
        yield FilterChip(
          label: Text(tag.name),
          onSelected: (enabled) {
            if(enabled) {
              var newTags = List.from(tags)..add(tag);
              onTagsChanged(newTags);
            } else {
              var newTags = List.from(tags)..remove(tag);
              onTagsChanged(newTags);
            }
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

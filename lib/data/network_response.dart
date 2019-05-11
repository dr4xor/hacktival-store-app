

import 'models.dart';

class GetAllAppsResponse {

  GetAllAppsResponse({this.success, this.apps});

  final bool success;
  final List<App> apps;

}


class CreateAppResponse {


  CreateAppResponse({this.success, this.app});

  final bool success;

  final App app;

}


class ParseAppResponse {

  ParseAppResponse({this.playStoreEntry, this.success});

  final PlayStoreEntry playStoreEntry;
  final bool success;


}


class GetAllTagsResponse {

  GetAllTagsResponse({this.tags, this.success});

  final List<Tag> tags;
  final bool success;

}
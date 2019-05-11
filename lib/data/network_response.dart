

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
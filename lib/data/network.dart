import 'dart:convert';

import 'models.dart';
import 'package:http/http.dart' as http;

import 'network_response.dart';

DiscoveryNetwork network = DiscoveryNetwork();

class DiscoveryNetwork {

  final String baseUrl = "http://159.69.155.106:8080/";

  Future<GetAllAppsResponse> getAllApps() async {

    http.Response response = await http.get("$baseUrl/api/apps");

    if(response.statusCode < 200 || response.statusCode > 299) {
      return GetAllAppsResponse(
        success: false,
      );
    }

    var jsonData = json.decode(response.body);
    List<App> apps = List<App>();
    if(jsonData != null) {
      jsonData.forEach((it) {
        apps.add(App.fromJson(it));
      });
    } else {
     return GetAllAppsResponse(
       success: false,
     );
    }
    return GetAllAppsResponse(
      success: true,
      apps: apps,
    );
  }



  Future<bool> vote(int id, bool up) async {

    http.Response response = await http.post("$baseUrl/api/apps/$id",
      body: {
      "isUpVote" : up,
      }
    );

    if(response.statusCode < 200 || response.statusCode > 299) {
      return false;
    }
    return true;
  }


  Future<CreateAppResponse> createApp(String link, List<Tag> tags) async {

    http.Response response = await http.post("$baseUrl/api/apps");


    if(response.statusCode < 200 || response.statusCode > 299) {
      return CreateAppResponse(
        success: false,
      );
    }

    return CreateAppResponse(
      success: true,
      app: App.fromJson(json.decode(response.body)),
    );

  }

}
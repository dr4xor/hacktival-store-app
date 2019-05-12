import 'dart:convert';

import 'models.dart';
import 'package:http/http.dart' as http;

import 'network_response.dart';

DiscoveryNetwork network = DiscoveryNetwork();
PlayScraper _scraper = PlayScraper();

Repository repository = Repository(
  scraper: _scraper
);

class Repository {

  final PlayScraper scraper;

  Repository({this.scraper});

  final Map<String, ParseAppResponse> _cache = {};


  Future<ParseAppResponse> getAppInfo(String link) async {
    if(_cache.containsKey(link)) {
      return _cache[link];
    }

    ParseAppResponse response = await scraper.getAppInfo(link);
    _cache[link] = response;
    return response;
  }


}

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

    http.Response response = await http.post("$baseUrl/api/apps",
      body: json.encode({
        "link": link,
        "tags": tags.map((it) => it.id).toList(),
      }),
      headers: {
        "Content-type": "application/json; charset=utf-8"
      }
    );


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


  Future<GetAllTagsResponse> getPossibleTags() async {


    http.Response response = await http.get("$baseUrl/api/tags");


    if(response.statusCode < 200 || response.statusCode > 299) {
      return GetAllTagsResponse(
        success: false,
      );
    }

    var jsonData = json.decode(response.body);
    List<Tag> tags = List<Tag>();
    if(jsonData != null) {
      jsonData.forEach((it) {
        tags.add(Tag.fromJson(it));
      });
    } else {
      return GetAllTagsResponse(
        success: false,
      );
    }
    return GetAllTagsResponse(
      success: true,
      tags: tags,
    );



  }

}


class PlayScraper {

  final String baseUrlScraper = "http://159.69.155.106:9090/";

  Future<ParseAppResponse> getAppInfo(String link) async {
    http.Response response = await http.get("$baseUrlScraper?app_url=$link");

    if(response.statusCode < 200 || response.statusCode > 299) {
      return ParseAppResponse(
        success: false,
      );
    }

    return ParseAppResponse(
      success: true,
      playStoreEntry: PlayStoreEntry.fromJson(json.decode(response.body)),
    );


  }
}
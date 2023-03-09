import 'dart:convert';

import 'package:myapp/models/api_response.dart';
import 'package:myapp/models/brief_for_listing.dart';
import 'package:http/http.dart' as http;

class BriefsService {
  static const API = 'http://192.168.9.69:7070';
  //static const headers = {'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471'};

  Future<APIResponse<List<BriefForListing>>> getBriefsList() {
    return http.get(Uri.parse(API+'/brief/all')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        var briefs = <BriefForListing>[];
        for (var item in jsonData) {
          print(item);
          final brief = BriefForListing(
            //briefID: item['briefID'],
            briefTitle: item['briefTitle'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
          briefs.add(brief);
        }
        return APIResponse<List<BriefForListing>>(data: briefs);
      }
      return APIResponse<List<BriefForListing>>(error: true, errorMessage: 'An error occured');
    })
    .catchError((_) => APIResponse<List<BriefForListing>>(error: true, errorMessage: 'An error occured'));
  }
}

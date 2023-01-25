library frigade_flutter;

import 'dart:convert';

import 'constants.dart';
import 'models/flow.dart';
import 'package:http/http.dart' as http;

class FrigadeClient {
  var publicApiKey = "";

  List<Flow> flows = [];

  FrigadeClient({required this.publicApiKey});

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
  'Authorization': 'Bearer $publicApiKey'};

  connect([var userId]) async {
    var url = "$urlPrefix/public/flows";
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) {
      throw Exception(
          "Request to $url failed with status ${response.statusCode}: ${response.body}");
    }

    final jsonResponse = json.decode(response.body)['data'];

    List<Flow> list = jsonResponse.map((val) =>  Flow.fromJson(val)).toList();
    flows = list;
    return list;
  }

  getFlow(String id) {
    return flows.firstWhere((flow) => flow.slug == id);
  }
}

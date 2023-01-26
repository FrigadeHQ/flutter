import 'dart:convert';

class FrigadeFlow {
  late String id;
  late String name;
  late List<dynamic> steps;
  late DateTime createdAt;
  late int version;

  FrigadeFlow({
    required this.id,
    required this.name,
    required this.steps,
    required this.createdAt,
    required this.version,
  });

  FrigadeFlow.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['slug'];
    name = jsonData['name'];
    steps = json.decode(jsonData['data'])['data'] ?? [];
    createdAt = DateTime.parse(jsonData['createdAt']);
    version = jsonData['version'];
  }
}

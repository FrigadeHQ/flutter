import 'dart:convert';

class Flow {
  late int id;
  late String customerId;
  late String organizationId;
  late String name;
  late Map<String, dynamic> data;
  late String description;
  late String createdAt;
  late String modifiedAt;
  late String version;
  late String slug;

  Flow({
    required this.id,
    required this.customerId,
    required this.organizationId,
    required this.name,
    required this.data,
    required this.description,
    required this.createdAt,
    required this.modifiedAt,
    required this.version,
    required this.slug,
  });

  Flow.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    customerId = jsonData['customerId'];
    organizationId = jsonData['organizationId'];
    name = jsonData['name'];
    data = json.decode(jsonData['data']);
    description = jsonData['description'];
    createdAt = jsonData['createdAt'];
    modifiedAt = jsonData['modifiedAt'];
    version = jsonData['version'];
    slug = jsonData['slug'];
  }
}

import 'dart:convert';

enum FlowActionType { STARTED_FLOW, STARTED_STEP, COMPLETED_STEP, ABORTED_FLOW, COMPLETED_FLOW }

class FlowResponse {
  late String foreignUserId;
  late String flowSlug;
  late String stepId;
  late String actionType;
  late Map<String, dynamic> data;
  late DateTime createdAt;

  FlowResponse({
    required this.foreignUserId,
    required this.flowSlug,
    required this.stepId,
    required this.actionType,
    required this.data,
    required this.createdAt,
  });

  FlowResponse.fromJson(Map<String, dynamic> jsonData) {
    foreignUserId = jsonData['foreignUserId'];
    flowSlug = jsonData['flowSlug'];
    stepId = jsonData['stepId'];
    actionType = jsonData['actionType'];
    data = jsonData['data'];
    createdAt = DateTime.parse(jsonData['createdAt']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowResponse &&
          toJson().toString() == other.toJson().toString();

  @override
  int get hashCode =>
      toJson().toString().hashCode;

  Map<String, dynamic> toJson() {
    return {
      'foreignUserId': foreignUserId,
      'flowSlug': flowSlug,
      'stepId': stepId,
      'actionType': actionType.toString().replaceAll("FlowActionType.", ""),
      'data': data,
      'createdAt': createdAt.toIso8601String().replaceAll(RegExp(r'\.\d+'), 'Z')
    };
  }
}
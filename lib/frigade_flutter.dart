library frigade_flutter;

import 'dart:convert';

import 'constants.dart';
import 'models/flow.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'models/flow_response.dart';

class FrigadeClient {
  var publicApiKey = "";
  List<FrigadeFlow> flows = [];
  var uuid = Uuid();
  String? userId;
  String? _currentActiveFlowId;
  bool _hasStartedFlow = false;
  bool _hasCompletedFlow = false;
  // Create map of all flowResponses that have been tracked
  // This is used to prevent duplicate tracking of flowResponses
  Set<FlowResponse> _trackedFlowResponses = new Set();

  FrigadeClient({required this.publicApiKey});

  Map<String, String> get headers =>
      {
        'Content-Type': 'application/json',
        'X-User-Id': userId ?? 'guest',
        'Authorization': 'Bearer $publicApiKey'
      };

  connect([var userId]) async {
    if (userId != null) {
      this.userId = userId;
    } else {
      this.userId = "guest_${uuid.v4()}";
    }

    var url = "$urlPrefix/public/flows";
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) {
      throw Exception(
          "Request to $url failed with status ${response.statusCode}: ${response
              .body}");
    }

    List<FrigadeFlow> list = (json.decode(response.body)['data'] as List)
        .map((i) => FrigadeFlow.fromJson(i))
        .toList();

    flows = list;
  }

  getFlow(String id) {
    return flows.firstWhere((flow) => flow.id == id);
  }

  _resetTrackingIfNeeded(String flowId) {
    if (flowId != _currentActiveFlowId) {
      _currentActiveFlowId = flowId;
      _hasStartedFlow = false;
      _hasCompletedFlow = false;
    }
  }

  track(String flowId, String? stepId, FlowActionType actionType,
      Map<String, dynamic>? data) async {
    if (_hasStartedFlow == true && actionType == FlowActionType.STARTED_FLOW) {
      return;
    }
    if (_hasCompletedFlow == true && actionType == FlowActionType.COMPLETED_FLOW) {
      return;
    }
    if (actionType == FlowActionType.STARTED_FLOW) {
      _hasStartedFlow = true;
      track(
          flowId,
          getFlow(flowId).steps[0]['id'],
          FlowActionType.STARTED_STEP,
          {});
    }
    if (actionType == FlowActionType.COMPLETED_FLOW) {
      _hasCompletedFlow = true;
    }
    _resetTrackingIfNeeded(flowId);
    var url = "$urlPrefix/public/flowResponses";
    var flowResponse = FlowResponse(
        flowSlug: flowId,
        stepId: stepId ?? 'unknown',
        actionType: actionType.toString(),
        foreignUserId: userId ?? 'guest',
        data: data ?? {},
        createdAt: DateTime.now());

    // Dedupe and ensure this event has not been sent yet
    if (_trackedFlowResponses.contains(flowResponse)) {
      return;
    }
    _trackedFlowResponses.add(flowResponse);

    var response = await http.post(Uri.parse(url), headers: headers,
        body: json.encode(flowResponse.toJson()));
    if (response.statusCode != 201 && response.statusCode != 200) {
      print(
          "Request to $url failed with status ${response.statusCode}: ${response
              .body}");
    }
  }
}

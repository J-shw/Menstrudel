import 'package:menstrudel/models/phone_sync/circle_data.dart';
import 'package:menstrudel/models/phone_sync/log_request.dart';

class SharedContextData {
  final CircleData? circleData;
  final LogRequest? logRequest;

  SharedContextData({this.circleData, this.logRequest});

  factory SharedContextData.fromJson(Map<dynamic, dynamic> json) {
    return SharedContextData(
      circleData: json['circleData'] != null
          ? CircleData.fromJson(Map<String, dynamic>.from(json['circleData']))
          : null,
      logRequest: json['logRequest'] != null
          ? LogRequest.fromJson(Map<String, dynamic>.from(json['logRequest']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circleData': circleData?.toJson(),
      'logRequest': logRequest?.toJson(),
    };
  }

  @override
  String toString() {
    return 'SharedContextData(circleData: ${circleData.toString()}, logRequest: ${logRequest.toString()})';
  }
}

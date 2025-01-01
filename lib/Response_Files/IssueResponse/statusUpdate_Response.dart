// To parse this JSON data, do
//
//     final statusUpdateResponse = statusUpdateResponseFromJson(jsonString);

import 'dart:convert';

StatusUpdateResponse statusUpdateResponseFromJson(String str) => StatusUpdateResponse.fromJson(json.decode(str));

String statusUpdateResponseToJson(StatusUpdateResponse data) => json.encode(data.toJson());

class StatusUpdateResponse {
  Settings settings;
  String message;

  StatusUpdateResponse({
    required this.settings,
    required this.message,
  });

  factory StatusUpdateResponse.fromJson(Map<String, dynamic> json) => StatusUpdateResponse(
    settings: Settings.fromJson(json["settings"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "message": message,
  };
}

class Settings {
  String success;

  Settings({
    required this.success,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}

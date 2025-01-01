// To parse this JSON data, do
//
//     final saveItemIssueResponse = saveItemIssueResponseFromJson(jsonString);

import 'dart:convert';

SaveItemIssueResponse saveItemIssueResponseFromJson(String str) => SaveItemIssueResponse.fromJson(json.decode(str));

String saveItemIssueResponseToJson(SaveItemIssueResponse data) => json.encode(data.toJson());

class SaveItemIssueResponse {
  Settings settings;
  String message;

  SaveItemIssueResponse({
    required this.settings,
    required this.message,
  });

  factory SaveItemIssueResponse.fromJson(Map<String, dynamic> json) => SaveItemIssueResponse(
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

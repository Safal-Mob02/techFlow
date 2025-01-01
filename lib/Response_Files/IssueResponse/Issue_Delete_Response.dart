// To parse this JSON data, do
//
//     final issueDeleteResponse = issueDeleteResponseFromJson(jsonString);

import 'dart:convert';

IssueDeleteResponse issueDeleteResponseFromJson(String str) => IssueDeleteResponse.fromJson(json.decode(str));

String issueDeleteResponseToJson(IssueDeleteResponse data) => json.encode(data.toJson());

class IssueDeleteResponse {
  Settings settings;
  String message;

  IssueDeleteResponse({
    required this.settings,
    required this.message,
  });

  factory IssueDeleteResponse.fromJson(Map<String, dynamic> json) => IssueDeleteResponse(
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

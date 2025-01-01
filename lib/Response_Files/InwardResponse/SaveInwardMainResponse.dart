
// To parse this JSON data, do
//
//     final saveInwardMainResponse = saveInwardMainResponseFromJson(jsonString);

import 'dart:convert';

SaveInwardMainResponse saveInwardMainResponseFromJson(String str) => SaveInwardMainResponse.fromJson(json.decode(str));

String saveInwardMainResponseToJson(SaveInwardMainResponse data) => json.encode(data.toJson());

class SaveInwardMainResponse {
  Settings settings;
  String message;
  String messageType;

  SaveInwardMainResponse({
    required this.settings,
    required this.message,
    required this.messageType,
  });

  factory SaveInwardMainResponse.fromJson(Map<String, dynamic> json) => SaveInwardMainResponse(
    settings: Settings.fromJson(json["settings"]),
    message: json["message"],
    messageType: json["message_type"],
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "message": message,
    "message_type": messageType,
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

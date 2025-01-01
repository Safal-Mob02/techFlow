// To parse this JSON data, do
//
//     final itemDeleteResponse = itemDeleteResponseFromJson(jsonString);

import 'dart:convert';

ItemDeleteResponse itemDeleteResponseFromJson(String str) => ItemDeleteResponse.fromJson(json.decode(str));

String itemDeleteResponseToJson(ItemDeleteResponse data) => json.encode(data.toJson());

class ItemDeleteResponse {
  Settings settings;

  ItemDeleteResponse({
    required this.settings,
  });

  factory ItemDeleteResponse.fromJson(Map<String, dynamic> json) => ItemDeleteResponse(
    settings: Settings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
  };
}

class Settings {
  String success;
  String message;

  Settings({
    required this.success,
    required this.message,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}

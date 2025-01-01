// To parse this JSON data, do
//
//     final purchaseQcItemSaveResponse = purchaseQcItemSaveResponseFromJson(jsonString);

import 'dart:convert';

PurchaseQcItemSaveResponse purchaseQcItemSaveResponseFromJson(String str) => PurchaseQcItemSaveResponse.fromJson(json.decode(str));

String purchaseQcItemSaveResponseToJson(PurchaseQcItemSaveResponse data) => json.encode(data.toJson());

class PurchaseQcItemSaveResponse {
  Settings settings;
  String message;
  String messageType;

  PurchaseQcItemSaveResponse({
    required this.settings,
    required this.message,
    required this.messageType,
  });

  factory PurchaseQcItemSaveResponse.fromJson(Map<String, dynamic> json) => PurchaseQcItemSaveResponse(
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

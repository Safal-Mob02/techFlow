// To parse this JSON data, do
//
//     final purchaseQcReasonResponse = purchaseQcReasonResponseFromJson(jsonString);

import 'dart:convert';

PurchaseQcReasonResponse purchaseQcReasonResponseFromJson(String str) => PurchaseQcReasonResponse.fromJson(json.decode(str));

String purchaseQcReasonResponseToJson(PurchaseQcReasonResponse data) => json.encode(data.toJson());

class PurchaseQcReasonResponse {
  Settings settings;
  List<Datum> data;

  PurchaseQcReasonResponse({
    required this.settings,
    required this.data,
  });

  factory PurchaseQcReasonResponse.fromJson(Map<String, dynamic> json) => PurchaseQcReasonResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String selectValue;
  String selectValueCode;

  Datum({
    required this.selectValue,
    required this.selectValueCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    selectValue: json["Select_Value"],
    selectValueCode: json["Select_Value_Code"],
  );

  Map<String, dynamic> toJson() => {
    "Select_Value": selectValue,
    "Select_Value_Code": selectValueCode,
  };
}

class Settings {
  String success;
  String message;
  List<String> fields;

  Settings({
    required this.success,
    required this.message,
    required this.fields,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
    message: json["message"],
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "fields": List<dynamic>.from(fields.map((x) => x)),
  };
}

// To parse this JSON data, do
//
//     final issueItemListResponse = issueItemListResponseFromJson(jsonString);

import 'dart:convert';

IssueItemListResponse issueItemListResponseFromJson(String str) => IssueItemListResponse.fromJson(json.decode(str));

String issueItemListResponseToJson(IssueItemListResponse data) => json.encode(data.toJson());

class IssueItemListResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  IssueItemListResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory IssueItemListResponse.fromJson(Map<String, dynamic> json) => IssueItemListResponse(
    settings: Settings.fromJson(json["settings"]),
    message: json["message"],
    fields: List<String>.from(json["fields"].map((x) => x)),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "message": message,
    "fields": List<dynamic>.from(fields.map((x) => x)),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String itemName;
  String itemCode;
  var unitCode;
  var unitName;
  Datum({
    required this.itemName,
    required this.itemCode,
    required this.unitCode,
    required this.unitName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    itemName: json["Item Name"],
    itemCode: json["Item Code"],
    unitCode: json["Unit Code"]!,
    unitName:json["Unit Name"]!,
  );

  Map<String, dynamic> toJson() => {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Unit Code": unitCode,
    "Unit Name": unitName,
  };
}

enum UnitCode {
  M0100_A000002
}

final unitCodeValues = EnumValues({
  "M0100A000002": UnitCode.M0100_A000002
});

enum UnitName {
  NOS
}

final unitNameValues = EnumValues({
  "Nos": UnitName.NOS
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// To parse this JSON data, do
//
//     final inwardLocationResponse = inwardLocationResponseFromJson(jsonString);

import 'dart:convert';

InwardLocationResponse inwardLocationResponseFromJson(String str) => InwardLocationResponse.fromJson(json.decode(str));

String inwardLocationResponseToJson(InwardLocationResponse data) => json.encode(data.toJson());

class InwardLocationResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  InwardLocationResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory InwardLocationResponse.fromJson(Map<String, dynamic> json) => InwardLocationResponse(
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

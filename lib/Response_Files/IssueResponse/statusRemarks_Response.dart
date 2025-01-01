// To parse this JSON data, do
//
//     final statusRemarksResponse = statusRemarksResponseFromJson(jsonString);

import 'dart:convert';

StatusRemarksResponse statusRemarksResponseFromJson(String str) => StatusRemarksResponse.fromJson(json.decode(str));

String statusRemarksResponseToJson(StatusRemarksResponse data) => json.encode(data.toJson());

class StatusRemarksResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  StatusRemarksResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory StatusRemarksResponse.fromJson(Map<String, dynamic> json) => StatusRemarksResponse(
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
  String paraDescription;

  Datum({
    required this.paraDescription,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    paraDescription: json["Para_Description"],
  );

  Map<String, dynamic> toJson() => {
    "Para_Description": paraDescription,
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

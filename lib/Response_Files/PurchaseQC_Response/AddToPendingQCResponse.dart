// To parse this JSON data, do
//
//     final addToPendingQcResponse = addToPendingQcResponseFromJson(jsonString);

import 'dart:convert';

AddToPendingQcResponse addToPendingQcResponseFromJson(String str) => AddToPendingQcResponse.fromJson(json.decode(str));

String addToPendingQcResponseToJson(AddToPendingQcResponse data) => json.encode(data.toJson());

class AddToPendingQcResponse {
  Settings settings;
  List<Datum> data;

  AddToPendingQcResponse({
    required this.settings,
    required this.data,
  });

  factory AddToPendingQcResponse.fromJson(Map<String, dynamic> json) => AddToPendingQcResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String urnNo;

  Datum({
    required this.urnNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    urnNo: json["urn_no"],
  );

  Map<String, dynamic> toJson() => {
    "urn_no": urnNo,
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
    success: json["success"]??"",
    message: json["message"]??"",
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "fields": List<dynamic>.from(fields.map((x) => x)),
  };
}

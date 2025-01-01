// To parse this JSON data, do
//
//     final docNoResponse = docNoResponseFromJson(jsonString);

import 'dart:convert';

DocNoResponse docNoResponseFromJson(String str) => DocNoResponse.fromJson(json.decode(str));

String docNoResponseToJson(DocNoResponse data) => json.encode(data.toJson());

class DocNoResponse {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  DocNoResponse({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory DocNoResponse.fromJson(Map<String, dynamic> json) => DocNoResponse(
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
  String docNo;
  String docNoalias;
  String numericDocNo;

  Datum({
    required this.docNo,
    required this.docNoalias,
    required this.numericDocNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    docNo: json["Doc_No"],
    docNoalias: json["DocNoalias"],
    numericDocNo: json["NumericDoc_No"],
  );

  Map<String, dynamic> toJson() => {
    "Doc_No": docNo,
    "DocNoalias": docNoalias,
    "NumericDoc_No": numericDocNo,
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

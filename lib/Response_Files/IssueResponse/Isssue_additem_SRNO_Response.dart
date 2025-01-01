// To parse this JSON data, do
//
//     final IsssueAdditem_SRNO_Response = IsssueAdditem_SRNO_ResponseFromJson(jsonString);

import 'dart:convert';

IsssueAdditem_SRNO_Response IsssueAdditem_SRNO_ResponseFromJson(String str) => IsssueAdditem_SRNO_Response.fromJson(json.decode(str));

String IsssueAdditem_SRNO_ResponseToJson(IsssueAdditem_SRNO_Response data) => json.encode(data.toJson());

class IsssueAdditem_SRNO_Response {
  Settings settings;
  String message;
  List<String> fields;
  List<Datum> data;

  IsssueAdditem_SRNO_Response({
    required this.settings,
    required this.message,
    required this.fields,
    required this.data,
  });

  factory IsssueAdditem_SRNO_Response.fromJson(Map<String, dynamic> json) => IsssueAdditem_SRNO_Response(
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
  int issueSrno;
  int index;

  Datum({
    required this.issueSrno,
    required this.index,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    issueSrno: json["ISSUE_SRNO"],
    index: json["Index"],
  );

  Map<String, dynamic> toJson() => {
    "ISSUE_SRNO": issueSrno,
    "Index": index,
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

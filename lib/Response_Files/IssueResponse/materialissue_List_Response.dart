// To parse this JSON data, do
//
//     final materialissueListResponse = materialissueListResponseFromJson(jsonString);

import 'dart:convert';

MaterialissueListResponse materialissueListResponseFromJson(String str) => MaterialissueListResponse.fromJson(json.decode(str));

String materialissueListResponseToJson(MaterialissueListResponse data) => json.encode(data.toJson());

class MaterialissueListResponse {
  Settings settings;
  List<Datum> data;

  MaterialissueListResponse({
    required this.settings,
    required this.data,
  });

  factory MaterialissueListResponse.fromJson(Map<String, dynamic> json) => MaterialissueListResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  var status;
  String urnNo;
  String soNo;
  dynamic issueDate;
  String issueNo;
  String deptDetails;
  String refNo;
  int srNo;

  Datum({
    required this.status,
    required this.urnNo,
    required this.soNo,
    required this.issueDate,
    required this.issueNo,
    required this.deptDetails,
    required this.refNo,
    required this.srNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"]!,
    urnNo: json["URN_No"],
    soNo: json["SO No"],
    issueDate: json["Issue Date"],
    issueNo: json["Issue No"],
    deptDetails: json["Dept Details"]??"",
    refNo: json["Ref No"],
    srNo: json["Sr_No"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "URN_No": urnNo,
    "SO No": soNo,
    "Issue Date": issueDate,
    "Issue No": issueNo,
    "Dept Details": deptDetails,
    "Ref No": refNo,
    "Sr_No": srNo,
  };
}

enum IssueDate {
  THE_27062024,
  THE_28062024
}

final issueDateValues = EnumValues({
  "27/06/2024": IssueDate.THE_27062024,
  "28/06/2024": IssueDate.THE_28062024
});

enum Status {
  APPROVED,
  NOT_APPROVED
}

final statusValues = EnumValues({
  "Approved": Status.APPROVED,
  "Not Approved": Status.NOT_APPROVED
});

class Settings {
  String success;
  String message;
  String nextPage;
  List<String> fields;

  Settings({
    required this.success,
    required this.message,
    required this.nextPage,
    required this.fields,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    success: json["success"],
    message: json["message"],
    nextPage: json["next_page"],
    fields: List<String>.from(json["fields"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "next_page": nextPage,
    "fields": List<dynamic>.from(fields.map((x) => x)),
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

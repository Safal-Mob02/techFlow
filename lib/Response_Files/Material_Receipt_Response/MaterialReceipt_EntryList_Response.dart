// To parse this JSON data, do
//
//     final materialReceiptEntryListResponse = materialReceiptEntryListResponseFromJson(jsonString);

import 'dart:convert';

MaterialReceiptEntryListResponse materialReceiptEntryListResponseFromJson(String str) => MaterialReceiptEntryListResponse.fromJson(json.decode(str));

String materialReceiptEntryListResponseToJson(MaterialReceiptEntryListResponse data) => json.encode(data.toJson());

class MaterialReceiptEntryListResponse {
  Settings settings;
  List<Datum> data;

  MaterialReceiptEntryListResponse({
    required this.settings,
    required this.data,
  });

  factory MaterialReceiptEntryListResponse.fromJson(Map<String, dynamic> json) => MaterialReceiptEntryListResponse(
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
  String docNo;
  String soNo;
  var process;
  String remark;
  String gatePassNo;
  var srNo;
  String? docDate;
  String? departmentDetails;
  String? itemName;

  Datum({
    required this.status,
    required this.urnNo,
    required this.docNo,
    required this.soNo,
    required this.process,
    required this.remark,
    required this.gatePassNo,
    required this.srNo,
    this.docDate,
    this.departmentDetails,
    this.itemName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"],
    urnNo: json["URN_No"],
    docNo: json["Doc No"],
    soNo: json["SO No"],
    process: json["Process"]!,
    remark: json["Remark"],
    gatePassNo: json["Gate Pass No"],
    srNo: json["Sr_No"],
    docDate: json["Doc Date"],
    departmentDetails: json["Department_Details"],
    itemName: json["Item Name"],
  );

  Map<String, dynamic> toJson() => {
    "Status": statusValues.reverse[status],
    "URN_No": urnNo,
    "Doc No": docNo,
    "SO No": soNo,
    "Process": processValues.reverse[process],
    "Remark": remark,
    "Gate Pass No": gatePassNo,
    "Sr_No": srNo,
    "Doc Date": docDate,
    "Department_Details": departmentDetails,
    "Item Name": itemName,
  };
}

enum Process {
  CUTTING,
  EMPTY,
  STRUCTURE_CUTTING
}

final processValues = EnumValues({
  "Cutting": Process.CUTTING,
  "": Process.EMPTY,
  "Structure Cutting": Process.STRUCTURE_CUTTING
});

enum Status {
  APPROVED,
  DRAFT,
  NOT_APPROVED
}

final statusValues = EnumValues({
  "Approved": Status.APPROVED,
  "Draft": Status.DRAFT,
  "Not Approved": Status.NOT_APPROVED
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

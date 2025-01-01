// To parse this JSON data, do
//
//     final inwardListingResponse = inwardListingResponseFromJson(jsonString);

import 'dart:convert';

InwardListingResponse inwardListingResponseFromJson(String str) => InwardListingResponse.fromJson(json.decode(str));

String inwardListingResponseToJson(InwardListingResponse data) => json.encode(data.toJson());

class InwardListingResponse {
  Settings settings;
  List<Datum> data;

  InwardListingResponse({
    required this.settings,
    required this.data,
  });

  factory InwardListingResponse.fromJson(Map<String, dynamic> json) => InwardListingResponse(
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
  String inwardDate;
  String inwardNo;
  String challanNo;
  String accountDetails;
  String soNo;
  String poNo;
  var preparedBy;
  var approvedBy;
  int srNo;

  Datum({
    required this.status,
    required this.urnNo,
    required this.inwardDate,
    required this.inwardNo,
    required this.challanNo,
    required this.accountDetails,
    required this.soNo,
    required this.poNo,
    required this.preparedBy,
    required this.approvedBy,
    required this.srNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"]!,
    urnNo: json["URN_No"],
    inwardDate: json["Inward Date"]??"",
    inwardNo: json["Inward No"],
    challanNo: json["Challan No"],
    accountDetails: json["Account_Details"]??"",
    soNo: json["SO No"],
    poNo: json["PO No"],
    preparedBy: json["Prepared By"]!,
    approvedBy: json["Approved By"],
    srNo: json["Sr_No"],
  );

  Map<String, dynamic> toJson() => {
    "Status":status,
    "URN_No": urnNo,
    "Inward Date": inwardDate,
    "Inward No": inwardNo,
    "Challan No": challanNo,
    "Account_Details": accountDetails,
    "SO No": soNo,
    "PO No": poNo,
    "Prepared By":preparedBy,
    "Approved By": approvedBy,
    "Sr_No": srNo,
  };
}

enum EdBy {
  JAYANAND_CHRISTIAN,
  JIGNESH_SODHA,
  KIRAN_JADHAV,
  KISHAN_PRAJAPATI,
  KISHAN_SODHA,
  MAULIK_PATEL,
  MAYUR_SHAH,
  PRINCE_GOHEL,
  RAJU_RABARI,
  SUMER_NAYAK
}

final edByValues = EnumValues({
  "Jayanand Christian": EdBy.JAYANAND_CHRISTIAN,
  "Jignesh Sodha": EdBy.JIGNESH_SODHA,
  "Kiran Jadhav": EdBy.KIRAN_JADHAV,
  "Kishan Prajapati": EdBy.KISHAN_PRAJAPATI,
  "Kishan Sodha": EdBy.KISHAN_SODHA,
  "Maulik Patel": EdBy.MAULIK_PATEL,
  "Mayur Shah": EdBy.MAYUR_SHAH,
  "Prince Gohel": EdBy.PRINCE_GOHEL,
  "Raju Rabari": EdBy.RAJU_RABARI,
  "Sumer Nayak": EdBy.SUMER_NAYAK
});

enum Status {
  APPROVED,
  FORWARDED
}

final statusValues = EnumValues({
  "Approved": Status.APPROVED,
  "Forwarded": Status.FORWARDED
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

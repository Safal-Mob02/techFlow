// To parse this JSON data, do
//
//     final purchaseQcMainListingResponse = purchaseQcMainListingResponseFromJson(jsonString);

import 'dart:convert';

PurchaseQcMainListingResponse purchaseQcMainListingResponseFromJson(String str) => PurchaseQcMainListingResponse.fromJson(json.decode(str));

String purchaseQcMainListingResponseToJson(PurchaseQcMainListingResponse data) => json.encode(data.toJson());

class PurchaseQcMainListingResponse {
  Settings settings;
  List<Datum> data;

  PurchaseQcMainListingResponse({
    required this.settings,
    required this.data,
  });

  factory PurchaseQcMainListingResponse.fromJson(Map<String, dynamic> json) => PurchaseQcMainListingResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String status;
  int srNo;
  String urnNo;
  String docDate;
  String docNo;
  String soNo;
  String partyDetails;
  String itemName;
  String sampleQty;
  String process;
  String remark;
  String contractorName;
  String prdNo;

  Datum({
    required this.status,
    required this.srNo,
    required this.urnNo,
    required this.docDate,
    required this.docNo,
    required this.soNo,
    required this.partyDetails,
    required this.itemName,
    required this.sampleQty,
    required this.process,
    required this.remark,
    required this.contractorName,
    required this.prdNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"]??"",
    srNo: json["Sr_No"],
    urnNo: json["URN_No"]??"",
    docDate: json["Doc Date"]??"",
    docNo: json["Doc No"]??"",
    soNo: json["So No"]??"",
    partyDetails: json["Party Details"]??"",
    itemName: json["Item Name"]??"",
    sampleQty: json["Sample Qty"]??"",
    process: json["Process"]??"",
    remark: json["Remark"]??"",
    contractorName: json["Contractor Name"]??"",
    prdNo: json["PRD No"]??"",
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Sr_No": srNo,
    "URN_No": urnNo,
    "Doc Date": docDate,
    "Doc No": docNo,
    "So No": soNo,
    "Party Details": partyDetails,
    "Item Name": itemName,
    "Sample Qty": sampleQty,
    "Process": process,
    "Remark": remark,
    "Contractor Name": contractorName,
    "PRD No": prdNo,
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

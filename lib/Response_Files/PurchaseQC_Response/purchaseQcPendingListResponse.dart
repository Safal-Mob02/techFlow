// To parse this JSON data, do
//
//     final purchaseQcPendingListResponse = purchaseQcPendingListResponseFromJson(jsonString);

import 'dart:convert';

PurchaseQcPendingListResponse purchaseQcPendingListResponseFromJson(String str) => PurchaseQcPendingListResponse.fromJson(json.decode(str));

String purchaseQcPendingListResponseToJson(PurchaseQcPendingListResponse data) => json.encode(data.toJson());

class PurchaseQcPendingListResponse {
  Settings settings;
  List<Datum> data;

  PurchaseQcPendingListResponse({
    required this.settings,
    required this.data,
  });

  factory PurchaseQcPendingListResponse.fromJson(Map<String, dynamic> json) => PurchaseQcPendingListResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String status;
  String urnNo;
  String orderDate;
  String accountDetails;
  String itemName;
  var qty;
  String soNo;
  var itemSrNo;
  String poNo;
  var srNo;

  Datum({
    required this.status,
    required this.urnNo,
    required this.orderDate,
    required this.accountDetails,
    required this.itemName,
    required this.qty,
    required this.soNo,
    required this.itemSrNo,
    required this.poNo,
    required this.srNo,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    status: json["Status"],
    urnNo: json["Urn_No"],
    orderDate: json["Order Date"],
    accountDetails: json["Account_Details"],
    itemName: json["Item Name"],
    qty: json["Qty"],
    soNo: json["SO No"],
    itemSrNo: json["Item Sr No"],
    poNo: json["PO No"],
    srNo: json["Sr_No"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Urn_No": urnNo,
    "Order Date": orderDate,
    "Account_Details": accountDetails,
    "Item Name": itemName,
    "Qty": qty,
    "SO No": soNo,
    "Item Sr No": itemSrNo,
    "PO No": poNo,
    "Sr_No": srNo,
  };
}

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

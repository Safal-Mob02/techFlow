// To parse this JSON data, do
//
//     final inwardItemListResponse = inwardItemListResponseFromJson(jsonString);

import 'dart:convert';

InwardItemListResponse inwardItemListResponseFromJson(String str) => InwardItemListResponse.fromJson(json.decode(str));

String inwardItemListResponseToJson(InwardItemListResponse data) => json.encode(data.toJson());

class InwardItemListResponse {
  Settings settings;
  List<Datum> data;

  InwardItemListResponse({
    required this.settings,
    required this.data,
  });

  factory InwardItemListResponse.fromJson(Map<String, dynamic> json) => InwardItemListResponse(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  var index;
  var purInwardSrNo;
  String itemName;
  var inQty;
  String inUnit;
  var quantity;
  String unit;
  String unitCode;
  double rate;
  var discount;
  var disAmount;
  var amount;
  String location;
  String locationCode;
  String soNo;
  String description;
  String remarks;
  String fromUrnNo;
  var fromItemSrNo;
  String qcItem;
  String lotNo;
  String pONo;
  String pODate;
  String itemCode;

  Datum({
    required this.index,
    required this.purInwardSrNo,
    required this.itemName,
    required this.inQty,
    required this.inUnit,
    required this.quantity,
    required this.unit,
    required this.unitCode,
    required this.rate,
    required this.discount,
    required this.disAmount,
    required this.amount,
    required this.location,
    required this.locationCode,
    required this.soNo,
    required this.description,
    required this.remarks,
    required this.fromUrnNo,
    required this.fromItemSrNo,
    required this.qcItem,
    required this.lotNo,
    required this.pONo,
    required this.pODate,
    required this.itemCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    index: json["Index"],
    purInwardSrNo: json["Pur_Inward_SrNo"],
    itemName: json["Item_Name"],
    inQty: json["IN_Qty"],
    inUnit: json["IN_Unit"],
    quantity: json["Quantity"],
    unit: json["Unit"],
    unitCode: json["Unit Code"],
    rate: json["Rate"]?.toDouble(),
    discount: json["Discount"],
    disAmount: json["Dis_Amount"],
    amount: json["Amount"],
    location: json["Location"],
    locationCode: json["Location Code"],
    soNo: json["SO_No"],
    description: json["Description"],
    remarks: json["Remarks"],
    fromUrnNo: json["From_URN_No"],
    fromItemSrNo: json["From_Item_Sr_No"],
    qcItem: json["QcItem"],
    lotNo: json["Lot_No"],
    pONo: json["P.O._No"],
    pODate: json["P.O._Date"],
    itemCode: json["Item_Code"],
  );

  Map<String, dynamic> toJson() => {
    "Index": index,
    "Pur_Inward_SrNo": purInwardSrNo,
    "Item_Name": itemName,
    "IN_Qty": inQty,
    "IN_Unit": inUnit,
    "Quantity": quantity,
    "Unit": unit,
    "Unit Code": unitCode,
    "Rate": rate,
    "Discount": discount,
    "Dis_Amount": disAmount,
    "Amount": amount,
    "Location": location,
    "Location Code": locationCode,
    "SO_No": soNo,
    "Description": description,
    "Remarks": remarks,
    "From_URN_No": fromUrnNo,
    "From_Item_Sr_No": fromItemSrNo,
    "QcItem": qcItem,
    "Lot_No": lotNo,
    "P.O._No": pONo,
    "P.O._Date": pODate,
    "Item_Code": itemCode,
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

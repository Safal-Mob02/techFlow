// To parse this JSON data, do
//
//     final purchaseQcMainData = purchaseQcMainDataFromJson(jsonString);

import 'dart:convert';

PurchaseQcMainData purchaseQcMainDataFromJson(String str) => PurchaseQcMainData.fromJson(json.decode(str));

String purchaseQcMainDataToJson(PurchaseQcMainData data) => json.encode(data.toJson());

class PurchaseQcMainData {
  Settings settings;
  List<Datum> data;

  PurchaseQcMainData({
    required this.settings,
    required this.data,
  });

  factory PurchaseQcMainData.fromJson(Map<String, dynamic> json) => PurchaseQcMainData(
    settings: Settings.fromJson(json["settings"]),
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String itemCode;
  String category;
  String Welding_Contractor;
  String Contractor_Name;
  DateTime date;
  String party;
  String item;
  String sampleQty;
  var batchQty;
  String location;
  String soNo;
  String partyName;
  String process;
  String contractorName;
  String weldingContractor;
  String inspectionBy;
  String draughtman;
  String drgWEight;
  var assemblyWeight;
  String remark;
  bool autoReceipt;
  String autoReceiptNo;
  String repeatQcNo;
  String repeat;
  String qcUrnNo;
  String tcRequired;

  Datum({
    required this.itemCode,
    required this.category,
    required this.date,
    required this.party,
    required this.Welding_Contractor,
    required this.Contractor_Name,
    required this.item,
    required this.sampleQty,
    required this.batchQty,
    required this.location,
    required this.soNo,
    required this.partyName,
    required this.process,
    required this.contractorName,
    required this.weldingContractor,
    required this.inspectionBy,
    required this.draughtman,
    required this.drgWEight,
    required this.assemblyWeight,
    required this.remark,
    required this.autoReceipt,
    required this.autoReceiptNo,
    required this.repeatQcNo,
    required this.repeat,
    required this.qcUrnNo,
    required this.tcRequired,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    itemCode: json["Item_Code"],
    category: json["Category"],
    date: DateTime.parse(json["Date"]),
    Contractor_Name: json["Contractor_Name"]??"",
    Welding_Contractor: json["Welding_Contractor"]??"",
    party: json["Party"],
    item: json["Item"],
    sampleQty: json["Sample Qty"],
    batchQty: json["Batch Qty"],
    location: json["Location"],
    soNo: json["SO NO"],
    partyName: json["Party Name"],
    process: json["Process"],
    contractorName: json["Contractor Name"],
    weldingContractor: json["Welding Contractor"],
    inspectionBy: json["Inspection By"],
    draughtman: json["Draughtman"],
    drgWEight: json["Drg WEight"],
    assemblyWeight: json["Assembly Weight"],
    remark: json["Remark"],
    autoReceipt: json["Auto Receipt"],
    autoReceiptNo: json["Auto Receipt No"],
    repeatQcNo: json["Repeat QC No"],
    repeat: json["Repeat"],
    qcUrnNo: json["QC_URN__No"],
    tcRequired: json["TC_Required"],
  );

  Map<String, dynamic> toJson() => {
    "Item_Code": itemCode,
    "Category": category,
    "Date": date.toIso8601String(),
    "Party": party,
    "Item": item,
    "Sample Qty": sampleQty,
    "Welding_Contractor": Welding_Contractor,
    "Contractor_Name": Contractor_Name,
    "Batch Qty": batchQty,
    "Location": location,
    "SO NO": soNo,
    "Party Name": partyName,
    "Process": process,
    "Contractor Name": contractorName,
    "Welding Contractor": weldingContractor,
    "Inspection By": inspectionBy,
    "Draughtman": draughtman,
    "Drg WEight": drgWEight,
    "Assembly Weight": assemblyWeight,
    "Remark": remark,
    "Auto Receipt": autoReceipt,
    "Auto Receipt No": autoReceiptNo,
    "Repeat QC No": repeatQcNo,
    "Repeat": repeat,
    "QC_URN__No": qcUrnNo,
    "TC_Required": tcRequired,
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

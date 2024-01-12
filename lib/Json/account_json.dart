
import 'dart:convert';

AccountsJson accountsJsonFromMap(String str) => AccountsJson.fromMap(json.decode(str));

String accountsJsonToMap(AccountsJson data) => json.encode(data.toMap());

class AccountsJson {
  final int? accId;
  final String accHolder;
  final String accName;
  final int accStatus;
  final String createdAt;

  AccountsJson({
    this.accId,
    required this.accHolder,
    required this.accName,
    required this.accStatus,
    required this.createdAt,
  });

  factory AccountsJson.fromMap(Map<String, dynamic> json) => AccountsJson(
    accId: json["accId"],
    accHolder: json["accHolder"],
    accName: json["accName"],
    accStatus: json["accStatus"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toMap() => {
    "accId": accId,
    "accHolder": accHolder,
    "accName": accName,
    "accStatus": accStatus,
    "createdAt": createdAt,
  };
}

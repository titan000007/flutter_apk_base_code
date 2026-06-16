class CreatePaymentLinkModel {
  CreatePaymentLinkModel({
      this.statusCode, 
      this.status, 
      this.msgCode, 
      this.msg, 
      this.data,});

  CreatePaymentLinkModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    status = json['status'];
    msgCode = json['msgCode'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? statusCode;
  String? status;
  String? msgCode;
  String? msg;
  Data? data;
CreatePaymentLinkModel copyWith({  num? statusCode,
  String? status,
  String? msgCode,
  String? msg,
  Data? data,
}) => CreatePaymentLinkModel(  statusCode: statusCode ?? this.statusCode,
  status: status ?? this.status,
  msgCode: msgCode ?? this.msgCode,
  msg: msg ?? this.msg,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['status'] = status;
    map['msgCode'] = msgCode;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.clientSecret,});

  Data.fromJson(dynamic json) {
    clientSecret = json['client_secret'];
  }
  String? clientSecret;
Data copyWith({  String? clientSecret,
}) => Data(  clientSecret: clientSecret ?? this.clientSecret,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['client_secret'] = clientSecret;
    return map;
  }

}
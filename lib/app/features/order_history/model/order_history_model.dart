class OrderHistoryModel {
  OrderHistoryModel({
      this.statusCode, 
      this.status, 
      this.msgCode, 
      this.msg, 
      this.data,});

  OrderHistoryModel.fromJson(dynamic json) {
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
      this.orders, 
      this.pagination,});

  Data.fromJson(dynamic json) {
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(Orders.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<Orders>? orders;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }

}

class Pagination {
  Pagination({
      this.total, 
      this.page, 
      this.limit, 
      this.totalPages,});

  Pagination.fromJson(dynamic json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }
  num? total;
  num? page;
  num? limit;
  num? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    return map;
  }

}

class Orders {
  Orders({
      this.id, 
      this.userId, 
      this.deliveryType, 
      this.deliveryCharge, 
      this.serviceFee, 
      this.subTotal, 
      this.tipAmount, 
      this.totalAmount, 
      this.orderStatus, 
      this.paymentStatus, 
      this.lat, 
      this.long, 
      this.confirmedAt, 
      this.confirmationPin, 
      this.createdAt, 
      this.orderNumber, 
      this.driverId, 
      this.user, 
      this.itemsCount,});

  Orders.fromJson(dynamic json) {
    id = json['_id'];
    userId = json['userId'];
    deliveryType = json['deliveryType'];
    deliveryCharge = json['deliveryCharge'];
    serviceFee = json['serviceFee'];
    subTotal = json['subTotal'];
    tipAmount = json['tipAmount'];
    totalAmount = json['totalAmount'];
    orderStatus = json['orderStatus'];
    paymentStatus = json['paymentStatus'];
    lat = json['lat'];
    long = json['long'];
    confirmedAt = json['confirmedAt'];
    confirmationPin = json['confirmationPin'];
    createdAt = json['createdAt'];
    orderNumber = json['orderNumber'];
    driverId = json['driverId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    itemsCount = json['itemsCount'];
  }
  String? id;
  String? userId;
  String? deliveryType;
  num? deliveryCharge;
  num? serviceFee;
  num? subTotal;
  num? tipAmount;
  num? totalAmount;
  String? orderStatus;
  String? paymentStatus;
  String? lat;
  String? long;
  String? confirmedAt;
  String? confirmationPin;
  String? createdAt;
  String? orderNumber;
  String? driverId;
  User? user;
  num? itemsCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['userId'] = userId;
    map['deliveryType'] = deliveryType;
    map['deliveryCharge'] = deliveryCharge;
    map['serviceFee'] = serviceFee;
    map['subTotal'] = subTotal;
    map['tipAmount'] = tipAmount;
    map['totalAmount'] = totalAmount;
    map['orderStatus'] = orderStatus;
    map['paymentStatus'] = paymentStatus;
    map['lat'] = lat;
    map['long'] = long;
    map['confirmedAt'] = confirmedAt;
    map['confirmationPin'] = confirmationPin;
    map['createdAt'] = createdAt;
    map['orderNumber'] = orderNumber;
    map['driverId'] = driverId;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['itemsCount'] = itemsCount;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.fullName, 
      this.mobile, 
      this.email, 
      this.profileimage,});

  User.fromJson(dynamic json) {
    id = json['_id'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
    profileimage = json['profileimage'];
  }
  String? id;
  String? fullName;
  String? mobile;
  String? email;
  String? profileimage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['fullName'] = fullName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['profileimage'] = profileimage;
    return map;
  }

}
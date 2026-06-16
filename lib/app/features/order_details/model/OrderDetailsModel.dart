class OrderDetailsModel {
  OrderDetailsModel({
      this.statusCode, 
      this.status, 
      this.msgCode, 
      this.msg, 
      this.data,});

  OrderDetailsModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    status = json['status'];
    msgCode = json['msgCode'];
    msg = json['msg'];
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
  }
  num? statusCode;
  String? status;
  String? msgCode;
  String? msg;
  OrderData? data;

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

class OrderData {
  OrderData({
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
      this.deliveredAt, 
      this.hasOpenIssue, 
      this.deliveryProofImage, 
      this.deliveryServiceCharge, 
      this.driverEarning, 
      this.createdAt, 
      this.updatedAt, 
      this.orderNumber, 
      this.v, 
      this.driverId, 
      this.items, 
      this.reports, 
      this.user,});

  OrderData.fromJson(dynamic json) {
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
    deliveredAt = json['deliveredAt'];
    hasOpenIssue = json['hasOpenIssue'];
    deliveryProofImage = json['deliveryProofImage'];
    deliveryServiceCharge = json['deliveryServiceCharge'];
    driverEarning = json['driverEarning'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderNumber = json['orderNumber'];
    v = json['__v'];
    driverId = json['driverId'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    // if (json['reports'] != null) {
    //   reports = [];
    //   json['reports'].forEach((v) {
    //     reports?.add(Dynamic.fromJson(v));
    //   });
    // }
    user = json['driver'] != null ? User.fromJson(json['driver']) : null;
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
  dynamic deliveredAt;
  bool? hasOpenIssue;
  String? deliveryProofImage;
  num? deliveryServiceCharge;
  num? driverEarning;
  String? createdAt;
  String? updatedAt;
  String? orderNumber;
  num? v;
  String? driverId;
  List<Items>? items;
  List<dynamic>? reports;
  User? user;

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
    map['deliveredAt'] = deliveredAt;
    map['hasOpenIssue'] = hasOpenIssue;
    map['deliveryProofImage'] = deliveryProofImage;
    map['deliveryServiceCharge'] = deliveryServiceCharge;
    map['driverEarning'] = driverEarning;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['orderNumber'] = orderNumber;
    map['__v'] = v;
    map['driverId'] = driverId;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (reports != null) {
      map['reports'] = reports?.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      map['driver'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.fullName, 
      this.mobile, 
      this.email,});

  User.fromJson(dynamic json) {
    id = json['_id'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
  }
  String? id;
  String? fullName;
  String? mobile;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['fullName'] = fullName;
    map['mobile'] = mobile;
    map['email'] = email;
    return map;
  }

}

class Items {
  Items({
      this.id, 
      this.orderId, 
      this.itemName, 
      this.des, 
      this.price, 
      this.link, 
      this.image, 
      this.qty, 
      this.fuelQty, 
      this.itemType, 
      this.v, 
      this.createdAt, 
      this.updatedAt,});

  Items.fromJson(dynamic json) {
    id = json['_id'];
    orderId = json['orderId'];
    itemName = json['itemName'];
    des = json['des'];
    price = json['price'];
    link = json['link'];
    image = json['image'];
    qty = json['qty'];
    fuelQty = json['fuelQty'];
    itemType = json['itemType'];
    v = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? id;
  String? orderId;
  String? itemName;
  String? des;
  num? price;
  dynamic link;
  dynamic image;
  num? qty;
  String? fuelQty;
  String? itemType;
  num? v;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['orderId'] = orderId;
    map['itemName'] = itemName;
    map['des'] = des;
    map['price'] = price;
    map['link'] = link;
    map['image'] = image;
    map['qty'] = qty;
    map['fuelQty'] = fuelQty;
    map['itemType'] = itemType;
    map['__v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}
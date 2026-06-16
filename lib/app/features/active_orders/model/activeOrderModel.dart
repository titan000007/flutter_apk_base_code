class ActiveOrderModel {
  ActiveOrderModel({
      this.statusCode, 
      this.status, 
      this.msgCode, 
      this.msg, 
      this.data,});

  ActiveOrderModel.fromJson(dynamic json) {
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
ActiveOrderModel copyWith({  num? statusCode,
  String? status,
  String? msgCode,
  String? msg,
  Data? data,
}) => ActiveOrderModel(  statusCode: statusCode ?? this.statusCode,
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
      this.orders, 
      this.pagination,});

  Data.fromJson(dynamic json) {
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(ActiveOrders.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  List<ActiveOrders>? orders;
  Pagination? pagination;
Data copyWith({  List<ActiveOrders>? orders,
  Pagination? pagination,
}) => Data(  orders: orders ?? this.orders,
  pagination: pagination ?? this.pagination,
);
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
Pagination copyWith({  num? total,
  num? page,
  num? limit,
  num? totalPages,
}) => Pagination(  total: total ?? this.total,
  page: page ?? this.page,
  limit: limit ?? this.limit,
  totalPages: totalPages ?? this.totalPages,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['page'] = page;
    map['limit'] = limit;
    map['totalPages'] = totalPages;
    return map;
  }

}

class ActiveOrders {
  ActiveOrders({
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
      this.confirmationPin, 
      this.deliveryProofImage, 
      this.deliveryServiceCharge, 
      this.driverEarning, 
      this.createdAt, 
      this.updatedAt, 
      this.orderNumber, 
      this.v, 
      this.driverId, 
      this.itemsCount, 
      this.driver,});

  ActiveOrders.fromJson(dynamic json) {
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
    confirmationPin = json['confirmationPin'];
    deliveryProofImage = json['deliveryProofImage'];
    deliveryServiceCharge = json['deliveryServiceCharge'];
    driverEarning = json['driverEarning'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderNumber = json['orderNumber'];
    v = json['__v'];
    driverId = json['driverId'];
    itemsCount = json['itemsCount'];
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
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
  String? confirmationPin;
  String? deliveryProofImage;
  num? deliveryServiceCharge;
  num? driverEarning;
  String? createdAt;
  String? updatedAt;
  String? orderNumber;
  num? v;
  String? driverId;
  num? itemsCount;
  Driver? driver;
ActiveOrders copyWith({  String? id,
  String? userId,
  String? deliveryType,
  num? deliveryCharge,
  num? serviceFee,
  num? subTotal,
  num? tipAmount,
  num? totalAmount,
  String? orderStatus,
  String? paymentStatus,
  String? lat,
  String? long,
  String? confirmedAt,
  dynamic deliveredAt,
  bool? hasOpenIssue,
  String? confirmationPin,
  String? deliveryProofImage,
  num? deliveryServiceCharge,
  num? driverEarning,
  String? createdAt,
  String? updatedAt,
  String? orderNumber,
  num? v,
  String? driverId,
  num? itemsCount,
  Driver? driver,
}) => ActiveOrders(  id: id ?? this.id,
  userId: userId ?? this.userId,
  deliveryType: deliveryType ?? this.deliveryType,
  deliveryCharge: deliveryCharge ?? this.deliveryCharge,
  serviceFee: serviceFee ?? this.serviceFee,
  subTotal: subTotal ?? this.subTotal,
  tipAmount: tipAmount ?? this.tipAmount,
  totalAmount: totalAmount ?? this.totalAmount,
  orderStatus: orderStatus ?? this.orderStatus,
  paymentStatus: paymentStatus ?? this.paymentStatus,
  lat: lat ?? this.lat,
  long: long ?? this.long,
  confirmedAt: confirmedAt ?? this.confirmedAt,
  deliveredAt: deliveredAt ?? this.deliveredAt,
  hasOpenIssue: hasOpenIssue ?? this.hasOpenIssue,
  confirmationPin: confirmationPin ?? this.confirmationPin,
  deliveryProofImage: deliveryProofImage ?? this.deliveryProofImage,
  deliveryServiceCharge: deliveryServiceCharge ?? this.deliveryServiceCharge,
  driverEarning: driverEarning ?? this.driverEarning,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
  orderNumber: orderNumber ?? this.orderNumber,
  v: v ?? this.v,
  driverId: driverId ?? this.driverId,
  itemsCount: itemsCount ?? this.itemsCount,
  driver: driver ?? this.driver,
);
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
    map['confirmationPin'] = confirmationPin;
    map['deliveryProofImage'] = deliveryProofImage;
    map['deliveryServiceCharge'] = deliveryServiceCharge;
    map['driverEarning'] = driverEarning;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['orderNumber'] = orderNumber;
    map['__v'] = v;
    map['driverId'] = driverId;
    map['itemsCount'] = itemsCount;
    if (driver != null) {
      map['driver'] = driver?.toJson();
    }
    return map;
  }

}

class Driver {
  Driver({
      this.id, 
      this.fullName, 
      this.profileimage,
      this.mobile,
      this.email,});

  Driver.fromJson(dynamic json) {
    id = json['_id'];
    fullName = json['fullName'];
    profileimage = json['profileimage'];
    mobile = json['mobile'];
    email = json['email'];
  }
  String? id;
  String? fullName;
  String? profileimage;
  String? mobile;
  String? email;

Driver copyWith({  String? id,
  String? fullName,
  String? mobile,
  String? email,
}) => Driver(  id: id ?? this.id,
  fullName: fullName ?? this.fullName,
  mobile: mobile ?? this.mobile,
  email: email ?? this.email,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['fullName'] = fullName;
    map['mobile'] = mobile;
    map['email'] = email;
    return map;
  }

}
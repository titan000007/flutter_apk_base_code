class CreateOrderModel {
  CreateOrderModel({
    this.statusCode,
    this.status,
    this.msgCode,
    this.msg,
    this.data,});

  CreateOrderModel.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    status = json['status'];
    msgCode = json['msgCode'];
    msg = json['msg'];
    data = json['data'] != null ? CreateOrderData.fromJson(json['data']) : null;
  }
  num? statusCode;
  String? status;
  String? msgCode;
  String? msg;
  CreateOrderData? data;
  CreateOrderModel copyWith({  num? statusCode,
    String? status,
    String? msgCode,
    String? msg,
    CreateOrderData? data,
  }) => CreateOrderModel(  statusCode: statusCode ?? this.statusCode,
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

class CreateOrderData {
  CreateOrderData({
    this.order,
    this.items,});

  CreateOrderData.fromJson(dynamic json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }
  Order? order;
  List<Items>? items;
  CreateOrderData copyWith({  Order? order,
    List<Items>? items,
  }) => CreateOrderData(  order: order ?? this.order,
    items: items ?? this.items,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (order != null) {
      map['order'] = order?.toJson();
    }
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Items {
  Items({
    this.orderId,
    this.itemName,
    this.des,
    this.price,
    this.link,
    this.image,
    this.qty,
    this.fuelQty,
    this.itemType,
    this.id,
    this.v,
    this.createdAt,
    this.updatedAt,});

  Items.fromJson(dynamic json) {
    orderId = json['orderId'];
    itemName = json['itemName'];
    des = json['des'];
    price = json['price'];
    link = json['link'];
    image = json['image'];
    qty = json['qty'];
    fuelQty = json['fuelQty'];
    itemType = json['itemType'];
    id = json['_id'];
    v = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  String? orderId;
  String? itemName;
  String? des;
  num? price;
  String? link;
  dynamic image;
  num? qty;
  String? fuelQty;
  String? itemType;
  String? id;
  num? v;
  String? createdAt;
  String? updatedAt;
  Items copyWith({  String? orderId,
    String? itemName,
    String? des,
    num? price,
    String? link,
    dynamic image,
    num? qty,
    String? fuelQty,
    String? itemType,
    String? id,
    num? v,
    String? createdAt,
    String? updatedAt,
  }) => Items(  orderId: orderId ?? this.orderId,
    itemName: itemName ?? this.itemName,
    des: des ?? this.des,
    price: price ?? this.price,
    link: link ?? this.link,
    image: image ?? this.image,
    qty: qty ?? this.qty,
    fuelQty: fuelQty ?? this.fuelQty,
    itemType: itemType ?? this.itemType,
    id: id ?? this.id,
    v: v ?? this.v,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderId'] = orderId;
    map['itemName'] = itemName;
    map['des'] = des;
    map['price'] = price;
    map['link'] = link;
    map['image'] = image;
    map['qty'] = qty;
    map['fuelQty'] = fuelQty;
    map['itemType'] = itemType;
    map['_id'] = id;
    map['__v'] = v;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

}

class Order {
  Order({
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
    this.id,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,});

  Order.fromJson(dynamic json) {
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
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderNumber = json['orderNumber'];
    v = json['__v'];
  }
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
  dynamic confirmationPin;
  String? deliveryProofImage;
  num? deliveryServiceCharge;
  num? driverEarning;
  String? id;
  String? createdAt;
  String? updatedAt;
  String? orderNumber;
  num? v;
  Order copyWith({  String? userId,
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
    dynamic confirmationPin,
    String? deliveryProofImage,
    num? deliveryServiceCharge,
    num? driverEarning,
    String? id,
    String? createdAt,
    String? updatedAt,
    String? orderNumber,
    num? v,
  }) => Order(  userId: userId ?? this.userId,
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
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    orderNumber: orderNumber ?? this.orderNumber,
    v: v ?? this.v,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['orderNumber'] = orderNumber;
    map['__v'] = v;
    return map;
  }

}
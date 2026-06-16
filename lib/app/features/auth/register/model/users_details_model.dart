class UserDetails {
  String? sId;
  String? fullName;
  String? fcmToken;
  String? mobile;
  String? email;
  String? password;
  String? profileimage;
  String? deliveryType;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  UserDetails({
    this.sId,
    this.fullName,
    this.mobile,
    this.fcmToken,
    this.email,
    this.password,
    this.profileimage,
    this.deliveryType,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,

  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    profileimage = json['profileimage'];
    deliveryType = json['deliveryType'];
    status = json['status'];
    fcmToken = json['fcmToken'];
    deletedAt = json['deleted_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

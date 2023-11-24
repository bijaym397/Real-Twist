class LoginDataResponse {
  String? message;
  int? status;
  LoginRecord? data;

  LoginDataResponse({this.message, this.status, this.data});

  LoginDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new LoginRecord.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginRecord {
  String? sId;
  String? userId;
  int? iV;
  String? authToken;
  String? createdAt;
  String? updatedAt;
  User? user;

  LoginRecord(
      {this.sId,
        this.userId,
        this.iV,
        this.authToken,
        this.createdAt,
        this.updatedAt,
        this.user});

  LoginRecord.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    iV = json['__v'];
    authToken = json['authToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['authToken'] = this.authToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? phoneNumber;
  String? password;
  String? countryCode;
  String? userCode;
  int? verificationCode;
  int? totalCoins;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? userType;

  User(
      {this.sId,
        this.name,
        this.phoneNumber,
        this.password,
        this.countryCode,
        this.userCode,
        this.verificationCode,
        this.totalCoins,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userType});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    countryCode = json['countryCode'];
    userCode = json['userCode'];
    verificationCode = json['verificationCode'];
    totalCoins = json['totalCoins'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['countryCode'] = this.countryCode;
    data['userCode'] = this.userCode;
    data['verificationCode'] = this.verificationCode;
    data['totalCoins'] = this.totalCoins;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['userType'] = this.userType;
    return data;
  }
}

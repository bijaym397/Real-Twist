class UserApiResponse {
  String? message;
  int? status;
  UserData? data;

  UserApiResponse({this.message, this.status, this.data});

  UserApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
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

class UserData {
  String? sId;
  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? countryCode;
  String? userCode;
  int? verificationCode;
  int? totalCoins;
  bool? status;
  String? userType;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.sId,
        this.name,
        this.email,
        this.phoneNumber,
        this.password,
        this.countryCode,
        this.userCode,
        this.verificationCode,
        this.totalCoins,
        this.status,
        this.userType,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    countryCode = json['countryCode'];
    userCode = json['userCode'];
    verificationCode = json['verificationCode'];
    totalCoins = json['totalCoins'];
    status = json['status'];
    userType = json['userType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['countryCode'] = this.countryCode;
    data['userCode'] = this.userCode;
    data['verificationCode'] = this.verificationCode;
    data['totalCoins'] = this.totalCoins;
    data['status'] = this.status;
    data['userType'] = this.userType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
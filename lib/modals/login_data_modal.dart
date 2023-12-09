class LoginDataResponse {
  String? message;
  int? status;
  LoginRecord? data;

  LoginDataResponse({this.message, this.status, this.data});

  LoginDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? LoginRecord.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
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
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  LoginRecord({
    required this.sId,
    required this.userId,
    required this.iV,
    required this.authToken,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory LoginRecord.fromJson(Map<String, dynamic> json) {
    return LoginRecord(
      sId: json['_id'],
      userId: json['userId'],
      iV: json['__v'],
      authToken: json['authToken'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'userId': userId,
      '__v': iV,
      'authToken': authToken,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}

class User {
  String? sId;
  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? countryCode;
  String? userCode;
  int? verificationCode;
  double? totalCoins;
  bool? status;
  String? userType;
  DateTime? userCreatedAt;
  DateTime? userUpdatedAt;
  String? customerId;
  String? userReferralId;

  User({
    required this.sId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.countryCode,
    required this.userCode,
    required this.verificationCode,
    required this.totalCoins,
    required this.status,
    required this.userType,
    required this.userCreatedAt,
    required this.userUpdatedAt,
    required this.customerId,
    required this.userReferralId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sId: json['_id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      countryCode: json['countryCode'],
      userCode: json['userCode'],
      verificationCode: json['verificationCode'],
      totalCoins: json['totalCoins'],
      status: json['status'],
      userType: json['userType'],
      userCreatedAt: DateTime.parse(json['createdAt']),
      userUpdatedAt: DateTime.parse(json['updatedAt']),
      customerId: json['customerId'],
      userReferralId: json['userReferralId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
    '_id': sId,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'countryCode': countryCode,
    'userCode': userCode,
    'verificationCode': verificationCode,
    'totalCoins': totalCoins,
    'status': status,
    'userType': userType,
    'createdAt': userCreatedAt?.toIso8601String(),
    'updatedAt': userUpdatedAt?.toIso8601String(),
    'customerId': customerId,
    'userReferralId': userReferralId,
    };
  }
}

class TotalCoins {
  String? numberDecimal;

  TotalCoins({required this.numberDecimal});

  factory TotalCoins.fromJson(Map<String, dynamic> json) {
    return TotalCoins(
      numberDecimal: json["\$numberDecimal"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "\$numberDecimal": numberDecimal,
    };
  }
}

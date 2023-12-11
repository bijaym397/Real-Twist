import 'login_data_modal.dart';

class HomeDetailsResponse {
  String? message;
  int? status;
  HomeData? data;

  HomeDetailsResponse({this.message, this.status, this.data});

  HomeDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? HomeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class HomeData {
  String? id;
  dynamic? totalInvestment;
  dynamic? totalIncome;
  dynamic? totalCoins;
  dynamic? totalUserCoins;
  int? cra;
  String? appLink;

  HomeData({
    required this.id,
    required this.totalInvestment,
    required this.totalIncome,
    required this.totalCoins,
    required this.totalUserCoins,
    required this.cra,
    required this.appLink,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      id: json['_id'],
      totalInvestment: json['totalInvestment'],
      totalIncome: json['totalIncome'],
      totalCoins: json['totalCoins'],
      totalUserCoins: json['totalUserCoins'],
      cra: json['cra'],
      appLink: json['appLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'totalInvestment': totalInvestment,
      'totalIncome': totalIncome,
      'totalCoins': totalCoins,
      'totalUserCoins': totalUserCoins,
      'cra': cra,
      'appLink': appLink,
    };
  }
}
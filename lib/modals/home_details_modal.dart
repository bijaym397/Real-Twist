class HomeDetailsResponse {
  String? message;
  int? status;
  HomeData? data;

  HomeDetailsResponse({this.message, this.status, this.data});

  HomeDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
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

class HomeData {
  String? sId;
  int? totalInvestment;
  int? totalIncome;
  int? totalCoins;
  int? cra;

  HomeData(
      {this.sId,
        this.totalInvestment,
        this.totalIncome,
        this.totalCoins,
        this.cra});

  HomeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    totalInvestment = json['totalInvestment'];
    totalIncome = json['totalIncome'];
    totalCoins = json['totalCoins'];
    cra = json['cra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['totalInvestment'] = this.totalInvestment;
    data['totalIncome'] = this.totalIncome;
    data['totalCoins'] = this.totalCoins;
    data['cra'] = this.cra;
    return data;
  }
}
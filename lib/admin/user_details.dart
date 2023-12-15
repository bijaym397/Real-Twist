import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/common/my_network.dart';
import 'package:real_twist/home.dart';
import 'package:real_twist/utils/dateFormater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../constants/strings.dart';

class UserDetails extends StatefulWidget {
  final String id;

  const UserDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData(widget.id);
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final apiUrl = Api.baseUrl + Api.getUserDetails + userId;
    final pref = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 200) {
        return data['data'];
      } else {
        throw Exception('Failed to load user details');
      }
    } else {
      debugPrint("fhdsjfhs ${userId}");
      debugPrint("fhdsjfhs ${response.body}");
      throw Exception('Failed to load user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String img = "assets/user.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('User Details'),
      ),
      body: ScaffoldBGImg(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              Map<String, dynamic> user = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white70,
                      ),
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            image: user['name'][0] == ""
                                ? DecorationImage(image: AssetImage(img))
                                : null,
                            color: Colors.pink.shade600,
                            shape: BoxShape.circle),

                        /// Who is this
                        child: user['name'][0] != ""
                            ? Center(
                                child: Text(
                                user['name'][0].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 52),
                              ))
                            : SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildDataRow('Name', user['name']),
                    _buildDataRow('Email', user['email']),
                    _buildDataRow('Phone Number', user['phoneNumber']),
                    _buildDataRow('User Code', user['userCode']),
                    _buildDataRow('User Status',
                        user['status'] == true ? "Active" : "Deactivate"),
                    _buildDataRow('Total Coins', user['totalCoins'].toString()),
                    _buildDataRow(
                        'Total Investment', user['totalInvestment'].toString()),
                    _buildDataRow('Total Income', user['totalIncome'].toString()),
                    _buildDataRow('Join Date', formatDate(user['createdAt'])),
                    const SizedBox(height: 28),
                     /// My Network
            CommonCard(
              onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MyNetworkView(userId : widget.id),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Network",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: Colors.white.withOpacity(.7)),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.double_arrow_rounded)
                ],
              ),
            ),
                    const SizedBox(height: 28),
                    user['payments'].isEmpty ? const SizedBox() :  Text(
                      "User Payment Details",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    user['payments'].isEmpty ? const SizedBox() : Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: ListView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: user['payments'].length,
                        itemBuilder: (BuildContext context, int index) {
                          final status = user['payments'][index]['status'];
                          // Determine the color based on the status
                          Color statusColor = Colors.grey;
                          if (status == 'succeeded') {
                            statusColor = Colors.green;
                          } else if (status == 'unpaid') {
                            statusColor = Colors.red;
                          }

                        return Container(
                          margin: const EdgeInsets.only(top: 12, right: 5, left: 5),
                          child: CommonCard(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetails(id: user['payments'][index]['_id'])));
                            },
                            child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  detailsRow(label: "Buy Coin", data: user['payments'][index]['buyCoin'].toString()),
                                  const SizedBox(height: 6),
                                  detailsRow(label: "Amount", data: user['payments'][index]['amount'].toString()),
                                  const SizedBox(height: 6),
                                  if(user['payments'][index]['paymentType'].toString().isNotEmpty)
                                  detailsRow(label: "Payment Type", data: user['payments'][index]['paymentType'].toString() ?? ""),
                                  const SizedBox(height: 6),
                                  detailsRow(label: "Date", data: formatDate(user['payments'][index]['createdAt'].toString())),
                                  const SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Card(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          'Status: $status',
                                          style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      },),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget detailsRow({String? label, String? data, color}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${label!} : ",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.white,
            )),
        const SizedBox(width: 10),
        Text(data!,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.white,
            )),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$label:  ", style: const TextStyle(fontSize: 18)),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}

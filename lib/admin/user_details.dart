import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      throw Exception('Failed to load user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String img = "assets/user.png";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('User Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
                  const SizedBox(height: 28),
                  const SizedBox(height: 8),
                  const Divider(),
                  const Text(
                    "User Payment Details",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  _buildDataRow('Total Income', user['totalIncome'].toString()),
                  _buildDataRow('Total Coins', user['totalCoins'].toString()),
                  _buildDataRow('Join Date', _formatDate(user['createdAt'])),
                ],
              ),
            );
          }
        },
      ),
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

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

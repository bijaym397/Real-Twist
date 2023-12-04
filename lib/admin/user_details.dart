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

    final apiUrl = Api.baseUrl+Api.getUserDetails+userId;
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataRow('Name', user['name']),
                  _buildDataRow('Email', user['email']),
                  _buildDataRow('Phone Number', user['phoneNumber']),
                  _buildDataRow('Total Coins', user['totalCoins'].toString()),
                  _buildDataRow('Total Investment', user['totalInvestment'].toString()),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
        const Divider(),
      ],
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

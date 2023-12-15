import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api.dart';
import 'package:http/http.dart' as http;

import '../constants/strings.dart';
import '../home.dart';

class NetIncomeView extends StatefulWidget {
  const NetIncomeView({super.key, required this.level, required this.id});

  final String level;
  final dynamic id;

  @override
  State<NetIncomeView> createState() => _NetIncomeViewState();
}

class _NetIncomeViewState extends State<NetIncomeView> {
  List<dynamic> tableData = [];

  _fetchData() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString(AppStrings.spUserId) ?? "";
    final apiUrl = Api.baseUrl + Api.userNetworkIncome + userId;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"userIds": widget.id}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        tableData = jsonData['data'];
      });
    } else {
      throw Exception(response.body);
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${widget.level}"),
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: ScaffoldBGImg(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text("Real Twist Level Chart!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              CommonCard(
                child: DataTable(
                  border: TableBorder.all(),
                  columns: const [
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "User Name",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Inv.RT",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Referral",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ))),
                  ],
                  rows:
                      tableData // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((data) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        data["name"] ?? "",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                    DataCell(SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          data["rewardAmount"] ?? "0",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ))),
                                    DataCell(SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          data["userCode"] ?? "",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ))),
                                  ],
                                )),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> listOfColumns = [
    {"Name": "Bijay", "Inv": "100466640", "ref": "BBB7BB"},
    {"Name": "Rahul", "Inv": "10787770", "ref": "BB8HJG"},
    {"Name": "Aman", "Inv": "10787770", "ref": "BB8H8G"},
    {"Name": "Manish", "Inv": "10787770", "ref": "B78H8G"},
    {"Name": "Aman", "Inv": "10787770", "ref": "BB8H8G"},
    {"Name": "Bijay", "Inv": "100466640", "ref": "BBB7BB"},
    {"Name": "Rahul", "Inv": "10787770", "ref": "BB8HJG"},
    {"Name": "Manish", "Inv": "10787770", "ref": "B78H8G"},
    {"Name": "Aman", "Inv": "10787770", "ref": "BB8H8G"},
    {"Name": "Manish", "Inv": "10787770", "ref": "B78H8G"},
    {"Name": "Aman", "Inv": "10787770", "ref": "BB8H8G"},
    {"Name": "Manish", "Inv": "10787770", "ref": "B78H8G"},
    {"Name": "Aman", "Inv": "10787770", "ref": "BB8H8G"},
    {"Name": "Bijay", "Inv": "100466640", "ref": "BBB7BB"},
    {"Name": "Rahul", "Inv": "10787770", "ref": "BB8HJG"},
    {"Name": "Manish", "Inv": "10787770", "ref": "B78H8G"},
  ];
}

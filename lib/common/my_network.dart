import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api.dart';
import '../constants/strings.dart';
import 'level_chart.dart';
import 'net_income.dart';
import 'package:http/http.dart' as http;

class MyNetworkView extends StatefulWidget {
  final userId;
  const MyNetworkView({super.key, this.userId});

  @override
  State<MyNetworkView> createState() => _MyNetworkViewState();
}

class _MyNetworkViewState extends State<MyNetworkView> {

  List<dynamic> tableData = [];

  _fetchData() async {
    final pref = await SharedPreferences.getInstance();
    // final userId = pref.getString(AppStrings.spUserId) ?? "";
    final apiUrl = Api.baseUrl + Api.userNetwork+widget.userId;
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        tableData = jsonData['data'];
      });
    } else {
      throw Exception('Failed to load data');
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
      appBar: AppBar(title: const Text("My Network"),
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: CommonCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const LevelChartView()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Reward You Can Earn!",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Icon(Icons.arrow_circle_right_outlined),
                  ],
                ),
              ),
            ),
            /*const Padding(
              padding: EdgeInsets.symmetric(vertical: 26),
              child: Text("Net Income : 0",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            ),*/
            tableData.length == 0 ? Padding(
              padding: const EdgeInsets.only(top: 70),
              child: const Center(child: Text("No Data Available",style: TextStyle(fontSize: 26))),
            ) :
            CommonCard(
              // color: Colors.pink.shade200,
              // width: double.infinity,
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            "Levels",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            "Joining",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            "List",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                ],
                rows:
                // Loops through dataColumnText, each iteration assigning the value to element
                tableData.map(
                  ((data) =>
                      DataRow(
                        cells: <DataCell>[
                          DataCell(SizedBox(
                            width: double.infinity,
                            child: Text(
                              "${data["level"]}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          )),
                          DataCell(SizedBox(
                              width: double.infinity,
                              child: Text(
                                "${data["numberOfJoin"] ?? 0}",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ))),
                          DataCell(
                              const SizedBox(
                                width: double.infinity,
                                child: Icon(
                                    Icons.arrow_circle_right_outlined),
                              ), onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NetIncomeView(level:"${data["level"]}",id: data["userIds"],)),
                            );
                          }),
                        ],
                      )),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
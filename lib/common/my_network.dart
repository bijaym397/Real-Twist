import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_twist/home.dart';
import '../constants/api.dart';
import 'level_chart.dart';
import 'net_income.dart';
import 'package:http/http.dart' as http;

class MyNetworkView extends StatefulWidget {
  const MyNetworkView({super.key});

  @override
  State<MyNetworkView> createState() => _MyNetworkViewState();
}

class _MyNetworkViewState extends State<MyNetworkView> {

  List<dynamic> tableData = [];

  _fetchData() async {
    const apiUrl = Api.baseUrl+Api.userNetwork;
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        tableData =jsonData['data'];
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
        padding:  const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: CommonCard(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const LevelChartView(id: "user id",)),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Investment",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Text("21654845564",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    Icon(Icons.arrow_circle_right_outlined),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 26),
              child: Text("Net Income : 0",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            ),
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
                          ((data) => DataRow(
                                cells: <DataCell>[
                                  DataCell(SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "Level ${data["level"]}",
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
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //            NetIncomeView(id: data["Name"]!,)),
                                    // );
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

  final List<Map<String, String>> listOfColumns = [
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"},
  ];
}

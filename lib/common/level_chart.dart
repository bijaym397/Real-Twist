import 'package:flutter/material.dart';
import 'package:real_twist/home.dart';

class LevelChartView extends StatefulWidget {
  const LevelChartView({super.key, required this.id});

  final dynamic id;

  @override
  State<LevelChartView> createState() => _LevelChartViewState();
}

class _LevelChartViewState extends State<LevelChartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Real Twist"),
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,),
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("Reward You Can Earn!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            CommonCard(
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            "Invest Rs",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            "Reward Rs",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                            "Reward Day",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                ],
                rows:
                listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                  ((data) => DataRow(
                    cells: <DataCell>[
                      DataCell(SizedBox(
                        width: double.infinity,
                        child: Text(
                          data["invested"] ?? "",
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
                            "=> ${data["reward"]}" ?? "",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                      DataCell(SizedBox(
                          width: double.infinity,
                          child: Text(
                            data["day"] ?? "",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                    ],
                  )),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> listOfColumns = [
    {"invested": "14999 - 74998", "reward": "1099", "day": "8"},
    {"invested": "74999 - 374998", "reward": "2499", "day": "25"},
    {"invested": "374999 - 1874998", "reward": "4999", "day": "75"},
    {"invested": "1874998 - 9374998", "reward": "14999", "day": "225"},
    {"invested": "9374998 - 46874998", "reward": "59999", "day": "675"},
    {"invested": "46874999 - 234374998", "reward": "159999", "day": "2000"},
    {"invested": "More than 234374998", "reward": "359999", "day": "6000"},
    // {"invested": "Manish", "reward": "10787770", "day": "B78H8G"},
    // {"invested": "Aman", "reward": "10787770", "day": "BB8H8G"},
    // {"invested": "Manish", "reward": "10787770", "day": "B78H8G"},
    // {"invested": "Aman", "reward": "10787770", "day": "BB8H8G"},
    // {"invested": "Manish", "reward": "10787770", "day": "B78H8G"},
    // {"invested": "Aman", "reward": "10787770", "day": "BB8H8G"},
    // {"invested": "Bijay", "reward": "100466640", "day": "BBB7BB"},
    // {"invested": "Rahul", "reward": "10787770", "day": "BB8HJG"},
    // {"invested": "Manish", "reward": "10787770", "day": "B78H8G"},
  ];
}


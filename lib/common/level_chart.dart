import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text(widget.id.toString() ?? "000")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("Net Income : 0",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              color: Colors.pink.shade200,
              width: double.infinity,
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
                listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                  ((data) => DataRow(
                    cells: <DataCell>[
                      DataCell(SizedBox(
                        width: double.infinity,
                        child: Text(
                          data["Name"] ?? "",
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
                            data["Inv"] ?? "",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                      DataCell(SizedBox(
                          width: double.infinity,
                          child: Text(
                            data["ref"] ?? "",
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


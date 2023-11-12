import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;

  List<int> items = [10, 5, 20, -10, -5, 15, 2, 0, 25, -15];

  late SharedPreferences prefs;
  bool hasPlayedToday = false;

  Future<void> _checkIfPlayedToday() async {
    prefs = await SharedPreferences.getInstance();
    final lastPlayDate = prefs.getString('last_play_date');

    if (lastPlayDate != null) {
      final currentDate = DateTime.now();
      final lastDate = DateTime.parse(lastPlayDate);

      // Check if the last play date is the same day as today
      hasPlayedToday = currentDate.year == lastDate.year &&
          currentDate.month == lastDate.month &&
          currentDate.day == lastDate.day;
    }
  }

  Future<void> _updateLastPlayDate() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('last_play_date', DateTime.now().toIso8601String());
  }

  @override
  void initState() {
    super.initState();
    _checkIfPlayedToday();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  Future<int> _spinCoinApi() async {
    const apiUrl = '{{host}}spincoin';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: '{"coinNumbers":$items}',
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['selectedNumber'] ?? 0;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: [
                  for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                    FortuneItem(
                        child: Text(
                          items[i].toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                    )
                  },
                ],
                onAnimationEnd: () async{
                  setState(() {
                    rewards = items[selected.value];
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "You just won $rewards Points!"),
                    ),
                  );
                  await _updateLastPlayDate();
                },
              ),
            ),
            const SizedBox(height: 35,),
            GestureDetector(
              onTap: () async{
                if (!hasPlayedToday) {
                  final selectedNumber = await _spinCoinApi();
                  setState(() {
                    selected.value = items.indexOf(selectedNumber);
                  });
                } else {
                  // User has already played today
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You have already played today."),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: 130,
                decoration:  BoxDecoration(color: !hasPlayedToday ? Colors.redAccent : Colors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child: const Center(
                  child: Text("SPIN"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

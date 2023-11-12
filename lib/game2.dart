import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberSpinner extends StatefulWidget {
  const NumberSpinner({Key? key}) : super(key: key);

  @override
  _NumberSpinnerState createState() => _NumberSpinnerState();
}

class _NumberSpinnerState extends State<NumberSpinner> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  int selectedNumber = 0;
  int spendCoin = 5;
  bool canPlay = true;
  late SharedPreferences prefs;

  List<int> availableNumbers = [10, 5, 20, 18, 12, 15, 2, 0, 25, 8];

  @override
  void initState() {
    super.initState();
    _checkCanPlay();
  }

  Future<void> _checkCanPlay() async {
    prefs = await SharedPreferences.getInstance();
    final lastPlayDate = prefs.getString('last_play_date');

    if (lastPlayDate != null) {
      final currentDate = DateTime.now();
      final lastDate = DateTime.parse(lastPlayDate);

      // Check if at least 30 minutes have passed since the last play
      canPlay = currentDate.difference(lastDate).inMinutes >= 30;
    }
  }

  Future<void> _updateLastPlayDate() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('last_play_date', DateTime.now().toIso8601String());
  }

  Future<void> _spinCoinApi() async {
    final apiUrl = '{{host}}spincoin/spend';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'selectNumber': selectedNumber,
        'spendCoin': spendCoin,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final selectedNumberFromApi = jsonResponse['selectedNumber'] ?? 0;
      selected.value = availableNumbers.indexOf(selectedNumberFromApi);
      setState(() {
        rewards = selectedNumberFromApi;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You just won $rewards Points!"),
        ),
      );
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
            // Dropdown to select point value
            DropdownButton<int>(
              value: spendCoin,
              items: [5, 10, 15, 20, 25].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value Points'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  spendCoin = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            // List of available numbers
            Wrap(
              spacing: 10,
              children: availableNumbers
                  .getRange(0,4)
                  .map((number) => ElevatedButton(
                onPressed: canPlay
                    ? () async{
                  if (canPlay) {
                     await _spinCoinApi();
                  } else {
                    // User has already played today
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please wait for some time."),
                      ),
                    );
                  }
                } : null,
                child: Text('$number'),
              ))
                  .toList(),
            ),
            const SizedBox(height: 25),
            // FortuneWheel for spinning numbers
            SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: [
                  for (int number in availableNumbers) ...<FortuneItem>{
                    FortuneItem(
                      child: Text(
                        number.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  },
                ],
                onAnimationEnd: () {
                  if (canPlay) {
                    _updateLastPlayDate();
                    _checkCanPlay(); // Check again after playing
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

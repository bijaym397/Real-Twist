import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;

  bool isApiCallInProgress = false;

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
    setState(() {
      isApiCallInProgress = true;
    });

    final pref = await SharedPreferences.getInstance();

    try {
      const apiUrl = 'http://178.16.138.186:5000/api/spincoin';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': pref.getString(AppStrings.spAuthToken) ?? "",
        },
        body: '{"coinNumbers":$items}',
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['selectedNumber'] ?? 0;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data'),
          ),
        );
        return 0;
      }
    } finally {
      setState(() {
        isApiCallInProgress = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        title: const Text("Game One"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black87,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(200.0),
                ),
                height: 300,
                width: 300,
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black.withAlpha(100), // Shadow color
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 10.0, // Spread of the shadow
                        spreadRadius: 5.0, // Expansion of the shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(200.0),
                  ),
                  child: FortuneWheel(
                    selected: selected.stream,
                    animateFirst: false,
                    items : List.generate(items.length, (index) =>
                        FortuneItem(
                          child: Container(
                            color: index.isEven ? Colors.pink.shade900 : Colors.pinkAccent.shade100, // Set background color based on condition
                            child: Center(
                              child: Text(
                                items[index].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ),
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
              ),
              const SizedBox(height: 35,),
              ElevatedButton(
                onPressed: !hasPlayedToday && !isApiCallInProgress
                    ? () async {
                  final selectedNumber = await _spinCoinApi();
                  setState(() {
                    selected.value = items.indexOf(selectedNumber);
                  });
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: !hasPlayedToday && !isApiCallInProgress
                      ? Colors.white
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: 130,
                  alignment: Alignment.center,
                  child: const Text("SPIN", style: TextStyle(color: Colors.black87),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

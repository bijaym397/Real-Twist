import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';

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
  bool isApiCallInProgress = false;

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
    setState(() {
      isApiCallInProgress = true;
    });

    final pref = await SharedPreferences.getInstance();
    try {
      const apiUrl = 'http://178.16.138.186:5000/api/spincoin/spend';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': pref.getString(AppStrings.spAuthToken) ?? "",
        },
        body: jsonEncode({
          'selectNumber': selectedNumber,
          'spendCoin': spendCoin,
        }),
      );

       final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        // final selectedNumberFromApi = jsonResponse['selectedNumber'] ?? 0;
        // selected.value = availableNumbers.indexOf(selectedNumberFromApi);
        setState(() {
          rewards = spendCoin * 2;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You just won $rewards Points!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['message'] ?? "Error while loading data"),
          ),
        );
      }
    } catch (e) {
      // Handle API call error
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(e.toString()),
        ),
      );
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
        title: const Text("Game Two"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dropdown to select point value
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white, // Outline color
                    width: 2.0, // Outline width
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<int>(
                  value: spendCoin,
                  items: [5, 10, 15, 20, 25].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value Points'),
                    );
                  }).toList(),
                  onChanged: isApiCallInProgress
                      ? null
                      : (int? newValue) {
                    setState(() {
                      spendCoin = newValue!;
                    });
                  },
                  underline: Container(), // Remove the default underline
                ),
              ),
              const SizedBox(height: 30),
              // Casino-style board
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
                    borderRadius: BorderRadius.circular(200.0),
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black.withAlpha(100), // Shadow color
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 10.0, // Spread of the shadow
                        spreadRadius: 5.0, // Expansion of the shadow
                      ),
                    ],
                  ),
                  child: FortuneWheel(
                    selected: selected.stream,
                    animateFirst: false,
                    items : List.generate(availableNumbers.length, (index) =>
                        FortuneItem(
                          child: Container(
                            color: index.isEven ? Colors.pink.shade900 : Colors.pinkAccent.shade100,  // Set background color based on condition
                            child: Center(
                              child: Text(
                                availableNumbers[index].toString(),
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
                    onAnimationEnd: () {
                      if (canPlay) {
                        _updateLastPlayDate();
                        _checkCanPlay(); // Check again after playing
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),
              Wrap(
                spacing: 10,
                children: availableNumbers
                    .getRange(0, 4)
                    .map((number) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isApiCallInProgress
                        ? Colors.white
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isApiCallInProgress
                      ? null
                      : () async {
                    if (canPlay) {
                      await _spinCoinApi();
                    } else {
                      // User has already played today
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please wait for some time."),
                        ),
                      );
                    }
                  },
                  child: Text('$number', style: const TextStyle(color: Colors.black87),),
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


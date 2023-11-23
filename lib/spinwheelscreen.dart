import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:real_twist/utils/blinking_border_container.dart';
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
    _checkIfPlayedToday();
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

  _spinCoinApi() async {
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
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        await _updateLastPlayDate();
        setState(() {
          selected.value = items.indexOf(jsonResponse["data"]['selectedNumber'] ?? 0);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "You won $rewards Points!"),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['message'] ?? 'Failed to load data'),
          ),
        );
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
        title: const Text("Play and win"),
        centerTitle: true,
      ),
      body: BlinkingBorderContainer(
        backgroundImage: "assets/casio_table.jpg",
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height:  MediaQuery.of(context).size.width * 0.80,
                      width: MediaQuery.of(context).size.width * 0.80,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color:  const Color(0xFF3A2222),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.80/2),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage('assets/mica_board.jpg'),
                              fit: BoxFit.cover,
                              opacity: 0.5
                          ),
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.80/2),
                        ),
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
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.80/2),
                          ),
                          child: FortuneWheel(
                            selected: selected.stream,
                            animateFirst: false,
                            items : List.generate(items.length, (index) =>
                                FortuneItem(
                                  child: Container(
                                    color: items[index] == 0 ? Colors.green.shade800 : index.isEven ? Colors.red.shade400 : Colors.black87,                        child: Center(
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
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.80,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Center(
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(100),
                                // Shadow color
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                // Spread of the shadow
                                spreadRadius: 5.0, // Expansion of the shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 35,),
                ElevatedButton(
                  onPressed: !hasPlayedToday && !isApiCallInProgress
                      ? () {_spinCoinApi();}
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !hasPlayedToday && !isApiCallInProgress
                        ? Colors.white
                        : Colors.white.withAlpha(150),
                    foregroundColor: Colors.black87,
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
      ),
    );
  }
}

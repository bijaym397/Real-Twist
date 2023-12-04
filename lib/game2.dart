import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/utils/blinking_border_container.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/api.dart';
import 'constants/strings.dart';

class NumberSpinner extends StatefulWidget {
  const NumberSpinner({Key? key}) : super(key: key);

  @override
  _NumberSpinnerState createState() => _NumberSpinnerState();
}

class _NumberSpinnerState extends State<NumberSpinner> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  int spendCoin = 5;
  bool canPlay = true;
  late SharedPreferences prefs;
  bool isApiCallInProgress = false;
  int? numberSelectedByUser;



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

      // Check if at least 30 seconds have passed since the last play
      canPlay = currentDate.difference(lastDate).inSeconds >= 30;
    }
  }

  Future<void> _updateLastPlayDate() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('last_play_date', DateTime.now().toIso8601String());
  }

  _spinnerLoading() async{
    final random = Random();
    await Future.delayed(const Duration(milliseconds: 500));
    selected.add(random.nextInt(99));
  }


  Future<void> _spinCoinApi(String gameType) async {
    setState(() {
      isApiCallInProgress = true;
    });

    //showLoaderDialog(context);
    _spinnerLoading();

    final pref = await SharedPreferences.getInstance();
    try {
      const apiUrl = Api.baseUrl+Api.spendCoin;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'token': pref.getString(AppStrings.spAuthToken) ?? "",
        },
        body: jsonEncode({
          'selectNumber': numberSelectedByUser ?? 0,
          'spendCoin': spendCoin,
          'gameType': gameType,
        }),
      );

       final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 10));
        final gameResultApiURL =  "${Api.baseUrl}${Api.spinCoinStatus}${jsonResponse['data']['_id'] ?? ""}";
        final gameResultResponse = await http.get(
          Uri.parse(gameResultApiURL),
          headers: {
            'Content-Type': 'application/json',
            'token': pref.getString(AppStrings.spAuthToken) ?? "",
          },
        );


        final gameResultJsonResponse = json.decode(gameResultResponse.body);
        if(gameResultResponse.statusCode == 200){
          setState(() {
            rewards = gameResultJsonResponse['data']['winCoin'] ?? 0;
          });
          setState(() {
            final number = gameResultJsonResponse['data']['winNumber'] ?? 0;
            selected.value = availableNumbers.indexOf(number);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You won $rewards Points!"),
            ),
          );
          _updateLastPlayDate();
         /// Navigator.pop(context);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(gameResultJsonResponse['message'] ?? "Error while loading data"),
            ),
          );
         /// Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['message'] ?? "Error while loading data"),
          ),
        );
        ///Navigator.pop(context);
      }
    } catch (e) {
      // Handle API call error
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(e.toString()),
        ),
      );
      ///Navigator.pop(context);
    } finally {
      setState(() {
        isApiCallInProgress = false;
        numberSelectedByUser = null;
      });
    }
  }

  _setSelectedNumber(int number){
    setState(() {
      numberSelectedByUser = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text("Casino"),
      ),
      body: Text("coming soon", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))
      // BlinkingBorderContainer(
      //   backgroundImage: "assets/casio_table.jpg",
      //   child: SizedBox(
      //     width: double.infinity,
      //     height: double.infinity,
      //     child: SingleChildScrollView(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const SizedBox(height: 25,),
      //           // Dropdown to select point value
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10.0),
      //               border: Border.all(
      //                 color: Colors.white, // Outline color
      //                 width: 2.0, // Outline width
      //               ),
      //             ),
      //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //             child: DropdownButton<int>(
      //               value: spendCoin,
      //               items: [5, 10, 15, 20, 25].map((int value) {
      //                 return DropdownMenuItem<int>(
      //                   value: value,
      //                   child: Text('$value Points',style: const TextStyle(
      //                     color: Colors.white
      //                   ),),
      //                 );
      //               }).toList(),
      //               onChanged: isApiCallInProgress
      //                   ? null
      //                   : (int? newValue) {
      //                 setState(() {
      //                   spendCoin = newValue!;
      //                 });
      //               },
      //               underline: Container(), // Remove the default underline
      //             ),
      //           ),
      //           const SizedBox(height: 30),
      //           // Casino-style board
      //           Stack(
      //             children: [
      //               Container(
      //                 height:  MediaQuery.of(context).size.width * 0.75,
      //                 width: MediaQuery.of(context).size.width * 0.75,
      //                 padding: const EdgeInsets.all(10),
      //                 decoration: BoxDecoration(
      //                   color:  const Color(0xFF3A2222),
      //                   borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.75/2),
      //                 ),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     image: const DecorationImage(
      //                         image: AssetImage('assets/mica_board.jpg'),
      //                         fit: BoxFit.cover,
      //                         opacity: 0.5
      //                     ),
      //                     color: Colors.brown,
      //                     borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.75/2),
      //                   ),
      //                   padding: const EdgeInsets.all(10.0),
      //                   child: Container(
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.75/2),
      //                       boxShadow:  [
      //                         BoxShadow(
      //                           color: Colors.black.withAlpha(100), // Shadow color
      //                           offset: const Offset(0.0, 0.0),
      //                           blurRadius: 10.0, // Spread of the shadow
      //                           spreadRadius: 5.0, // Expansion of the shadow
      //                         ),
      //                       ],
      //                     ),
      //                     child: FortuneWheel(
      //                       selected: selected.stream,
      //                       animateFirst: false,
      //                       alignment: Alignment.bottomCenter,
      //                       duration:  isApiCallInProgress ? const Duration(seconds: 12) : Duration.zero,
      //                       indicators: [
      //                         FortuneIndicator(
      //                             child: SizedBox(
      //                                 height: MediaQuery.of(context).size.width * 0.07,
      //                                 width: MediaQuery.of(context).size.width * 0.07,
      //                               child: Padding(
      //                                 padding: const EdgeInsets.only(top: 5),
      //                                 child: Image.asset("assets/ic_ball.png"),
      //                               )
      //                             ),
      //                           alignment: Alignment.topCenter
      //                         )
      //                       ],
      //                       items : List.generate(availableNumbers.length, (index) =>
      //                           FortuneItem(
      //                             child: Container(
      //                               color: availableNumbers[index] == 0 ? Colors.green.shade800 : index.isEven ? Colors.red.shade400 : Colors.black87,  // Set background color based on condition
      //                               child: Center(
      //                                 child: Text(
      //                                   availableNumbers[index].toString(),
      //                                   style: const TextStyle(
      //                                     color: Colors.white,
      //                                     fontWeight: FontWeight.w500,
      //                                     fontSize: 20,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                       ),
      //                       onAnimationEnd: () {
      //                         if (canPlay) {
      //                           _checkCanPlay(); // Check again after playing
      //                         }
      //                       },
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: MediaQuery.of(context).size.width * 0.75,
      //                 width: MediaQuery.of(context).size.width * 0.75,
      //                 child: Center(
      //                   child: Image.asset(
      //                     "assets/ic_knob.png",
      //                     height: MediaQuery.of(context).size.width * 0.18,
      //                     width: MediaQuery.of(context).size.width * 0.18,
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height:  MediaQuery.of(context).size.width * 0.75,
      //                 width: MediaQuery.of(context).size.width * 0.75,
      //                 child: Center(
      //                   child: Container(
      //                     height:  MediaQuery.of(context).size.width * 0.45,
      //                     width: MediaQuery.of(context).size.width * 0.45,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.50/2),
      //                       border: Border.all(
      //                         color: const Color(0xFFFFD700),
      //                         width: 2
      //                       ),
      //                     ),
      //
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //
      //           const SizedBox(height: 25),
      //
      //           Wrap(
      //             spacing: 10,
      //             alignment: WrapAlignment.center,
      //             children: availableNumbers
      //                 .map((number) => ElevatedButton(
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: numberSelectedByUser == number ? Colors.red.shade400 : Colors.white,
      //                 foregroundColor: numberSelectedByUser == number ? Colors.white : Colors.black87,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //               ),
      //               onPressed: isApiCallInProgress
      //                   ? null
      //                   : () async {
      //                 await _checkCanPlay();
      //                 if (canPlay) {
      //                    _setSelectedNumber(number);
      //                 } else {
      //                   // User has already played today
      //                   ScaffoldMessenger.of(context)
      //                       .showSnackBar(
      //                     const SnackBar(
      //                       content: Text(
      //                           "Please wait for 30 seconds."
      //                       ),
      //                     ),
      //                   );
      //                 }
      //               },
      //               child: Text('$number'),
      //             ))
      //                 .toList(),
      //           ),
      //
      //           const SizedBox(height: 15,),
      //
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children:[
      //               ElevatedButton(
      //                 onPressed: numberSelectedByUser != null && !isApiCallInProgress
      //                     ? () { _spinCoinApi("red"); }
      //                     : null,
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: numberSelectedByUser != null && !isApiCallInProgress
      //                       ? Colors.red
      //                       : Colors.white.withAlpha(150),
      //                   foregroundColor: Colors.black87,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: MediaQuery.of(context).size.width * 0.30,
      //                   alignment: Alignment.center,
      //                   child: const Text("Risky"),
      //                 ),
      //               ),
      //
      //               ElevatedButton(
      //                 onPressed: numberSelectedByUser != null && !isApiCallInProgress
      //                     ? () { _spinCoinApi("green"); }
      //                     : null,
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: numberSelectedByUser != null && !isApiCallInProgress
      //                       ? Colors.green
      //                       : Colors.white.withAlpha(150),
      //                   foregroundColor: Colors.black87,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: MediaQuery.of(context).size.width * 0.30,
      //                   alignment: Alignment.center,
      //                   child: const Text("Normal"),
      //                 ),
      //               ),
      //             ]
      //           ),
      //
      //           const SizedBox(height: 15,),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }



  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}


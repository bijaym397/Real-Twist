import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;

  List<int> items = [100, 200, 500, 100, 200, 500, 1000, -2000, -1000, -2000];
  List<Color> color = [
    Colors.orange.shade900,
    Colors.yellow.shade800,

    Colors.orange.shade900,
    Colors.yellow.shade800,

    Colors.orange.shade900,
    Colors.yellow.shade800,

    Colors.orange.shade900,
    Colors.yellow.shade800,

    Colors.orange.shade900,
    Colors.yellow.shade800,
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Spin & Win",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
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
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                        style: FortuneItemStyle(color: color[i])),
                  },
                ],
                onAnimationEnd: () {
                  setState(() {
                    rewards = items[selected.value];
                  });
                  print(rewards);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("You just won ${rewards.toString()} Points!"),
                    ),
                  );
                },
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  selected.add(Fortune.randomInt(0, items.length));
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                height: 40,
                width: 120,
                color: Colors.redAccent,
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

class ColorModel {
  final int name;
  final Color color;

  ColorModel(this.name, this.color);
}

final List<ColorModel> colorList = [
  ColorModel(100, Colors.red),
  ColorModel(200, Colors.green),
  ColorModel(1100, Colors.blue),
  ColorModel(10, Colors.yellow),
  ColorModel(-10, Colors.purple),
  ColorModel(-100, Colors.blue),
  ColorModel(-1000, Colors.purpleAccent),
  // Add more colors as needed
];

import 'package:flutter/material.dart';

class MyInvestView extends StatelessWidget {
  const MyInvestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle:  true,
        backgroundColor: Colors.pink.shade800,
        title: const Text("My Investment"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(Icons.payments_outlined, size: 30),
              title: const Text("payment received"),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("204$index",
                    style: const TextStyle(color: Colors.green, fontSize: 15)),
              ),);
          }),
    );
  }
}

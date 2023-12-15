import 'package:flutter/material.dart';
import 'package:real_twist/auth/login.dart';
import 'package:real_twist/home.dart';

import '../menu.dart';

class WithdrawalRequest extends StatelessWidget {
  const WithdrawalRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const users = "bijay;kldjsgrlsjerh vwhrtjh ;ggjkhjkwehgh eA";
    const status = false;
    const String img = "assets/user.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text("Withdrawal Request"),
      ),
      body: ScaffoldBGImg(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 12, right: 12, left: 12),
                    child: CommonCard(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white70,
                              ),
                              child: Container(
                                height: 100,
                                width: 60,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    image: users[0] == ""
                                        ? const DecorationImage(
                                            image: AssetImage(img))
                                        : null,
                                    color: Colors.pink.shade600,
                                    shape: BoxShape.circle),

                                /// Who is this
                                child: users[0] != ""
                                    ? Center(
                                        child: Text(
                                        users[0].toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32),
                                      ))
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                           Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(users,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    const Text(
                                      users,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    // Text(
                                    //   status == true ? "Payment Suc" : "Pen",
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: (){
                                          showPayPopup(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 150,
                                          decoration: BoxDecoration(color: Colors.pink,
                                              borderRadius: BorderRadius.circular(16),
                                            border: Border.all(width: 5, color: Colors.white54)
                                          ),
                                          child: const Center(
                                              child: Text(
                                                "Update Status",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                    )

                                  ]),
                            ),
                          ),
                          // const SizedBox(width: 16),
                          // Expanded(
                          //     flex: 2,
                          //     child: Container(
                          //       height: 40,
                          //       decoration: BoxDecoration(color: Colors.pink,
                          //       borderRadius: BorderRadius.circular(16)
                          //       ),
                          //       child: const Center(
                          //           child: Text(
                          //         "Pay",
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold),
                          //       )),
                          //     )
                          //     // ElevatedButton(onPressed: () {  }, child: const Text("Pay"),),
                          //     ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            /* Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: userList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Record not found...'),
                    );
                  } else {
                    List<Map<String, dynamic>> users = snapshot.data!;
                    return users.isEmpty
                        ? const Center(
                      child: Text("Nothing to show..."),
                    )
                        : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 12, right: 12, left: 12),
                          child: CommonCard(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetails(id: users[index]['_id'])));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white70,
                                    ),
                                    child: Container(
                                      height: 100,
                                      width: 60,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          image: users[index]['name'][0] == "" ? const DecorationImage(
                                              image: AssetImage(img)) : null,
                                          color: Colors.pink.shade600,
                                          shape: BoxShape.circle),

                                      /// Who is this
                                      child: users[index]['name'][0] != ""
                                          ? Center(
                                          child: Text(
                                            users[index]['name'][0]
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32),
                                          ))
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(users[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 6),
                                        Text(
                                          users[index]['email'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          users[index]['phoneNumber'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),*/
          ],
        ),
        /*Center(
            child: Text("No History available",
                style: TextStyle(color: Colors.white, fontSize: 22))),*/
      ),
    );
  }
}

Future<void> showPayPopup(BuildContext context) async {
  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Real Twist',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 22),
              ),
              const Text(
                "Pay successfully done to the user.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonCard(
                        onTap: () => Navigator.pop(context),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CommonCard(
                        onTap: () async { },
                        child: const Center(
                          child: Text(
                            'UPDATE',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_twist/admin/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api.dart';
import '../constants/strings.dart';
import '../home.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<Map<String, dynamic>>> userList;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer;
  int _countdown = 0;

  @override
  void initState() {
    super.initState();
    userList = _fetchUserList();
  }

  Future<List<Map<String, dynamic>>> _fetchUserList({String keyword = ""}) async {
    final apiUrl = "${Api.baseUrl}${Api.getUserList}$keyword";
    final pref = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'token': pref.getString(AppStrings.spAuthToken) ?? "",
      },
    );


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 200) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load user list');
      }
    } else {
      throw Exception('Failed to load user list');
    }
  }

  _search({required String keyword}) {
    if (_searchTimer != null && _searchTimer!.isActive) {
      _searchTimer!.cancel();
      _countdown = 0;
    }
    _searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _countdown++;
      if (_countdown == 1) {
        timer.cancel();
        _countdown =0;
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          userList = _fetchUserList(keyword: keyword);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const String img = "assets/user.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade800,
        centerTitle: true,
        title: const Text('Users'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  border: OutlineInputBorder(),
                  hintText: 'Enter name or phone number',
                  labelText: "Enter name or phone number"
              ),
              onChanged: (text){
                _search(keyword: text);
              },
            ),
          ),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}

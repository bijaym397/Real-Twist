import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final String id;

  const UserDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

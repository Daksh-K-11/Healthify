import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;
  const ProfileTile({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(color: Colors.grey.shade700)),
      ),
    );
  }
}

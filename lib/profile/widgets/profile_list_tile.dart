import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:healthify/core/theme/pallete.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;
  const ProfileTile({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: ListTile(
        title: Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Pallete.gradient1,
            )),
        trailing: Text(value,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            )),
      ),
    );
  }
}

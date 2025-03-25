import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthify/chat/pages/chat_bot_page.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/profile/pages/profile_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  List<Widget> content = [const ChatBotPage(), const ProfilePage()];
  List<String> title = ["Ask AI", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title[_currentIndex],
          style: const TextStyle(color: Pallete.whiteColor),
        ),
        backgroundColor: Pallete.gradient1,
      ),
      body: content[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Pallete.gradient1,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Chat',
              activeIcon: Icon(CupertinoIcons.chat_bubble_fill)),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

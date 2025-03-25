// import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:healthify/chat/pages/chat_bot_page.dart';
import 'package:healthify/home/pages/home_page.dart';
import 'package:healthify/profile/pages/profile_page.dart';
// import 'package:healthify/core/constant.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/report/service/report_service.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  List<Widget> content = [
    const HomePage(),
    const ChatBotPage(),
    const ProfilePage()
  ];
  List<String> title = ["Home", "Ask AI", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble),
                label: 'Chat',
                activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                label: 'Profile',
              ),
            ],
          ),
        ),
        if (_currentIndex == 1)
          Positioned(
            top: 600,
            left: 320,
            child: FadeIn(
              duration: const Duration(milliseconds: 400),
              child: FloatingActionButton(
                backgroundColor: Pallete.gradient3,
                foregroundColor: Pallete.borderColor,
                onPressed: () async {
                  final container = ProviderScope.containerOf(context);
                  final report =
                      await container.read(healthReportProvider.future);
                  showEvaluationBottomSheet(report, context);
                },
                child: const Icon(CupertinoIcons.chart_bar_alt_fill),
              ),
            ),
          ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthify/home/models/carousel_data.dart';
import 'package:healthify/home/widgets/carousel_item.dart';
import 'package:healthify/home/widgets/track.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= carouselData.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: carouselData.length,
                itemBuilder: (context, index) {
                  final data = carouselData[index];
                  return CarouselItem(
                    title: data["title"]!,
                    description: data["description"]!,
                    imagePath: data["image"]!,
                  );
                },
              ),
            ),
            const TrackPage(),
          ],
        ),
      ),
    );
  }
}

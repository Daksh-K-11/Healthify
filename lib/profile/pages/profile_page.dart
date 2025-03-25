import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/profile/providers/profile_provider.dart';
import 'package:healthify/profile/widgets/profile_list_tile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
        body: profileAsync.when(
      data: (profile) => ProfileContent(profile: profile),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading profile: ${err.toString()}')),
    ));
  }
}

class ProfileContent extends StatelessWidget {
  final Map<String, dynamic> profile;
  const ProfileContent({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade300, Colors.blue.shade600],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            BounceInDown(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(CupertinoIcons.person,
                    size: 60, color: Colors.grey.shade800),
              ),
            ),
            const SizedBox(height: 10),
            FadeIn(
              child: Text(
                profile['full_name'],
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            FadeIn(
              child: Text(
                "${profile['city']}, ${profile['dob']}",
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ZoomIn(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView(
                    children: [
                      ProfileTile(title: "Gender", value: profile['gender']),
                      ProfileTile(title: "Height", value: profile['height']),
                      ProfileTile(title: "Weight", value: profile['weight']),
                      ProfileTile(
                          title: "Medical History",
                          value: profile['medical_history']),
                      ProfileTile(
                          title: "Genetic Risks",
                          value: profile['genetic_predisposition']),
                      ProfileTile(title: "Smoking", value: profile['smoking']),
                      ProfileTile(
                          title: "Drinking", value: profile['drinking']),
                      ProfileTile(
                          title: "Exercise", value: profile['exercise_hours']),
                      ProfileTile(
                          title: "Sleep", value: profile['sleeping_hours']),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthify/core/theme/pallete.dart';

class Faqs extends StatelessWidget {
  final List<String> faqs = [
    'What is my current health condition?',
    'How can I improve myself?',
    'Who are you?'
  ];

  final Function(String)? onFaqSelected;

  Faqs({super.key, this.onFaqSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Pallete.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FAQs",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Pallete.whiteColor,
            ),
          ),
          const SizedBox(height: 10),
          ...faqs
              .map(
                (q) => GestureDetector(
                  onTap: () {
                    if (onFaqSelected != null) {
                      onFaqSelected!(q);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          q,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

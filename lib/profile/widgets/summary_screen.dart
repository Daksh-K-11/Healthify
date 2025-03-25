// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:healthify/core/theme/pallete.dart';
// import 'package:healthify/profile/models/question_model.dart';

// class SummaryScreen extends StatefulWidget {
//   final Map<int, dynamic> answers;
//   final List<Question> questions;

//   const SummaryScreen({
//     super.key,
//     required this.answers,
//     required this.questions,
//   });

//   @override
//   State<SummaryScreen> createState() => _SummaryScreenState();
// }

// class _SummaryScreenState extends State<SummaryScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   String _summary = "";
//   bool _copied = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _generateSummary();
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _generateSummary() {
//     String result = "Health Assessment Summary:\n\n";

//     for (var question in widget.questions) {
//       if (question.condition != null && !question.condition!(widget.answers)) {
//         continue;
//       }

//       if (widget.answers[question.id] == null) {
//         continue;
//       }

//       final answer = widget.answers[question.id];

//       String answerText = "";
//       if (answer is List<String>) {
//         final selectedOptions = question.options
//             .where((opt) => answer.contains(opt.value))
//             .map((opt) => opt.label)
//             .toList();
//         answerText = selectedOptions.join(", ");
//       } else {
//         final selectedOption = question.options.firstWhere(
//           (opt) => opt.value == answer,
//           orElse: () => Option(value: "", label: ""),
//         );
//         answerText = selectedOption.label;
//       }

//       result += "Q: ${question.text}\nA: $answerText\n\n";
//     }

//     setState(() {
//       _summary = result;
//     });
//   }

//   void _copySummary() {
//     Clipboard.setData(ClipboardData(text: _summary));
//     setState(() {
//       _copied = true;
//     });

//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _copied = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: child,
//                 ),
//               );
//             },
//             child: Column(
//               children: [
//                 // Completion header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(24.0),
//                   decoration: BoxDecoration(
//                     color: Pallete.cardColor,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Pallete.borderColor, width: 2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Pallete.gradient1, Pallete.gradient3],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: const Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         "Assessment Complete",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         "Thank you for completing the health questionnaire",
//                         style: TextStyle(
//                           color: Pallete.subtitleText,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24.0),
//                     decoration: BoxDecoration(
//                       color: Pallete.cardColor,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Pallete.borderColor, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Row(
//                           children: [
//                             Icon(
//                               Icons.description,
//                               color: Pallete.gradient1,
//                               size: 24,
//                             ),
//                             SizedBox(width: 12),
// Text(
//                               "Your Health Summary",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             child: Text(
//                               _summary,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Copy button
//                 ElevatedButton(
//                   onPressed: _copySummary,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Pallete.gradient1,
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 56),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(_copied ? Icons.check : Icons.copy),
//                       const SizedBox(width: 8),
//                       Text(_copied
//                           ? "Copied to Clipboard"
//                           : "Copy Summary to Clipboard"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:healthify/core/theme/pallete.dart';
// import 'package:healthify/profile/models/question_model.dart';

// class SummaryScreen extends StatefulWidget {
//   final Map<int, dynamic> answers;
//   final List<Question> questions;

//   const SummaryScreen({
//     super.key,
//     required this.answers,
//     required this.questions,
//   });

//   @override
//   State<SummaryScreen> createState() => _SummaryScreenState();
// }

// class _SummaryScreenState extends State<SummaryScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   String _summary = "";
//   bool _copied = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _generateSummary();
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // void _generateSummary() {
//   //   String result = "Health Assessment Summary:\n\n";
//   //   // Create a mapping variable to store key details.
//   //   Map<String, String> summaryMapping = {};

//   //   for (var question in widget.questions) {
//   //     if (question.condition != null && !question.condition!(widget.answers)) {
//   //       continue;
//   //     }
//   //     if (widget.answers[question.id] == null) {
//   //       continue;
//   //     }

//   //     final answer = widget.answers[question.id];
//   //     String answerText = "";
//   //     if (answer is List<String>) {
//   //       final selectedOptions = question.options
//   //           .where((opt) => answer.contains(opt.value))
//   //           .map((opt) => opt.label)
//   //           .toList();
//   //       answerText = selectedOptions.join(", ");
//   //     } else {
//   //       final selectedOption = question.options.firstWhere(
//   //         (opt) => opt.value == answer,
//   //         orElse: () => Option(value: "", label: ""),
//   //       );
//   //       answerText = selectedOption.label;
//   //     }

//   //     result += "Q: ${question.text}\nA: $answerText\n\n";

//   //     // Build the mapping based on question IDs.
//   //     switch (question.id) {
//   //       case 3:
//   //         summaryMapping['exercise'] = answerText;
//   //         break;
//   //       case 5:
//   //         summaryMapping['smoking'] = answerText;
//   //         break;
//   //       case 6:
//   //         summaryMapping['smoking'] = summaryMapping.containsKey('smoking')
//   //             ? "${summaryMapping['smoking']!}, $answerText"
//   //             : answerText;
//   //         break;
//   //       case 7:
//   //         summaryMapping['smoking'] = summaryMapping.containsKey('smoking')
//   //             ? "${summaryMapping['smoking']!},  $answerText"
//   //             : answerText;
//   //         break;
//   //       case 8:
//   //         summaryMapping['alcohol'] = answerText;
//   //         break;
//   //       case 9:
//   //         summaryMapping['drinks'] = answerText;
//   //         break;
//   //       case 10:
//   //         summaryMapping['sleep'] = answerText;
//   //         break;
//   //       case 12:
//   //         summaryMapping['stress'] = answerText;
//   //         break;
//   //       case 14:
//   //         summaryMapping['chronic'] = answerText;
//   //         break;
//   //       case 15:
//   //         summaryMapping['diabetes'] = answerText;
//   //         break;
//   //       case 16:
//   //         summaryMapping['bp'] = answerText;
//   //         break;
//   //       case 17:
//   //         summaryMapping['hospitalized'] = answerText;
//   //         break;
//   //       case 18:
//   //         summaryMapping['hospitalizationReason'] = answerText;
//   //         break;
//   //       case 19:
//   //         summaryMapping['familyHistory'] = answerText;
//   //         break;
//   //       case 20:
//   //         summaryMapping['diagnosedAge'] = answerText;
//   //         break;
//   //     }
//   //   }
//   //   // Print the mapping in the console.
//   //   print("Summary Mapping: $summaryMapping");

//   //   setState(() {
//   //     _summary = result;
//   //   });
//   // }

//   void _generateSummary() {
//     String result = "Health Assessment Summary:\n\n";
//     Map<String, String> summaryMapping = {};

//     for (var question in widget.questions) {
//       if (question.condition != null && !question.condition!(widget.answers)) {
//         continue;
//       }
//       if (widget.answers[question.id] == null) {
//         continue;
//       }

//       final answer = widget.answers[question.id];
//       String answerText = "";
//       if (answer is List<String>) {
//         final selectedOptions = question.options
//             .where((opt) => answer.contains(opt.value))
//             .map((opt) => opt.label)
//             .toList();
//         answerText = selectedOptions.join(", ");
//       } else {
//         final selectedOption = question.options.firstWhere(
//           (opt) => opt.value == answer,
//           orElse: () => Option(value: "", label: ""),
//         );
//         answerText = selectedOption.label;
//       }

//       result += "Q: ${question.text}\nA: $answerText\n\n";

//       switch (question.id) {
//         case 3:
//           summaryMapping['exercise_hours'] = answerText;
//           break;
//         case 5:
//           summaryMapping['smoking'] = answerText;
//           break;
//         case 6:
//           summaryMapping['smoking'] = summaryMapping.containsKey('smoking')
//               ? "${summaryMapping['smoking']!}, $answerText"
//               : answerText;
//           break;
//         case 7:
//           summaryMapping['smoking'] = summaryMapping.containsKey('smoking')
//               ? "${summaryMapping['smoking']!}, $answerText"
//               : answerText;
//           break;
//         case 8:
//           summaryMapping['drinking'] = answerText;
//           break;
//         case 9:
//           summaryMapping['drinking'] = summaryMapping.containsKey('drinking')
//               ? "${summaryMapping['drinking']!}, $answerText"
//               : answerText;
//           break;
//         case 10:
//           summaryMapping['sleeping_hours'] = answerText;
//           break;
//         case 14:
//           summaryMapping['medical_history'] = answerText;
//           break;
//         case 15:
//           summaryMapping['genetic_predisposition'] = answerText;
//           break;
//         // Other questions (IDs 16, 17, etc.) can be omitted if not needed
//       }
//     }

//     print("Summary Mapping: $summaryMapping");

//     setState(() {
//       _summary = result;
//     });
//   }

//   void _copySummary() {
//     Clipboard.setData(ClipboardData(text: _summary));
//     setState(() {
//       _copied = true;
//     });

//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _copied = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: child,
//                 ),
//               );
//             },
//             child: Column(
//               children: [
//                 // Completion header
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(24.0),
//                   decoration: BoxDecoration(
//                     color: Pallete.cardColor,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Pallete.borderColor, width: 2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [Pallete.gradient1, Pallete.gradient3],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                         child: const Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         "Assessment Complete",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         "Thank you for completing the health questionnaire",
//                         style: TextStyle(
//                           color: Pallete.subtitleText,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24.0),
//                     decoration: BoxDecoration(
//                       color: Pallete.cardColor,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Pallete.borderColor, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Row(
//                           children: [
//                             Icon(
//                               Icons.description,
//                               color: Pallete.gradient1,
//                               size: 24,
//                             ),
//                             SizedBox(width: 12),
//                             Text(
//                               "Your Health Summary",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             child: Text(
//                               _summary,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: _copySummary,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Pallete.gradient1,
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 56),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(_copied ? Icons.check : Icons.copy),
//                       const SizedBox(width: 8),
//                       Text(_copied
//                           ? "Copied to Clipboard"
//                           : "Copy Summary to Clipboard"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// In SummaryScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/profile/models/question_model.dart';

class SummaryScreen extends StatefulWidget {
  final Map<int, dynamic> answers;
  final List<Question> questions;
  final Map<String, String> signupData; // Received from previous screen

  const SummaryScreen({
    super.key,
    required this.answers,
    required this.questions,
    required this.signupData,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _summary = "";
  Map<String, String> _summaryMapping = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _generateSummary();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Generate summary text and build summaryMapping with modified keys
  void _generateSummary() {
    String result = "Health Assessment Summary:\n\n";
    Map<String, String> mapping = {};

    for (var question in widget.questions) {
      if (question.condition != null && !question.condition!(widget.answers)) {
        continue;
      }
      if (widget.answers[question.id] == null) {
        continue;
      }

      final answer = widget.answers[question.id];
      String answerText = "";
      if (answer is List<String>) {
        final selectedOptions = question.options
            .where((opt) => answer.contains(opt.value))
            .map((opt) => opt.label)
            .toList();
        answerText = selectedOptions.join(", ");
      } else {
        final selectedOption = question.options.firstWhere(
          (opt) => opt.value == answer,
          orElse: () => Option(value: "", label: ""),
        );
        answerText = selectedOption.label;
      }

      result += "Q: ${question.text}\nA: $answerText\n\n";

      // Build mapping using API keys
      switch (question.id) {
        case 3:
          mapping['exercise_hours'] = answerText;
          break;
        case 5:
          mapping['smoking'] = answerText;
          break;
        case 6:
          mapping['smoking'] = mapping.containsKey('smoking')
              ? "${mapping['smoking']!}, $answerText"
              : answerText;
          break;
        case 7:
          mapping['smoking'] = mapping.containsKey('smoking')
              ? "${mapping['smoking']!}, $answerText"
              : answerText;
          break;
        case 8:
          mapping['drinking'] = answerText;
          break;
        case 9:
          mapping['drinking'] = mapping.containsKey('drinking')
              ? "${mapping['drinking']!}, $answerText"
              : answerText;
          break;
        case 10:
          mapping['sleeping_hours'] = answerText;
          break;
        case 14:
          mapping['medical_history'] = answerText;
          break;
        case 15:
          mapping['genetic_predisposition'] = answerText;
          break;
        // You can add more cases as needed.
      }
    }

    setState(() {
      _summary = result;
      _summaryMapping = mapping;
    });

    // Debug print to verify the mapping
    print("Summary Mapping: $_summaryMapping");
  }

  // Function to combine signup data and questionnaire data, then make the API call
  Future<void> _submitData() async {
    setState(() {
      _isSubmitting = true;
    });

    // Combine signupData from the form and the questionnaire mapping
    final Map<String, dynamic> requestData = {
      ...widget
          .signupData, // Contains: full_name, password, phone_number, dob, gender, height, weight, city
      // Now add questionnaire fields (if not provided, default to empty string)
      "medical_history": _summaryMapping['medical_history'] ?? "",
      "genetic_predisposition": _summaryMapping['genetic_predisposition'] ?? "",
      "smoking": _summaryMapping['smoking'] ?? "",
      "drinking": _summaryMapping['drinking'] ?? "",
      "sleeping_hours": _summaryMapping['sleeping_hours'] ?? "",
      "exercise_hours": _summaryMapping['exercise_hours'] ?? "",
    };

    print(requestData);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.189.142:8023/api/auth/signup/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful signup, navigate to login or home screen as needed.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup successful!")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Summary")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                // Completion header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Pallete.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Pallete.borderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Pallete.gradient1, Pallete.gradient3],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Assessment Complete",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Thank you for completing the health questionnaire",
                        style: TextStyle(
                          color: Pallete.subtitleText,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Pallete.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Pallete.borderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        _summary,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Finish button that calls the API
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.gradient1,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Finish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

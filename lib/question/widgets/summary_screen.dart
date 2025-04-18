import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthify/auth/service/login_service.dart';
import 'package:healthify/core/constant.dart';
import 'package:healthify/core/utils.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/question/models/question_model.dart';

class SummaryScreen extends StatefulWidget {
  final Map<int, dynamic> answers;
  final List<Question> questions;
  final Map<String, String> signupData;

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

  bool _isProcessingDocument = false;
  double _uploadProgress = 0.0;
  File? _uploadedDocument;
  Map<String, dynamic>? _extractedMedicalData;

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

  Future<void> _pickAndUploadDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _isProcessingDocument = true;
          _uploadProgress = 0.0;
          _uploadedDocument = File(result.files.single.path!);
        });

        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (_uploadProgress >= 1.0) {
            timer.cancel();
          } else {
            setState(() {
              _uploadProgress += 0.1;
              if (_uploadProgress > 1.0) _uploadProgress = 1.0;
            });
          }
        });

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/track/extract-medical-report/'),
        );
        // Use key 'pdf' here:
        request.files.add(await http.MultipartFile.fromPath(
          'pdf',
          _uploadedDocument!.path,
        ));

        var response = await request.send();
        var responseData = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          var extractedData = jsonDecode(responseData);
          setState(() {
            _extractedMedicalData = extractedData;
          });
          showSnackBar(
              context, 'Medical information extracted successfully', true);
        } else {
          showSnackBar(context, 'Failed to extract data from document', false);
        }
      }
    } catch (e) {
      showSnackBar(context, 'Error uploading document: $e', false);
    } finally {
      setState(() {
        _isProcessingDocument = false;
        _uploadProgress = 0.0;
      });
    }
  }

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
      }
    }

    setState(() {
      _summary = result;
      _summaryMapping = mapping;
    });
  }

  Future<void> _submitData() async {
    setState(() {
      _isSubmitting = true;
    });

    final Map<String, dynamic> requestData = {
      ...widget.signupData,
      "medical_history": _summaryMapping['medical_history'] ?? "",
      "genetic_predisposition": _summaryMapping['genetic_predisposition'] ?? "",
      "smoking": _summaryMapping['smoking'] ?? "",
      "drinking": _summaryMapping['drinking'] ?? "",
      "sleeping_hours": _summaryMapping['sleeping_hours'] ?? "",
      "exercise_hours": _summaryMapping['exercise_hours'] ?? "",
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await LoginService().login(widget.signupData["phone_number"]!,
            widget.signupData["password"]!, context);
        showSnackBar(context, "Sign up successful", true);
      } else {
        showSnackBar(context, "Sign up unsuccessful", false);
      }
    } catch (e) {
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
                ElevatedButton.icon(
                  onPressed:
                      _isProcessingDocument ? null : _pickAndUploadDocument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.gradient1,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: _isSubmitting ? null : const Icon(CupertinoIcons.link),
                  label: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Upload Medical Document (Optional)"),
                ),
                const SizedBox(height: 24),

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

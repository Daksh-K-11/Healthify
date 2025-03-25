import 'package:flutter/material.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/question/models/question_model.dart';
import 'package:healthify/question/widgets/answer_options.dart';
import 'package:healthify/question/widgets/multi_select_options.dart';
import 'package:healthify/question/widgets/summary_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  final Map<String, String> signupData;
  const QuestionnaireScreen({super.key, required this.signupData});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentQuestionIndex = 0;
  Map<int, dynamic> _answers = {};
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnswer(String answer) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _answers[questions[_currentQuestionIndex].id] = answer;
    });

    _animationController.reverse().then((_) {
      setState(() {
        int nextIndex = _findNextQuestionIndex(_currentQuestionIndex);
        if (nextIndex == -1) {
          // Navigate to summary screen
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SummaryScreen(
                answers: _answers,
                questions: questions,
                signupData: widget.signupData,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        } else {
          _currentQuestionIndex = nextIndex;
          _isAnimating = false;
        }
      });
      _animationController.forward();
    });
  }

  void _handleMultiSelect(String option) {
    setState(() {
      final questionId = questions[_currentQuestionIndex].id;
      final currentAnswers = (_answers[questionId] as List<String>?) ?? [];

      if (currentAnswers.contains(option)) {
        _answers[questionId] =
            currentAnswers.where((a) => a != option).toList();
      } else {
        _answers[questionId] = [...currentAnswers, option];
      }
    });
  }

  void _submitMultiSelect() {
    if (_isAnimating) return;

    final questionId = questions[_currentQuestionIndex].id;
    final currentAnswers = (_answers[questionId] as List<String>?) ?? [];

    if (currentAnswers.isEmpty) return;

    setState(() {
      _isAnimating = true;
    });

    _animationController.reverse().then((_) {
      setState(() {
        int nextIndex = _findNextQuestionIndex(_currentQuestionIndex);
        if (nextIndex == -1) {
          // Navigate to summary screen
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SummaryScreen(
                answers: _answers,
                questions: questions,
                signupData: widget.signupData,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        } else {
          _currentQuestionIndex = nextIndex;
          _isAnimating = false;
        }
      });
      _animationController.forward();
    });
  }

  int _findNextQuestionIndex(int currentIndex) {
    int nextIndex = currentIndex + 1;
    while (nextIndex < questions.length &&
        questions[nextIndex].condition != null &&
        !questions[nextIndex].condition!(_answers)) {
      nextIndex++;
    }
    return nextIndex < questions.length ? nextIndex : -1;
  }

  double _calculateProgress() {
    int totalQuestions = questions
        .where((q) => q.condition == null || q.condition!(_answers))
        .length;
    int answeredQuestions = _answers.keys.length;
    return answeredQuestions / totalQuestions;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[_currentQuestionIndex];
    final progress = _calculateProgress();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Progress bar
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Pallete.borderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Pallete.gradient1, Pallete.gradient3],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(progress * 100).round()}% completed',
                    style: const TextStyle(
                      color: Pallete.subtitleText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Pallete.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Pallete.borderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQuestion.text,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: currentQuestion.multiSelect == true
                                ? _buildMultiSelectOptions(currentQuestion)
                                : _buildSingleSelectOptions(currentQuestion),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSelectOptions(Question question) {
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final option = question.options[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: AnswerOption(
            label: option.label,
            value: option.value,
            isSelected: _answers[question.id] == option.value,
            onTap: () => _handleAnswer(option.value),
          ),
        );
      },
    );
  }

  Widget _buildMultiSelectOptions(Question question) {
    final selectedOptions = (_answers[question.id] as List<String>?) ?? [];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              final option = question.options[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: MultiSelectOption(
                  label: option.label,
                  value: option.value,
                  isSelected: selectedOptions.contains(option.value),
                  onTap: () => _handleMultiSelect(option.value),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: selectedOptions.isEmpty ? null : _submitMultiSelect,
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.gradient1,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continue'),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ],
    );
  }
}

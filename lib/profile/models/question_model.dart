typedef ConditionFunction = bool Function(Map<int, dynamic> answers);

class Option {
  final String value;
  final String label;

  Option({required this.value, required this.label});
}

class Question {
  final int id;
  final String text;
  final List<Option> options;
  final bool? multiSelect;
  final ConditionFunction? condition;

  Question({
    required this.id,
    required this.text,
    required this.options,
    this.multiSelect,
    this.condition,
  });
}

final List<Question> questions = [
  Question(
    id: 3,
    text: "How often do you exercise?",
    options: [
      Option(value: "A", label: "Rarely or never"),
      Option(value: "B", label: "1-2 times per week"),
      Option(value: "C", label: "3-5 times per week"),
      Option(value: "D", label: "Daily"),
    ],
  ),
  Question(
    id: 5,
    text: "Do you smoke?",
    options: [
      Option(value: "A", label: "Yes, currently"),
      Option(value: "B", label: "No, but I used to"),
      Option(value: "C", label: "Never"),
    ],
  ),
  Question(
    id: 6,
    text: "How many cigarettes do you smoke per day?",
    options: [
      Option(value: "A", label: "Less than 5"),
      Option(value: "B", label: "5-10"),
      Option(value: "C", label: "11-20"),
      Option(value: "D", label: "More than 20"),
    ],
    condition: (answers) => answers[5] == "A",
  ),
  Question(
    id: 7,
    text: "Are you interested in quitting smoking?",
    options: [
      Option(value: "A", label: "Yes, I want to quit"),
      Option(value: "B", label: "I have tried but failed"),
      Option(value: "C", label: "No, I'm not interested"),
    ],
    condition: (answers) => answers[5] == "A" || answers[5] == "B",
  ),
  Question(
    id: 8,
    text: "Do you consume alcohol?",
    options: [
      Option(value: "A", label: "Never"),
      Option(value: "B", label: "Occasionally (1-2 times/month)"),
      Option(value: "C", label: "Weekly"),
      Option(value: "D", label: "Frequently (multiple times per week)"),
    ],
  ),
  Question(
    id: 9,
    text: "How many drinks do you consume per session?",
    options: [
      Option(value: "A", label: "1-2"),
      Option(value: "B", label: "3-5"),
      Option(value: "C", label: "6+"),
    ],
    condition: (answers) => answers[8] == "C" || answers[8] == "D",
  ),
  Question(
    id: 10,
    text: "How many hours of sleep do you get per night?",
    options: [
      Option(value: "A", label: "Less than 5 hours"),
      Option(value: "B", label: "5-6 hours"),
      Option(value: "C", label: "7-8 hours"),
      Option(value: "D", label: "More than 8 hours"),
    ],
  ),
  Question(
    id: 12,
    text: "How often do you feel stressed?",
    options: [
      Option(value: "A", label: "Rarely"),
      Option(value: "B", label: "Sometimes"),
      Option(value: "C", label: "Frequently"),
      Option(value: "D", label: "Almost always"),
    ],
  ),
  Question(
    id: 14,
    text: "Do you have any of the following chronic conditions?",
    options: [
      Option(value: "A", label: "Diabetes"),
      Option(value: "B", label: "Hypertension"),
      Option(value: "C", label: "Heart disease"),
      Option(value: "D", label: "Asthma/COPD"),
      Option(value: "E", label: "None"),
    ],
    multiSelect: true,
  ),
  Question(
    id: 15,
    text: "How do you manage your diabetes?",
    options: [
      Option(value: "A", label: "Diet control"),
      Option(value: "B", label: "Medication"),
      Option(value: "C", label: "Insulin therapy"),
      Option(value: "D", label: "Not managing it well"),
    ],
    condition: (answers) {
      final List<String> conditions = answers[14] as List<String>? ?? [];
      return conditions.contains("A");
    },
  ),
  Question(
    id: 16,
    text: "Do you regularly monitor your blood pressure?",
    options: [
      Option(value: "A", label: "Yes, at home"),
      Option(value: "B", label: "Yes, during doctor visits"),
      Option(value: "C", label: "No"),
    ],
    condition: (answers) {
      final List<String> conditions = answers[14] as List<String>? ?? [];
      return conditions.contains("B");
    },
  ),
  Question(
    id: 17,
    text: "Have you undergone major surgery or been hospitalized for a serious illness?",
    options: [
      Option(value: "A", label: "Yes"),
      Option(value: "B", label: "No"),
    ],
  ),
  Question(
    id: 18,
    text: "What was the reason for your hospitalization?",
    options: [
      Option(value: "A", label: "Heart surgery"),
      Option(value: "B", label: "Cancer treatment"),
      Option(value: "C", label: "Injury/accident"),
      Option(value: "D", label: "Other medical condition"),
    ],
    condition: (answers) => answers[17] == "A",
  ),
  Question(
    id: 19,
    text: "Does anyone in your immediate family have a history of chronic illness?",
    options: [
      Option(value: "A", label: "Yes, diabetes"),
      Option(value: "B", label: "Yes, heart disease or high blood pressure"),
      Option(value: "C", label: "Yes, cancer"),
      Option(value: "D", label: "No major family history"),
    ],
  ),
  Question(
    id: 20,
    text: "At what age was your family member diagnosed?",
    options: [
      Option(value: "A", label: "Before 40 years old (higher genetic risk)"),
      Option(value: "B", label: "After 40 years old"),
    ],
    condition: (answers) => 
      answers[19] == "A" || answers[19] == "B" || answers[19] == "C",
  ),
];

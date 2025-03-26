// // 1. Add this to your SignupPage class to handle document upload
// import 'dart:convert';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:healthify/core/utils.dart';
// import 'package:healthify/question/models/question_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:healthify/core/constant.dart';
// import 'package:healthify/core/theme/pallete.dart';

// Widget _buildDocumentUploadSection() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const SizedBox(height: 15),
//       const Text(
//         'Do you have any medical documents?',
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.upload_file),
//               label: const Text('Upload Medical Document'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Pallete.gradient2,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//               onPressed: _pickAndUploadDocument,
//             ),
//           ),
//         ],
//       ),
//       if (_uploadedDocument != null)
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(
//             'Document uploaded: ${_uploadedDocument!.path.split('/').last}',
//             style: const TextStyle(color: Pallete.gradient1),
//           ),
//         ),
//     ],
//   );
// }

// // 2. Add these variables and methods to your SignupPage state class
// File? _uploadedDocument;
// Map<String, dynamic>? _extractedMedicalData;
// bool _isProcessingDocument = false;

// Future<void> _pickAndUploadDocument() async {
//   try {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//     );
    
//     if (result != null) {
//       setState(() {
//         _isProcessingDocument = true;
//         _uploadedDocument = File(result.files.single.path!);
//       });
      
//       // Process the document and extract data
//       await _extractMedicalData();
      
//       setState(() {
//         _isProcessingDocument = false;
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _isProcessingDocument = false;
//     });
//     showSnackBar(context, 'Error uploading document: $e', false);
//   }
// }

// Future<void> _extractMedicalData() async {
//   if (_uploadedDocument == null) return;
  
//   try {
//     // Create form data for file upload
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$baseUrl/track/extract-medical-report/'),
//     );
    
//     // Add the file to the request
//     request.files.add(await http.MultipartFile.fromPath(
//       'document',
//       _uploadedDocument!.path,
//     ));
    
//     // Add basic user info that might help with extraction
//     request.fields['full_name'] = nameController.text;
//     if (dobController.text.isNotEmpty) {
//       request.fields['dob'] = dobController.text;
//     }
    
//     // Send the request
//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();
    
//     if (response.statusCode == 200) {
//       var extractedData = jsonDecode(responseData);
//       setState(() {
//         _extractedMedicalData = extractedData;
//       });
      
//       // Prefill form fields with extracted data
//       _prefillFormFields(extractedData);
      
//       showSnackBar(context, 'Medical information extracted successfully', true);
//     } else {
//       showSnackBar(context, 'Failed to extract data from document', false);
//     }
//   } catch (e) {
//     showSnackBar(context, 'Error processing document: $e', false);
//   }
// }

// void _prefillFormFields(Map<String, dynamic> data) {
//   // Only update fields if they're empty or if the extracted data is not null
//   if (data['full_name'] != null && nameController.text.isEmpty) {
//     nameController.text = data['full_name'];
//   }
  
//   if (data['dob'] != null && dobController.text.isEmpty) {
//     dobController.text = data['dob'];
//   }
  
//   if (data['gender'] != null && selectedGender == null) {
//     setState(() {
//       selectedGender = data['gender'];
//     });
//   }
  
//   if (data['height'] != null && heightController.text.isEmpty) {
//     heightController.text = data['height'].toString().replaceAll(' cm', '');
//   }
  
//   if (data['weight'] != null && weightController.text.isEmpty) {
//     weightController.text = data['weight'].toString().replaceAll(' kg', '');
//   }
  
//   if (data['city'] != null && cityController.text.isEmpty) {
//     cityController.text = data['city'];
//   }
// }

// // 3. Modify your QuestionnaireScreen to skip questions that have been answered
// // Add this to your QuestionnaireScreen constructor
// final Map<String, dynamic>? extractedMedicalData;

// // Then in your _findNextQuestionIndex method, add logic to skip questions
// int _findNextQuestionIndex(int currentIndex) {
//   int nextIndex = currentIndex + 1;
//   while (nextIndex < questions.length) {
//     // Skip if condition doesn't match
//     if (questions[nextIndex].condition != null && 
//         !questions[nextIndex].condition!(_answers)) {
//       nextIndex++;
//       continue;
//     }
    
//     // Skip if we already have data for this question from medical records
//     if (widget.extractedMedicalData != null) {
//       bool skipQuestion = false;
      
//       // Check if this question's data is already available
//       switch (questions[nextIndex].id) {
//         case 14: // Medical history question
//           skipQuestion = widget.extractedMedicalData!['medical_history'] != null;
//           if (skipQuestion) {
//             // Add the extracted data to answers
//             _answers[14] = _convertMedicalHistoryToOptions(
//               widget.extractedMedicalData!['medical_history']
//             );
//           }
//           break;
//         case 19: // Family history question
//           skipQuestion = widget.extractedMedicalData!['genetic_predisposition'] != null;
//           if (skipQuestion) {
//             // Add the extracted data to answers
//             _answers[19] = _convertGeneticPredispositionToOption(
//               widget.extractedMedicalData!['genetic_predisposition']
//             );
//           }
//           break;
//         // Add more cases for other questions that can be prefilled
//       }
      
//       if (skipQuestion) {
//         nextIndex++;
//         continue;
//       }
//     }
    
//     // If we get here, we found a question to show
//     break;
//   }
  
//   return nextIndex < questions.length ? nextIndex : -1;
// }

// // Helper methods to convert extracted text to appropriate option values
// List<String> _convertMedicalHistoryToOptions(String medicalHistory) {
//   List<String> result = [];
  
//   if (medicalHistory.toLowerCase().contains('diabetes')) {
//     result.add('A');
//   }
//   if (medicalHistory.toLowerCase().contains('hypertension') || 
//       medicalHistory.toLowerCase().contains('high blood pressure')) {
//     result.add('B');
//   }
//   if (medicalHistory.toLowerCase().contains('heart disease')) {
//     result.add('C');
//   }
//   if (medicalHistory.toLowerCase().contains('asthma') || 
//       medicalHistory.toLowerCase().contains('copd')) {
//     result.add('D');
//   }
  
//   if (result.isEmpty) {
//     result.add('E'); // None
//   }
  
//   return result;
// }

// String _convertGeneticPredispositionToOption(String geneticPredisposition) {
//   if (geneticPredisposition.toLowerCase().contains('diabetes')) {
//     return 'A';
//   }
//   if (geneticPredisposition.toLowerCase().contains('heart') || 
//       geneticPredisposition.toLowerCase().contains('hypertension') ||
//       geneticPredisposition.toLowerCase().contains('blood pressure')) {
//     return 'B';
//   }
//   if (geneticPredisposition.toLowerCase().contains('cancer')) {
//     return 'C';
//   }
  
//   return 'D';
// }
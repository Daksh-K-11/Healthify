import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/auth/widgets/auth_gradient_button.dart';
import 'package:healthify/core/widgets/custom_field.dart';
import 'package:healthify/auth/pages/login.dart';
import 'package:healthify/core/theme/pallete.dart';
import 'package:healthify/core/utils.dart';
import 'package:healthify/profile/pages/questionarre_screen.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final cityController = TextEditingController();

  String? selectedGender;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    cityController.dispose();
    super.dispose();
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
  }

  Future<void> _selectDOB() async {
    DateTime initialDate = DateTime(2000);
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();
    final DateTime? pickedDate = await showCustomDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Pallete.borderColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Pallete.gradient2,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      hintText: hintText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up.',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hintText: 'Phone Number',
                    controller: phoneController,
                    keyBoardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          hintText: 'Date of Birth',
                          controller: dobController,
                          readOnly: true,
                          onTap: _selectDOB,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          decoration: _inputDecoration('Gender'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Gender is missing!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          hintText: 'Height (cm)',
                          controller: heightController,
                          keyBoardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomField(
                          hintText: 'Weight (kg)',
                          controller: weightController,
                          keyBoardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CustomField(
                    hintText: 'City',
                    controller: cityController,
                  ),
                  const SizedBox(height: 20),
                  // AuthGradientButton(
                  //   buttonText: 'Sign Up',
                  //   onTap: () async {
                  //     // if (formKey.currentState!.validate()) {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => const QuestionnaireScreen()));
                  //     // } else {
                  //     //   showSnackBar(context, 'Missing fields!', false);
                  //     // }
                  //   },
                  // ),
                  AuthGradientButton(
                    buttonText: 'Sign Up',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        // Collect signup form data into a map
                        final Map<String, String> signupData = {
                          "full_name": nameController.text,
                          "password": passwordController.text,
                          "phone_number": phoneController.text,
                          "dob": dobController
                              .text, // Make sure this is in YYYY-MM-DD
                          "gender": selectedGender ?? "",
                          "height": heightController.text,
                          "weight": weightController.text,
                          "city": cityController.text,
                        };

                        // Pass signupData to QuestionnaireScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                QuestionnaireScreen(signupData: signupData),
                          ),
                        );
                      } else {
                        showSnackBar(context, 'Missing fields!', false);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LoginPage()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: const [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: Pallete.gradient1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

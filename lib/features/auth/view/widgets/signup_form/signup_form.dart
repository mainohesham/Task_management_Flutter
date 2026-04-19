import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button/custom_button.dart';
import '../../../../../core/widgets/custom_field/custom_field.dart';
import '../../../../../core/widgets/custom_label/custom_label.dart';
import '../../../model/model/user_model.dart';
import '../../../view_model/cubit/auth_cubit.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.signupkey,
    required this.fullNameController,
    required this.emailController,
    required this.studentIdController,
    required this.passwordController,
    required this.confirmPassController,
  });

  final GlobalKey<FormState> signupkey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController studentIdController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  // FocusNodes
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _studentIdFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();

  // Gender
  String? _selectedGender;

  // Academic Level
  int? _selectedLevel;

  @override
  void dispose() {
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _studentIdFocus.dispose();
    _passwordFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (widget.signupkey.currentState!.validate()) {
      final user = User(
        fullName: widget.fullNameController.text,
        email: widget.emailController.text,
        studentID: widget.studentIdController.text,
        password: widget.passwordController.text,
        gender: _selectedGender,
        academicLevel: _selectedLevel,
      );
      context.read<AuthCubit>().signUp(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.signupkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20,),

          // ── Full Name (Mandatory) ──────────────────────────
          MyLabel(text: "Full Name *"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              focusNode: _fullNameFocus,
              hintText: '',
              icon: Icons.person,
              controller: widget.fullNameController,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocus);
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                if (value.trim().length < 3) {
                  return 'Full name must be at least 3 characters';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

          // ── University Email (Mandatory) ───────────────────
          MyLabel(text: "Email *"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              focusNode: _emailFocus,
              hintText: 'studentID@stud.fci-cu.edu.eg',
              icon: Icons.email,
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_studentIdFocus);
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your university email';
                }
                final regex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
                if (!regex.hasMatch(value.trim())) {
                  return 'Email must be: studentID@stud.fci-cu.edu.eg';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

          // ── Student ID (Mandatory) ─────────────────────────
          MyLabel(text: "StudentID *"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              focusNode: _studentIdFocus,
              hintText: 'e.g. 20201234',
              icon: Icons.badge,
              controller: widget.studentIdController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocus);
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your student ID';
                }
                // Check Student ID matches email prefix
                final email = widget.emailController.text.trim();
                final emailPrefix = email.split('@').first;
                if (value.trim() != emailPrefix) {
                  return 'Student ID must match your email ID';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

          // ── Academic Level Dropdown (Optional) ────────────
          Center(child: MyLabel(text: "Academic")),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
              width: 315,
              child: DropdownButtonFormField<int>(
                value: _selectedLevel,
                hint: const Text(''),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.school, color: Mycolors.mainColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Mycolors.mainColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Mycolors.mainColor,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Mycolors.mainColor,
                      width: 3,
                    ),
                  ),
                ),
                items: [1, 2, 3, 4].map((level) {
                  return DropdownMenuItem<int>(
                    value: level,
                    child: Text('Level $level'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Password (Mandatory) ───────────────────────────
          MyLabel(text: "Password *"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              focusNode: _passwordFocus,
              hintText: "",
              icon: Icons.lock,
              controller: widget.passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_confirmPassFocus);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                }
                if (value.length < 8) {
                  return "Password must be at least 8 characters";
                }
                if (!RegExp(r'\d').hasMatch(value)) {
                  return "Password must contain at least one number";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

          // ── Confirm Password (Mandatory) ───────────────────
          MyLabel(text: "ConfirmPass *"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              focusNode: _confirmPassFocus,
              hintText: "",
              icon: Icons.lock,
              controller: widget.confirmPassController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                _submitForm();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != widget.passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 40),
          // ── Gender Radio Button (Optional) ────────────────
          MyLabel(text: "Gender"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _selectedGender,
                    activeColor: Mycolors.mainColor,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text('Male'),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Radio<String>(
                    value: 'Female',
                    groupValue: _selectedGender,
                    activeColor: Mycolors.mainColor,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          CustomButton(
            title: "Sign Up",
            bgColor: Mycolors.mainColor,
            textColor: Colors.white,
            onpressed: _submitForm,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
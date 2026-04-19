import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button/custom_button.dart';
import '../../../../../core/widgets/custom_field/custom_field.dart';
import '../../../../../core/widgets/custom_label/custom_label.dart';
import '../../../view_model/cubit/auth_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.loginkey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> loginkey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // FocusNodes
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.loginkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyLabel(text: "Email"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              hintText: 'studentID@stud.fci-cu.edu.eg',
              icon: Icons.email,
              controller: widget.emailController,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocus);
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final regex = RegExp(r'^\d+@stud\.fci-cu\.edu\.eg$');
                if (!regex.hasMatch(value.trim())) {
                  return 'Email must be in format: studentID@stud.fci-cu.edu.eg';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          MyLabel(text: "Password"),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: CustomField(
              hintText: "Password",
              icon: Icons.lock,
              controller: widget.passwordController,
              focusNode: _passwordFocus,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (widget.loginkey.currentState!.validate()) {
                  context.read<AuthCubit>().login(
                    widget.emailController.text,
                    widget.passwordController.text,
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Forget your password?",
            style: TextStyle(color: Mycolors.textColor, fontSize: 17),
          ),
          const SizedBox(height: 40),
          CustomButton(
            title: "Log in",
            bgColor: Mycolors.mainColor,
            textColor: Colors.white,
            onpressed: () {
              if (widget.loginkey.currentState!.validate()) {
                context.read<AuthCubit>().login(
                  widget.emailController.text,
                  widget.passwordController.text,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

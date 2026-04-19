import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/custom_appbar/custom_appbar.dart';
import '../../../../tasks/view/screens/task_screen.dart';
import '../../../view_model/cubit/auth_cubit.dart';
import '../../../view_model/cubit/auth_state.dart';
import '../../widgets/signup_form/signup_form.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _signupkey = GlobalKey<FormState>();

  // ── Controllers ───────────────────────────────────────
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    studentIdController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Tasky"),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Signup Successful ✅")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TaskScreen(userId: state.user.id!)),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Signup Failed ❌: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: SignupForm(
              signupkey: _signupkey,
              fullNameController: fullNameController,
              emailController: emailController,
              studentIdController: studentIdController,
              passwordController: passwordController,
              confirmPassController: confirmPassController,
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/custom_appbar/custom_appbar.dart';
import '../../../../tasks/view/screens/task_screen.dart';
import '../../../view_model/cubit/auth_cubit.dart';
import '../../../view_model/cubit/auth_state.dart';
import '../../widgets/login_form/login_form.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Tasky"),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login Successful ✅")));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => TaskScreen(userId: state.user.id!)),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login Failed ❌: ${state.message}")),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            //return form
            return LoginForm(loginkey: _loginkey, emailController: emailController, passwordController: passwordController);
          },
        ),
      ),
    );
  }
}



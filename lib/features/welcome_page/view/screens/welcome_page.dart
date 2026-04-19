import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/widgets/custom_button/custom_button.dart';
import '../../../auth/view/screens/login/login.dart';
import '../../../auth/view/screens/signup/signup.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                      child: Text(
                        "Tasky",
                        style: TextStyle(
                          color: Mycolors.mainColor,
                          fontSize: 66,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(
                      "Add, manage and complete your tasks",
                      style: TextStyle(fontSize: 25, color: Mycolors.textColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 33),
                    CustomButton(
                      title: "Log in",
                      bgColor: Mycolors.mainColor,
                      textColor: Colors.white,
                      onpressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      title: "Sign up",
                      bgColor: Colors.white,
                      textColor: Mycolors.mainColor,
                      onpressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Signup()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 45),
              Center(child: Image.asset(MyPaths.welcomeImage, width: 500, height: 319.81)),
              SizedBox(height: 35),
            ],
          ),


    );
  }
}
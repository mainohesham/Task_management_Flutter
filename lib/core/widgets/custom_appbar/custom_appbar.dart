import 'package:flutter/material.dart';


import '../../../features/welcome_page/view/screens/welcome_page.dart';
import '../../constants/app_colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;

  const CustomAppBar({super.key, required this.title, this.showMenu = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Mycolors.mainColor,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      leading: showMenu
          ? Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      )
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
                (route) => false,
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
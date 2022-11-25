import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/buttonw.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String welcome = "welcome";

  const WelcomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: "logo",
                    child: Image(
                      image: const AssetImage('images/logo.png'),
                      height: animation.value * 70,
                    ),
                  ),
                ),
                const Text(
                  'Flash Chat',
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            buttonw(
              color: Colors.lightBlue,
              nav: () {
                Navigator.pushNamed(context, LoginScreen.login);
              },
              text: 'Log In',
            ),
            buttonw(
              color: Colors.blueAccent,
              nav: () {
                Navigator.pushNamed(context, RegistrationScreen.register);
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}

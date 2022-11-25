import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/buttonw.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String register = "register";

  const RegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  bool spiner = false;
  late String email;
  late String pass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: spiner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Flexible(
                child: Hero(
                  tag: "logo",
                  child: Image(
                    image: AssetImage('images/logo.png'),
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  // style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Enter your email',
                  )),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  // style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      pass = value;
                    });
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Enter your password',
                  )),
              const SizedBox(
                height: 24.0,
              ),
              buttonw(
                color: Colors.blueAccent,
                nav: () async {
                  setState(() {
                    spiner = true;
                  });
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: pass);
                    // ignore: unnecessary_null_comparison
                    if (user != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, ChatScreen.chat);
                      setState(() {
                        spiner = false;
                      });
                    } else {
                      setState(() {
                        spiner = false;
                      });
                    }
                  } catch (e) {
                    // ignore: avoid_print
                    print(e);
                  }
                },
                text: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

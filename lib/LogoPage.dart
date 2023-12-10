import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'LoginPage.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/LogoPage.png'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 400,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(60, 30)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  child: const Text('Get Started'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an Account?'),
                    TextButton(
                      child: Text('Sign In'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false, // Prevent the screen from resizing when the keyboard is displayed
    );
  }
}

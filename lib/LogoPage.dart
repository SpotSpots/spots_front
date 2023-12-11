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
                  height: 550,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 20,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      backgroundColor: Color(0xff478FCA),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(335, 45)
                  ),
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
                      child: Text('Sign In', style: TextStyle(decoration: TextDecoration.underline)),
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

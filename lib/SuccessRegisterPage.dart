import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'LoginPage.dart';

class SuccessRegisterPage extends StatelessWidget {
  const SuccessRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/SuccessRegisterPage.png'),
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 400,
              ),
              ElevatedButton(
                  style : ElevatedButton.styleFrom(minimumSize: Size(60, 30)),
                  onPressed: (){
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Find Your Spots')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

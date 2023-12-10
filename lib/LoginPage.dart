import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool saving = false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: saving,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/LogoPage.png'), // Adjust the path accordingly
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(onPressed: () async {
                    try {
                      setState(() {
                        saving = true;
                      });
                      final currentUser = await _authentication
                          .signInWithEmailAndPassword(
                          email: email, password: password);

                      if (currentUser.user != null) {
                        _formKey.currentState!.reset();
                      }
                      setState(() {
                        saving = true;
                      });

                      if (!mounted) return;
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                    catch(e){
                      print(e);
                    }
                  },
                      style: ButtonStyle(
                        // Set minWidth to your desired width
                        minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 48)),
                      ),
                      child: Text('Enter')),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}

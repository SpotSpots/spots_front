import 'SuccessRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Set elevation to 0 to remove the shadow
        title: Text('Register'),
      ),
      body: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool saving = false;
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
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
                        labelText: 'User Name',
                      ),
                      onChanged: (value) {
                        userName = value;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            saving = true;
                          });
                          final newUser = await _authentication
                              .createUserWithEmailAndPassword(
                              email: email, password: password);
                          await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid).set({
                            'userName' : userName,
                            'email': email,
                          });
                          // Add userFavorite collection
                          // Do not add any document, just create an empty collection
                          await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                              .collection('userFavorite').doc().set({});

                          // Add userFavorite collection with an empty document
                          // await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                          //     .collection('userFavorite').doc().set({
                          //   'name': '',
                          //   'category': '',
                          // });


                          if (newUser.user != null) {
                            _formKey.currentState!.reset();
                            if (!mounted) return;
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const SuccessRegisterPage()));
                          }
                          setState(() {
                            saving = false;
                          });
                        } catch (e) {
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

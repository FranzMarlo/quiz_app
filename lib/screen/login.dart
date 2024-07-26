// ignore_for_file: unused_catch_clause

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app/screen/forgot_password.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/utils/dialog.dart';
import 'package:quiz_app/screen/signup.dart';
import 'package:quiz_app/utils/widgets.dart';

class login extends StatefulWidget {
  const login({super.key});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future login() async {
    var email = emailController.text;
    var password = passwordController.text;
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      showDialog(context: context, builder: (_) => const emailDialog());
      return;
    } else if (password.isEmpty) {
      showDialog(context: context, builder: (_) => const passwordDialog());
      return;
    } else {
      try {
        showDialog(context: context, builder: (context) => circularLoader());
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context, rootNavigator: true).pop();
      } on FirebaseAuthException catch (e) {
        if(e.code == 'user-not-found' || e.code == 'wrong-password'){
          Navigator.of(context, rootNavigator: true).pop();
        showDialog(
            context: context, builder: (_) => const invalidCredentialDialog());
        }
        else if(e.code == 'too-many-requests'){
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
            context: context, builder: (_) => const accountDisabledDialog());
      }else{
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
            context: context, builder: (_) => const serverErrorDialog());
      }
      }
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromRGBO(83, 167, 214, 1),
            Color.fromRGBO(136, 205, 246, 1),
            Color.fromRGBO(188, 230, 255, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    height: 300,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Container(
                  width: mediaQuery.size.width,
                  height: (mediaQuery.size.height - 300),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: Colors.white,
                    border: Border.all(
                      color: text,
                      width: 3,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(40, 30, 20, 20),
                          child: SizedBox(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'SF Pro',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                          child: SizedBox(
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Text('Email',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.email,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'Email',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: emailController,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 5, top: 5),
                                        child: Text('Password',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'SF Pro',
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: TextFormField(
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 15),
                                              child: Icon(
                                                Icons.lock,
                                                color: appBar,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: background,
                                                    width: 0)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none),
                                            fillColor: background,
                                            filled: true,
                                            hintText: 'Password',
                                            hintStyle: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'SF Pro',
                                              color: Colors.black54,
                                            ),
                                          ),
                                          controller: passwordController,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 25, 5),
                                        child: SizedBox(
                                          width: mediaQuery.size.width,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ForgotPassword()));
                                            },
                                            child: Text(
                                              'Forgot Password?',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: fadedBlack,
                                                  fontSize: 16,
                                                  fontFamily: 'SF Pro',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 20),
                                          child: SizedBox(
                                            height: 55,
                                            width: double.infinity,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: appBar,
                                              ),
                                              child: TextButton(
                                                  onPressed: () => login(),
                                                  child: const Text(
                                                    'Log In',
                                                    style: TextStyle(
                                                        fontFamily: 'SF Pro',
                                                        fontSize: 20.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 20, 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: Text(
                                                'Don\'t have account?',
                                                style: TextStyle(
                                                  fontFamily: 'SF Pro',
                                                  fontSize: 18.0,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              signUp())),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 30),
                                                child: Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    fontSize: 18.0,
                                                    color: appBar,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }
}
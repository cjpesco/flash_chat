import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  final _auth = FirebaseAuth.instance;

  String _email;
  String _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _checkFocus(_emailFocusNode);
    _checkFocus(_passwordFocusNode);

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _checkFocus(FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus == true) {
        _animationController.forward();
      } else if (focusNode.hasFocus == false) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100 * (1 - _animation.value) + 100,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  focusNode: _emailFocusNode,
                  onChanged: (value) {
                    //Do something with the user input.
                    _email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  focusNode: _passwordFocusNode,
                  onChanged: (value) {
                    //Do something with the user input.
                    _password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                  obscureText: true,
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _email, password: _password);
                      if (newUser != null) {
                        Navigator.pushReplacementNamed(context, ChatScreen.id);
                      }
                    } catch (e) {
                      print(e);
                    }

                    // print(_email);
                    // print(_password);
                    //  Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

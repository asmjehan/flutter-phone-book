import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/AllScreens/mainscreen.dart';
import 'package:phone_book/main.dart';
import 'registrationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image(
                  image: AssetImage("assets/images/home.png"),
                  width: 300,
                  height: 250,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Login as User",
                  style: TextStyle(fontSize: 20, fontFamily: "Brand bold"),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Color(0xfffca103),
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "Brand bold"),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage(
                                "Email address is not Valid", context);
                          } else if (passwordTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Please provide Password", context);
                          } else {
                            LoginAndAuthenticateUser(context);
                          }
                        },
                      )
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          RegistrationScreen.idScreen, (route) => false);
                    },
                    child: Text("Do not have account? Register Here.")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void LoginAndAuthenticateUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errorMsg) {
      displayToastMessage("Eroor: " + errorMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are logged in successfully !", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "Wrong mail or password. or account not exist. please create account first ",
              context);
        }
      });
    } else {
      displayToastMessage("Error Ocurred", context);
    }
  }
}

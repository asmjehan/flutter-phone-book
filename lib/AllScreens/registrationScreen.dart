import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_book/AllScreens/mainscreen.dart';
import 'package:phone_book/main.dart';
import 'loginScreen.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                  width: 350,
                  height: 250,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Register as a new user",
                  style: TextStyle(fontSize: 20, fontFamily: "Brand bold"),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Md Jehan",
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
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "abc@gmail.com",
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
                      TextField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "01926759232",
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
                              "Register",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "Brand bold"),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          if (nameTextEditingController.text.length < 4) {
                            displayToastMessage(
                                "Name at least 3 characters.", context);
                          } else if (!emailTextEditingController.text
                              .contains("@")) {
                            displayToastMessage("Invalid email", context);
                          } else if (passwordTextEditingController.text.length <
                              7) {
                            displayToastMessage(
                                "password mustat least 7 character", context);
                          } else {
                            registerNewUser(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text("Already have account? login Here.")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errorMsg) {
      displayToastMessage("Eroor: " + errorMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Account created successfully", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      displayToastMessage("Account not created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}

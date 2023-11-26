import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _authFormKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoggedIn = false;
  Color mainColor = Color(0xFFE01D5B);

  loginAuth(){
    final validated = _authFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(validated){
      _authFormKey.currentState!.save();
      submitAuth();
    }
  }

  submitAuth() async{
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try{
      if(isLoggedIn){
        userCredential = await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      }
      else{
        userCredential = await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            height: 200,
            child: Image.asset("assets/focusflow-logo.png"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right:10, top: 10),
            child: Form(
              key: _authFormKey,
              child: Column(
                children: [
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8),
                            borderSide: new BorderSide()),
                        labelText: "Entrez votre email",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                    SizedBox(height: 10),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8),
                            borderSide: new BorderSide()),
                        labelText: "Entrez votre mot de passe",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  Container(
                    height: 70,
                    width: double.infinity,
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        )
                      ),
                      onPressed: () {
                        submitAuth();
                      },
                      child: isLoggedIn ? Text("Se connecter", style:GoogleFonts.roboto(fontSize: 16)) : Text("S'inscrire", style:GoogleFonts.roboto(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextButton(
                        onPressed: (){
                          setState(() {
                            isLoggedIn = !isLoggedIn;
                          });
                        },
                        child: isLoggedIn ? Text("Vous n'avez pas encore de compte ? S'inscrire") : Text("Vous avez déjà un compte ? Se connecter")),
                  )
                ],
              ),
            )
          )
      ])
    );
  }
}

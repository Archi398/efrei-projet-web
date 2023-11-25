import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _AuthFormKey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        Container(
          padding: EdgeInsets.only(left:10, right:10, top:10),
          child: Form(
            key: _AuthFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(!isLoggedIn)
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('username'),
                    validator: (value){
                      if (value!.isEmpty){
                        return "Nom d'utilisateur incorrect, veuillez réessayer.";
                      }
                      return null;
                    },
                    onSaved: (value){
                      if(value != null) {
                        _username = value;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Entrez votre nom d'utilisateur",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(height:10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('email'),
                  validator: (value){
                    if (value!.isEmpty || !value!.contains('@')){
                      return "Email incorrect, veuillez réessayer.";
                    }
                    return null;
                  },
                  onSaved: (value){
                    if(value != null) {
                      _email = value;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      borderSide: new BorderSide()),
                    labelText: "Entrez votre email",
                    labelStyle: GoogleFonts.roboto()),
                ),
                SizedBox(height:10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('password'),
                  validator: (value){
                    if (value!.isEmpty){
                      return "Mot de passe incorrect, veuillez réessayer.";
                    }
                    return null;
                  },
                  onSaved: (value){
                    if(value != null) {
                      _password = value;
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide()),
                      labelText: "Entrez votre mot de passe",
                      labelStyle: GoogleFonts.roboto()),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      // Votre code ici
                    },
                    child: isLoggedIn ? Text("Se connecter", style:GoogleFonts.roboto(fontSize: 16)) : Text("S'inscrire", style:GoogleFonts.roboto(fontSize: 16)),
                  ),
                )
              ],
            ),
          )
        )
      ],)
    );
  }
}
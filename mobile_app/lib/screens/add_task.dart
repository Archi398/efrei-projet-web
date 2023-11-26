import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController task = TextEditingController();
  bool isCompleted = false;

  submitTask() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if(user != null){
      String uid = user.uid;
      await FirebaseFirestore.instance.collection("todos").add({
        'title': task.text,
        'userId': uid,
        'isCompleted': isCompleted
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tâche ajoutée !"))
      );
      task.clear();
    }
    else {
      Fluttertoast.showToast(msg: "Erreur: Utilisateur non connecté");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nouvelle tâche')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: task,
                decoration: InputDecoration(
                  labelText: "Que devez-vous faire ?",
                  border: OutlineInputBorder()
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFFE01D5B))),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states){
                  if(states.contains(MaterialState.pressed))
                    return Color(0xFFE01D5B).withOpacity(0.5);
                  return Color(0xFFE01D5B);
                })),
                onPressed: () async{
                  await submitTask();
                  Navigator.of(context).pop();
                },
                child: Text('Ajouter une tâche',
                  style: GoogleFonts.roboto(fontSize: 16),
                )
              )
            )
          ],
        )
      )
    );
  }
}

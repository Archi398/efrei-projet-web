import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/screens/add_task.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController uid = TextEditingController();
  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    setState(() {
      uid.text = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("FocusFlow"),
        actions: [
          IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout))
        ]
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
          child: uid == null ? Center(child: Text("Vous n'êtes pas connecté.")) : StreamBuilder(
          stream: FirebaseFirestore.instance.collection("todos").where('userId', isEqualTo: uid).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasError){
              return Center(child: Text("Une erreur s'est produite."));
            }
            else if(snapshot.hasData){
              final documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = documents[index];
                  Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
                  bool isCompleted = false;

                  if (data != null) {
                    if (data.containsKey('isCompleted')) {
                      isCompleted = data['isCompleted'] ?? false;
                    }
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFE01D5B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (bool? newValue) {
                          documentSnapshot.reference.update({
                            'isCompleted': newValue,
                          }).then((_) {
                            print("Tâche mise à jour");
                          }).catchError((error) {
                            print("Erreur lors de la mise à jour de la tâche: $error");
                          });
                        },
                      ),
                      title: Text(
                        data?['title'] ?? 'Tâche inconnue',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                            Icons.delete,
                            color: Colors.white
                        ),
                        onPressed: (){
                          documentSnapshot.reference.delete().then((_) {
                            print("Tâche supprimée !");
                          }).catchError((error){
                            print("Erreur lors de la suppression de la tâche: $error");
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }
            else{
              return Center(child: Text("Aucune donnée disponible."));
            }
          }
        )
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 31),
              child: FloatingActionButton(
                child: Icon(Icons.delete_sweep, color: Colors.white),
                backgroundColor: Color(0xFFE01D5B),
                onPressed: () async {
                  try {
                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("todos").where('userId', isEqualTo: uid).get();
                    for (var doc in querySnapshot.docs) {
                      await doc.reference.delete();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Toutes les tâches ont été supprimées.'))
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur lors de la suppression des tâches: $e'))
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0, right: 0),
            child: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xFFE01D5B),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
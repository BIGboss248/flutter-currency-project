import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/services/crud/notes_service.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  const Transactions({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late final NotesService _noteService;
  final List<Widget> items = []; // MUST NOT be const
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("notes")),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            FutureBuilder(
              future: _noteService.getOrCreateUser(email: userEmail),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(stream: _noteService.allNotes, builder: (context, snapshot) {
                      switch (snapshot.connectionState){
                        case ConnectionState.waiting:
                          return const  Text("Waiting for all notes");
                        default:
                          return CircularProgressIndicator();
                      }
                    },);
                  default:
                    return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

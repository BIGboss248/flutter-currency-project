import 'package:budgee/constants/routes.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/services/crud/notes_service.dart';
import 'package:budgee/widgets/main_bot_navbar.dart';
import 'package:budgee/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Notes extends StatefulWidget {
  const Notes({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
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
      appBar: AppBar(
        title: const Text("notes"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push(newNoteRoute);
            },
            icon: Icon(Icons.add),
          ),
          DrawerButton(),
        ],
        actionsPadding: const EdgeInsets.all(8.0),
      ),
      endDrawer: MainDrawer(),
      bottomNavigationBar: MainNavBar(currentIndex: widget.pageIndex),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FutureBuilder(
              future: _noteService.getOrCreateUser(email: userEmail),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: _noteService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text("Waiting for all notes");
                          default:
                            return CircularProgressIndicator();
                        }
                      },
                    );
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

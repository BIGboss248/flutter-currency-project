import 'package:budgee/constants/routes.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/services/crud/notes_service.dart';
import 'package:budgee/widgets/alert_dialog.dart';
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
  Future<DatabaseUser>? dbUser;

  @override
  void initState() {
    _noteService = NotesService();
    dbUser = _noteService.getOrCreateUser(email: userEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _noteService.deleteAllNotes();
        },
        child: Icon(Icons.delete),
      ),
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
              future: dbUser,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(
                      stream: _noteService.allNotes,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Text("Waiting for all notes");
                          case ConnectionState.done:
                            return const Text("Stream is done");
                          case ConnectionState.active:
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            return Expanded(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final note = allNotes[index];
                                  return ListTile(
                                    title: Text(
                                      "note id: ${note.id}, text: ${note.text}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                    onTap: () {
                                      context.push(
                                        "$newNoteRoute?noteId=${note.id}",
                                      );
                                    },
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        final shouldDelete =
                                            await showChoiceDialog(
                                              context: context,
                                              title: "Delete note",
                                              content:
                                                  "Are you sure you want to delete note",
                                              actions: [
                                                TextButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      false,
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("yes"),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      true,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ) ??
                                            false;
                                        if (shouldDelete) {
                                          _noteService.deleteNote(id: note.id);
                                        }
                                      },
                                    ),
                                  );
                                },
                                itemCount: allNotes.length,
                              ),
                            );
                          // return const Text("Stream is active");
                          case ConnectionState.none:
                            return const Text("Stream is none");
                        }
                      },
                    );
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.none:
                    return Text("Future builder is none");
                  case ConnectionState.active:
                    return Text("Future builder is active");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

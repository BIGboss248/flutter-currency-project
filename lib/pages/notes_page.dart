import 'package:budgee/constants/routes.dart';
import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/services/cloud/cloud_note.dart';
import 'package:budgee/services/cloud/firebase_cloud_storage.dart';
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
  late final FirebaseCloudStorage _noteService;
  final List<Widget> items = []; // MUST NOT be const
  final user = AuthService.firebase().currentUser!;
  String get userEmail => user.email;
  Future<CloudNote>? dbUser;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    // dbUser = _noteService.getOrCreateUser(email: userEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(newNoteRoute);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("notes"), centerTitle: true),
      endDrawer: MainDrawer(),
      bottomNavigationBar: MainNavBar(currentIndex: widget.pageIndex),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // FutureBuilder(
            //   future: dbUser,
            //   builder: (context, snapshot) {
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.done:
            /* return */ StreamBuilder(
              stream: _noteService.allNotes(ownerUserID: user.id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text("Waiting for all notes");
                  case ConnectionState.done:
                    return const Text("Stream is done");
                  case ConnectionState.active:
                    final allNotes = snapshot.data?.toList() as List<CloudNote>;
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final note = allNotes[index];
                          return ListTile(
                            title: Text(
                              "text: ${note.text}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            onTap: () {
                              context.push(
                                "$newNoteRoute?noteId=${note.documentId}",
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
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("yes"),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ) ??
                                    false;
                                if (shouldDelete) {
                                  _noteService.deleteNote(
                                    documentId: note.documentId,
                                  );
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
            ),
            //       case ConnectionState.waiting:
            //         return CircularProgressIndicator();
            //       case ConnectionState.none:
            //         return Text("Future builder is none");
            //       case ConnectionState.active:
            //         return Text("Future builder is active");
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

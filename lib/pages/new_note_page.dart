import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/services/crud/notes_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

class NewNote extends StatefulWidget {
  const NewNote({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  /* Will keep track of note through this variable so it dosen't create it on each widget rebuild */
  DatabaseNote? _note;
  /* Get the instance of the notes service */
  late final NotesService _notsService;
  /* Used for note text */
  late final TextEditingController _textController;

  /* Create a new note or if the note exsits return that */
  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      log("Returning existing note");
      return existingNote;
    }
    log("Creating new note");
    log("getting current user");
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    log("Current user is $email");
    final owner = await _notsService.getUser(email: email);
    log("Current db user is ${owner.email}");
    final result = await _notsService.createNote(owner: owner);
    log("new note is $result");
    return result;
  }

  /* Delete the note if the user comes to page and dosn't put anything in the note text field*/
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (note != null && _textController.text.isEmpty) {
      _notsService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      _notsService.updateNote(note: note, text: text);
    }
  }

  Future<void> _textControllerListener() async {
    final note = _note;
    if (note != null) {
      return;
    }
    final text = _textController.text;
    await _notsService.updateNote(note: note!, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  initState() {
    _notsService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New note")),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            log("snpashot data is: ${snapshot.data}");
              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null, /* Needed for multiline text */
                decoration: const InputDecoration(
                  hintText: "Type your note here",
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

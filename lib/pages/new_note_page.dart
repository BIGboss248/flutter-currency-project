import 'package:budgee/services/auth/auth_service.dart';
import 'package:budgee/services/cloud/cloud_note.dart';
import 'package:budgee/services/cloud/cloud_storage_exceptions.dart';
import 'package:budgee/services/cloud/firebase_cloud_storage.dart';
import 'package:budgee/utils/app_logger.dart';
import 'package:budgee/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class NewNote extends StatefulWidget {
  const NewNote({required this.pageIndex, this.noteId, super.key});

  final int pageIndex;

  final String? noteId;

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  /* Will keep track of note through this variable so it dosen't create it on each widget rebuild */
  CloudNote? _note;
  /* Get the instance of the notes service */
  late final FirebaseCloudStorage _notsService;
  /* Used for note text */
  late final TextEditingController _textController;

  /* Create a new note or if the note exsits return that */
  Future<CloudNote> createNewNote() async {
    logger.i("getting current user");
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    logger.i("Current user is $email");
    // final owner = await _notsService.getUser(email: email);
    // log("Current db user is ${owner.email}");
    if (widget.noteId != null) {
      _note = await _notsService.getNote(
        ownerUserID: currentUser.id,
        docID: widget.noteId.toString(),
      );
    }
    final existingNote = _note;
    if (existingNote != null) {
      logger.i("Returning existing note");
      return existingNote;
    }
    logger.i("Creating new note");
    final result = await _notsService.createNewNote(
      ownerUserID: currentUser.id,
    );
    logger.i("new note is $result");
    return result;
  }

  /* Delete the note if the user comes to page and dosn't put anything in the note text field*/
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (note != null && _textController.text.isEmpty) {
      _notsService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      _notsService.updateNote(documentId: note.documentId, text: text);
    }
  }

  Future<void> _textControllerListener() async {
    final note = _note;
    if (note != null) {
      return;
    }
    final text = _textController.text;
    await _notsService.updateNote(documentId: note!.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  initState() {
    logger.i(
      "new_note_page opened with params noteID: ${widget.noteId} and pageIndex: ${widget.pageIndex}",
    );
    _notsService = FirebaseCloudStorage();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _notsService.shareNote(
              documentId: _note!.documentId,
              text: _textController.text,
            );
          } on CanNotShareEmptyNote {
            await showChoiceDialog(
              context: context,
              title: "Can not share empty note",
              content: "Can not share empty note",
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("ok"),
                ),
              ],
            );
          }
        },
        child: const Icon(Icons.share),
      ),
      appBar: AppBar(title: Text("New note")),
      body: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                logger.i("snpashot data is: ${snapshot.data}");
                _note = snapshot.data as CloudNote;
                _textController.text = _note!.text;
                _setupTextControllerListener();
                return Column(
                  children: [
                    Text("note id is: ${_note!.documentId}"),
                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      /* Needed for multiline text */
                      decoration: const InputDecoration(
                        hintText: "Type your note here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

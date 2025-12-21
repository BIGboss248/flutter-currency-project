import 'package:budgee/services/cloud/cloud_note.dart';
import 'package:budgee/services/cloud/cloud_storage_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budgee/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  /* Create new note */
  Future<CloudNote> createNewNote({required String ownerUserID}) async {
    final newNote = await notes.add({
      ownerUserIdFieldName: ownerUserID,
      textFieldName: "",
    });
    final note = await newNote.get();
    return CloudNote(
      documentId: note.id,
      ownerUserId: note.data()![ownerUserIdFieldName],
      text: '',
    );
  }

  /* Get a iterable of user notes */
  Future<Iterable<CloudNote>> getNotes({required String ownerUserID}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserID)
          .get()
          .then(
            (value) => value.docs.map((doc) {
              return CloudNote(
                documentId: doc.id,
                ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                text: doc.data()[textFieldName] as String,
              );
            }),
          );
    } catch (e) {
      throw CouldNotReadNoteException();
    }
  }

  Future<CloudNote> getNote({
    required String docID,
    required String ownerUserID,
  }) async {
    try {
      final userNotes = await getNotes(ownerUserID: ownerUserID);
      return userNotes.firstWhere((note) => note.documentId == docID);
    } catch (_) {
      throw CouldNotReadNoteException();
    }
  }

  /* Funciton to stream all notes to the user notes page */
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserID}) =>
      notes.snapshots().map(
        (event) => event.docs
            .map((doc) => CloudNote.fromSnapshot(doc))
            .where((note) => note.ownerUserId == ownerUserID),
      );

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteAllNotes({required String ownerUserID}) async {
    try {
      final userNotes = await getNotes(ownerUserID: ownerUserID);
      for (final note in userNotes) {
        await deleteNote(documentId: note.documentId);
      }
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}

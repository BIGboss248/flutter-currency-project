/* 
  This file is the service to do CRUD operations for transactions
*/

import 'dart:async';

import 'package:budgee/services/crud/crud_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart'; /* SqLite driver for dart */
import 'package:path_provider/path_provider.dart'; /* To use join operation */
import 'package:path/path.dart' show join;
import 'dart:developer' show log;

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
        );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
        );''';

class NotesService {
  Database? _db;

  /* Make NoteService a singleton*/
  NotesService._sharedInstance();
  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;

  /* This acts as a cache to store notes so client won't have to fetch it over and over again */
  List<DatabaseNote> _notes = [];

  /* helps UI fetch changes to notes to display on screen
  TIP we use stream controller.broadcast() since we can listen to it more than once
  */
  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final user = await createUser(email: email);
      return user;
    } catch (e) {
      /* This will make code easier to debug since you can put a breakpoint here */
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    log("Caching all notes");
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  /* 
  # Get database or error

  since on CRUD operations we check if DB is open or not before we do anything this funciton will do that meaning checks if databse is open will  return the database instance else throws an exception
  
   */
  Database _getDatabaseOrThrow() {
    log("Getting database or throw error");
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      return db;
    }
  }

  /* 
  The idea is that on each databse operation the database gets opened without the need to open database before each and every operation we want to do 
  */
  Future<void> _ensureDbIsOpen() async {
    log("ensuring db is open");
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    log("Opening databse");
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      log("Database path is: $dbPath", level: 200);
      final db = await openDatabase(dbPath);
      _db = db;
      log("Creating user table $createUserTable", level: 200);
      /* Create user table */
      await db.execute(createUserTable);
      log("Creating notes table $createNoteTable", level: 200);
      /* Create note table */
      await db.execute(createNoteTable);
      /* Cache notes */
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    log("Closing databse");
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  /* 
  Create user with given Email 
  */
  Future<DatabaseUser> createUser({required String email}) async {
    log("Creating databse user");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userID = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(id: userID, email: email);
  }

  /* Get(read) user */
  Future<DatabaseUser> getUser({required String email}) async {
    log("Getting databse user");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  /*
   Delete user
   */
  Future<void> deleteUser({required String email}) async {
    log("Deleting databse user $email");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  /* Create note */
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    log("Creating databse note for ${owner.email}");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    /* We check this part for security purposes to stop people from creating a note with the correct ID*/
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    const text = '';
    /* Create note in databse */
    final noteId = await db.insert(noteTable, {
      textColumn: text,
      userIdColumn: owner.id,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    /* Add the new created note to _notes list */
    _notes.add(note);
    /* Add note list to stream controler so UI gets updated */
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    log("Deleting databse note $id");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    log("Deleting all databse notes");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    _notes = [];
    _notesStreamController.add(_notes);
    return await db.delete(noteTable);
  }

  Future<DatabaseNote> getNote({required int id}) async {
    log("Getting databse note $id");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      /* Update cache */
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    log("Getting all databse notes");
    _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    log("Updating databse note $note.id");
    _ensureDbIsOpen();
    /* Making sure the note exists */
    await getNote(id: note.id);
    final db = _getDatabaseOrThrow();
    final updatedCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatedCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});
  DatabaseUser.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      email = map[emailColumn] as String;
  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[userIdColumn] as int,
      text = map[textColumn] as String,
      isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1
          ? true
          : false;

  @override
  String toString() {
    return 'Note, ID = $id, userID = $userId, is_synced_with_cloud = $isSyncedWithCloud, text = $text';
  }

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}


class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CloudNotCreateNoteException extends CloudStorageException{}

class CouldNotReadNoteException extends CloudStorageException{}

class CouldNotUpdateNoteException extends CloudStorageException{}

class CouldNotDeleteNoteException extends CloudStorageException{}

class CanNotShareEmptyNote implements Exception {}

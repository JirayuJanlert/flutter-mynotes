class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
/// > This class is thrown when the app is unable to create a note to the cloud storage
class CouldNotCreateNoteException extends CloudStorageException {}

// R in CRUD
/// > This class is thrown when the app is unable to get all the notes from the cloud storage
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in CRUD
/// > This class is used to throw an exception when a note could not be updated in the cloud storage
class CouldNotUpdateNoteException extends CloudStorageException {}

// D in CRUD
/// > This class is used to represent an exception that is thrown when a note could not be deleted from
/// the cloud storage
class CouldNotDeleteNoteException extends CloudStorageException {}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_course/services/cloud/cloud_note.dart';
import 'package:flutter_course/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_course/services/cloud/cloud_storage_exceptions.dart';

/// A class that is used to perform CRUD from Firebase Cloud Storage.
class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  /// It returns a stream of all notes that belong to the user with the given userId
  ///
  /// Args:
  ///   ownerUserId (String): The user ID of the user who owns the notes.
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  /// It creates a new note.
  ///
  /// Args:
  ///   ownerUserId (String): The user id of the user who created the note.
  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdfieldName: ownerUserId,
      textFieldName: '',
    });
  }

  /// Get all the notes for a given user.
  ///
  /// Args:
  ///   ownerUserId (String): The user ID of the user who owns the notes.
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdfieldName, isEqualTo: ownerUserId)
          .get()
          .then((value) {
        return value.docs.map((doc) {
          return CloudNote(
            documentId: doc.id,
            text: doc.data()[textFieldName] as String,
            ownerUserId: doc.data()[ownerUserIdfieldName] as String,
          );
        });
      });
    } catch (_) {
      throw CouldNotGetAllNotesException();
    }
  }

  /// It takes a documentId and a text, and updates the document with the given documentId with the
  /// given text
  ///
  /// Args:
  ///   documentId (String): The ID of the document to update.
  ///   text (String): The text of the note.
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

  /// It deletes a note from the database.
  ///
  /// Args:
  ///   documentId (String): The document ID of the note to be deleted.
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }
}

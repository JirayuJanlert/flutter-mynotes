// login exceptions:

// user-not-found found exception
class UserNotFoundAuthException implements Exception {}

// wrong-password firebaseauth exception
class WrongPasswordAuthException implements Exception {}

// register exceptions:

//weak-password
class WeakPasswordAuthException implements Exception {}

// email-already-in-use
class EmailAlreadyInUseAuthException implements Exception {}

// invalid-email
class InvalidEmailAuthException implements Exception {}

// generic exceptions:
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

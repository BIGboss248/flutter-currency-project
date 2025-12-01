// login exceptions

class UserNotFoundAuthExecption implements Exception {}

class WrongPasswordAuthExecption implements Exception {}

class UserNotLoggedInAuthException implements Exception {}


// register execption

class WeakPasswordAuthExecption implements Exception {}

class EmailAlreadyInUseAuthExecption implements Exception {}

class InvalidEmailAuthExecption implements Exception {}

// genenric execption

class GenericAuthExecption implements Exception {}

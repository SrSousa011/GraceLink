class FirebaseExceptionWrapper implements Exception {
  final String message;

  FirebaseExceptionWrapper(this.message);

  @override
  String toString() {
    return "FirebaseException: $message";
  }
}

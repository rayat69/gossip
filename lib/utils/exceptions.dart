class UnauthorizedException implements Exception {
  final message = 'You are not authorized to perform this action';

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

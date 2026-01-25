enum FailureType { network, server, auth, unknown }

class Failure {
  final String message;
  final FailureType type;
  final dynamic originalError;

  Failure({
    required this.message,
    this.type = FailureType.unknown,
    this.originalError,
  });

  @override
  String toString() => message;

  bool get isConnectionError => type == FailureType.network;
}

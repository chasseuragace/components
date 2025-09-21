abstract class Failure {
  final String message;
  final dynamic details;
  final int? statusCode;
  
  const Failure({
    required this.message,
    this.details,
    this.statusCode,
  });
  
  @override
  String toString() {
    return 'Failure(message: $message, details: $details, statusCode: $statusCode)';
  }
}

class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Server error occurred',
    dynamic details,
    int? statusCode,
  }) : super(
          message: message,
          details: details,
          statusCode: statusCode,
        );
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred',
    dynamic details,
  }) : super(
          message: message,
          details: details,
        );
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    String message = 'Unexpected error occurred',
    dynamic details,
  }) : super(
          message: message,
          details: details,
        );
}

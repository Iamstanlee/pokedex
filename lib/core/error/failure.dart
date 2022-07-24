// coverage:ignore-file
abstract class Failure {
  String get message;
  @override
  operator ==(other) {
    return other is Failure && message == other.message;
  }

  @override
  int get hashCode => message.hashCode;
}

class NetworkFailure extends Failure {
  @override
  String get message => "Network unavailable";
}

class ServerFailure extends Failure {
  final String msg;
  ServerFailure([this.msg = ""]);
  @override
  String get message => msg;
}

class UnexpectedFailure extends Failure {
  @override
  String get message => "Unexpected error occurred";
}

class InvalidArgOrDataFailure extends Failure {
  final String msg;
  InvalidArgOrDataFailure([this.msg = "Some fields are invalid"]);
  @override
  String get message => msg;
}

class CacheFailure extends Failure {
  final String msg;
  CacheFailure([this.msg = "Cache error"]);
  @override
  String get message => msg;
}

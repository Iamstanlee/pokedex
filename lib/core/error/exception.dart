// coverage:ignore-file
abstract class PokedexException implements Exception {
  String get message;

  @override
  operator ==(other) {
    return other is PokedexException && message == other.message;
  }

  @override
  int get hashCode => message.hashCode;
}

abstract class ServerException implements PokedexException {}

class TimeoutServerException implements ServerException {
  final String msg;
  TimeoutServerException([this.msg = "connection timeout"]);

  @override
  String get message => msg;
}

class UnexpectedServerException implements ServerException {
  final String msg;
  UnexpectedServerException([this.msg = "An unexpected error occured"]);

  @override
  String get message => msg;
}

class PokedexServerException implements ServerException {
  final String msg;
  PokedexServerException([this.msg = "An unexpected error occured"]);

  @override
  String get message => msg;
}

class InvalidArgOrDataException implements PokedexException {
  final String msg;
  InvalidArgOrDataException([this.msg = "error in arguments or data"]);
  @override
  String get message => msg;
}

class CacheGetException implements PokedexException {
  final String msg;
  CacheGetException([this.msg = "error retrieving data from cache"]);
  @override
  String get message => msg;
}

class CachePutException implements PokedexException {
  final String msg;
  CachePutException([this.msg = "error saving data to cache"]);
  @override
  String get message => msg;
}

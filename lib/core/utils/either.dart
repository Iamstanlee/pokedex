import 'package:pokedex/core/error/exception.dart';
import 'package:pokedex/core/error/failure.dart';
import 'package:pokedex/core/utils/safe_print.dart';
import 'package:equatable/equatable.dart';

/// A convenience class for handling either values of an option.
/// This class is typically used to represent the result of an operation
/// which can be either failed or successful.
abstract class Either<L, R> extends Equatable {
  const Either();

  E fold<E>(E Function(L) ifLeft, E Function(R) ifRight);

  bool isLeft() => fold((_) => true, (_) => false);
  bool isRight() => fold((_) => false, (_) => true);

  L getLeft() => fold(
      (leftValue) => leftValue, (_) => throw UnimplementedError("getLeft"));

  R getRight() => fold(
      (_) => throw UnimplementedError("getRight"), (rightValue) => rightValue);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifLeft(value);

  @override
  List<Object?> get props => [value];
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifRight(value);

  @override
  List<Object?> get props => [value];
}

/// this function wraps a future and map it exceptions to failures
Future<Either<Failure, T>> runGuard<T>(
  Future<T> Function() future,
) async {
  try {
    final result = await future();
    return Right(result);
  } catch (e) {
    // safePrint(e.toString());
    // Handle all and map all exceptions to failure here
    if (e is ServerException) {
      return Left(ServerFailure(e.message));
    }
    if (e is InvalidArgOrDataException) {
      return Left(InvalidArgOrDataFailure());
    }
    if (e is CacheGetException) {
      return Left(CacheFailure(e.message));
    }
    if (e is CachePutException) {
      return Left(CacheFailure(e.message));
    }
    return Left(UnexpectedFailure());
  }
}

/// this is a [stream] version of runGuard
Stream<Either<Failure, T>> runSGuard<T>(
  Stream<T> Function() stream,
) async* {
  try {
    await for (final result in stream()) {
      yield Right(result);
    }
  } catch (e) {
    safePrint(e.toString());
    // Handle all and map all exceptions to failure here
    if (e is ServerException) {
      yield Left(ServerFailure(e.message));
    }
    if (e is InvalidArgOrDataException) {
      yield Left(InvalidArgOrDataFailure());
    }
    if (e is CacheGetException) {
      yield Left(CacheFailure(e.message));
    }
    if (e is CachePutException) {
      yield Left(CacheFailure(e.message));
    }
    yield Left(UnexpectedFailure());
  }
}

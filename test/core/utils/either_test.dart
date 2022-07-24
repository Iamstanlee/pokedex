import 'package:bayzat_pokedex/core/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Either', () {
    group('.Left', () {
      test('should return left value', () {
        const value = 'left';
        const either = Left(value);
        expect(either.isLeft(), isTrue);
        expect(either.isRight(), isFalse);
        expect(either.fold((_) => value, (_) => 'right'), value);
        expect(either.value, value);
      });
    });
    group('.Right', () {
      test('should return right value', () {
        const value = 'right';
        const either = Right(value);
        expect(either.isLeft(), isFalse);
        expect(either.isRight(), isTrue);
        expect(either.fold((_) => 'left', (_) => value), value);
        expect(either.value, value);
      });
    });

    group('.runGuard', () {
      test('should return right value', () async {
        const value = 10;
        final failureOrInt = await runGuard(() => Future.value(value));
        expect(failureOrInt.isLeft(), isFalse);
        expect(failureOrInt.isRight(), isTrue);
        expect(failureOrInt.getRight(), value);
      });

      test('should return Failure', () async {
        final failureOrInt = await runGuard(() => Future.error(Exception()));
        expect(failureOrInt.isLeft(), isTrue);
        expect(failureOrInt.isRight(), isFalse);
      });
    });

    group('.runSGuard', () {
      test('should return right stream value', () async {
        const value = 10;
        final failureOrInt = runSGuard(() => Stream.value(value));
        failureOrInt.listen(
          expectAsync1((value) {
            expect(value.isLeft(), isFalse);
            expect(value.isRight(), isTrue);
          }),
        );
      });
      test('should return Failure', () async {
        final failureOrInt = runSGuard(() => Stream.error(Exception()));
        failureOrInt.listen(
          expectAsync1((value) {
            expect(value.isLeft(), isTrue);
            expect(value.isRight(), isFalse);
          }),
        );
      });
    });
  });
}

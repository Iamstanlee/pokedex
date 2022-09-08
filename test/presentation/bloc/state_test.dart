import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/presentation/bloc/state.dart';

void main() {
  group("BlocState", () {
    test("initializedCorrectly", () {
      final blocState = BlocState.initial(10);
      expect(blocState.data, 10);
      expect(blocState.status, PageStatusType.none);
      expect(blocState.error, null);
    });

    test(".copyWith()", () {
      final blocState = BlocState.initial(10).copyWith().copyWith(data: 20);
      expect(blocState.data, 20);
    });

    test(".copyWith() with status", () {
      final blocState =
          BlocState.initial(10).copyWith(status: PageStatusType.ready);
      expect(blocState.data, 10);
      expect(blocState.isError, isFalse);
      expect(blocState.isReady, isTrue);
    });

    test(".copyWith() with error", () {
      final blocState = BlocState.initial(10).copyWith(
        status: PageStatusType.error,
        error: "error",
      );
      expect(blocState.data, 10);
      expect(blocState.isError, isTrue);
    });
  });
}

import 'package:bayzat_pokedex/core/utils/extension/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('.capitalize', () {
    final str = 'Hello World'.capitalize();
    final str2 = 'hello world'.capitalize();
    expect(str, 'Hello World');
    expect(str2, 'Hello world');
  });

  test('.toTitleCase', () {
    final str = 'hello world'.toTitleCase();
    final str2 = 'Hello world'.toTitleCase();
    final str3 = 'hello World'.toTitleCase();
    expect(str, 'Hello World');
    expect(str2, 'Hello World');
    expect(str3, 'Hello World');
  });

  test('.toInt', () {
    final str = '123'.toInt();
    final str2 = '123.45'.toInt();
    final str3 = '123a'.toInt();
    expect(str, 123);
    expect(str2, -1);
    expect(str3, -1);
  });
}

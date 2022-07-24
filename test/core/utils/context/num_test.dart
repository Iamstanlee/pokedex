import 'package:bayzat_pokedex/core/utils/extension/num.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('.interpolate', () {
    final value = 50.interpolate(0, 100, upperBound: 1);
    expect(value, 0.5);
  });
}

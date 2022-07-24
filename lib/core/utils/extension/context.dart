import "package:flutter/material.dart";

extension ContextExtension on BuildContext {
  double getHeight([double factor = 1]) {
    assert(factor != 0);
    return MediaQuery.of(this).size.height * factor;
  }

  double getWidth([double factor = 1]) {
    assert(factor != 0);
    return MediaQuery.of(this).size.width * factor;
  }

  double get height => getHeight();
  double get width => getWidth();

  Future<T?> push<T>(Widget page) => Navigator.push<T>(
        this,
        MaterialPageRoute(builder: (context) => page),
      );

  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}

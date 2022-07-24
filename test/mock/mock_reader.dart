import 'dart:io';

String mockData(String name) => File('test/mock/$name').readAsStringSync();

import 'dart:async';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:hive/hive.dart';
import 'package:pokedex/core/error/exception.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IPokedexLocalDataSource {
  Stream<List<Pokemon>> getAllPokemon();
  Future<void> savePokemon(Pokemon pokemon);
  Future<void> deletePokemon(int id);
}

class PokedexLocalDataSource implements IPokedexLocalDataSource {
  final Box<Pokemon> box;
  PokedexLocalDataSource(this.box) : assert(box.isOpen);

  @override
  Stream<List<Pokemon>> getAllPokemon() async* {
    try {
      yield box.values.toList();
      await for (final _ in box.watch()) {
        yield box.values.toList();
      }
    } catch (error) {
      throw CacheGetException("$error");
    }
  }

  @override
  Future<void> savePokemon(Pokemon pokemon) async {
    try {
      unawaited(box.put(pokemon.id, pokemon));
    } catch (error) {
      throw CachePutException("$error");
    }
  }

  @override
  Future<void> deletePokemon(int id) async {
    try {
      unawaited(box.delete(id));
    } catch (error) {
      throw CachePutException("$error");
    }
  }
}

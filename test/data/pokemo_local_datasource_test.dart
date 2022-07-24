import 'package:bayzat_pokedex/core/error/exception.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/data/pokemon_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveBox<T> extends Mock implements Box<T> {}

void main() {
  late Box<Pokemon> box;
  late IPokedexLocalDataSource pokedexLocalDataSource;
  late Pokemon pokemon;
  setUp(() {
    box = MockHiveBox<Pokemon>();
    when(() => box.isOpen).thenReturn(true);
    pokedexLocalDataSource = PokedexLocalDataSource(box);
    pokemon = Pokemon.empty();
    registerFallbackValue(pokemon);
  });

  group('.getAllPokemon', () {
    test('should emit an empty list when box is empty', () async {
      when(() => box.values).thenAnswer((_) => []);
      final stream = pokedexLocalDataSource.getAllPokemon();
      await expectLater(stream, emitsInOrder([]));
    });

    test('should emit a list of pokemon when box is not empty', () async {
      final pokemonList = [pokemon];
      when(() => box.values).thenAnswer((_) => pokemonList);
      final stream = pokedexLocalDataSource.getAllPokemon();
      await expectLater(stream, emitsInOrder([pokemonList]));
    });
  });

  group('.savePokemon', () {
    test('should save a pokemon', () async {
      when(() => box.put(any(), any())).thenAnswer((_) => Future<void>.value());
      await pokedexLocalDataSource.savePokemon(pokemon);
      verify(() => box.put(pokemon.id, pokemon)).called(1);
    });

    test('should throw an exception when box is not open', () async {
      when(() => box.isOpen).thenReturn(false);
      final future = pokedexLocalDataSource.savePokemon(pokemon);
      await expectLater(future, throwsA(isA<CachePutException>()));
    });
  });
  group('.deletePokemon', () {
    test('should delete a pokemon', () async {
      when(() => box.delete(any())).thenAnswer((_) => Future<void>.value());
      await pokedexLocalDataSource.deletePokemon(pokemon.id);
      verify(() => box.delete(pokemon.id)).called(1);
    });

    test('should throw an exception when box is not open', () async {
      when(() => box.isOpen).thenReturn(false);
      final future = pokedexLocalDataSource.deletePokemon(pokemon.id);
      await expectLater(future, throwsA(isA<CachePutException>()));
    });
  });
}

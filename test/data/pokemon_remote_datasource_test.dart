import 'dart:convert';

import 'package:pokedex/core/manager/http_manager.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/data/pokemon_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock_reader.dart';

class MockHttpManager extends Mock implements HttpManager {}

void main() {
  late HttpManager httpManager;
  late IPokedexRemoteDataSource pokedexRemoteDataSource;

  setUp(() {
    httpManager = MockHttpManager();
    pokedexRemoteDataSource = PokedexRemoteDataSource(httpManager);
  });
  group('.getAllPokemon', () {
    test('should return pokemon data', () async {
      final json = mockData("pokemon_response.json");
      when(() => httpManager.get(any()))
          .thenAnswer((_) => Future.value(jsonDecode(json)));
      final result = await pokedexRemoteDataSource.getAllPokemon(1);
      expect(result, isA<List<Pokemon>>());
      for (int i = 0; i < result.length; i++) {
        final pokemon = result[i];
        expect(pokemon.id, isNot(-1));
      }
    });
  });

  group('.getPokemon', () {
    test('should return pokemon data', () async {
      final json = {
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/1/'
      };
      when(() => httpManager.get(any()))
          .thenAnswer((_) => Future<Map<String, dynamic>>.value(json));
      final result = await pokedexRemoteDataSource.getPokemon(1);
      expect(result, isA<Pokemon>());
    });
  });
}

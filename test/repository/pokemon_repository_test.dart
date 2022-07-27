import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/data/pokemon_remote_datasource.dart';
import 'package:pokedex/repository/pokemon_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPokemonRemoteDataSource extends Mock
    implements PokedexRemoteDataSource {}

void main() {
  late IPokedexRemoteDataSource pokemonRemoteDataSource;
  late PokemonRepository pokemonRepository;

  setUp(() {
    pokemonRemoteDataSource = MockPokemonRemoteDataSource();
    pokemonRepository = PokemonRepository(pokemonRemoteDataSource);
  });

  group('.getAllPokemon', () {
    test('should return pokemon data', () async {
      when(() => pokemonRemoteDataSource.getAllPokemon(any()))
          .thenAnswer((_) async => <Pokemon>[]);
      final result = await pokemonRepository.getAllPokemon(0);
      expect(result.isRight(), isTrue);
    });

    test('should return error', () async {
      when(() => pokemonRemoteDataSource.getAllPokemon(any()))
          .thenThrow(Exception());
      final result = await pokemonRepository.getAllPokemon(0);
      expect(result.isLeft(), isTrue);
    });
  });

  group('.getPokemon', () {
    test('should return pokemon data', () async {
      when(() => pokemonRemoteDataSource.getPokemon(any()))
          .thenAnswer((_) async => Pokemon.empty());
      final result = await pokemonRepository.getPokemon(1);
      expect(result.isRight(), isTrue);
    });

    test('should return error', () async {
      when(() => pokemonRemoteDataSource.getPokemon(any()))
          .thenThrow(Exception());
      final result = await pokemonRepository.getPokemon(1);
      expect(result.isLeft(), isTrue);
    });
  });
}

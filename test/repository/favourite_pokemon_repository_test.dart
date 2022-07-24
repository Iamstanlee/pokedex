import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/data/pokemon_local_datasource.dart';
import 'package:bayzat_pokedex/repository/favourite_pokemon_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPokemonLocalDataSource extends Mock
    implements PokedexLocalDataSource {}

void main() {
  late IPokedexLocalDataSource pokedexLocalDataSource;
  late FavouritePokemonRepository pokemonRepository;
  late Pokemon pokemon;

  setUp(() {
    pokedexLocalDataSource = MockPokemonLocalDataSource();
    pokemonRepository = FavouritePokemonRepository(pokedexLocalDataSource);
    pokemon = Pokemon.empty();
    registerFallbackValue(pokemon);
  });

  group('.getAllPokemon', () {
    test('should return pokemon data', () async {
      when(() => pokedexLocalDataSource.getAllPokemon())
          .thenAnswer((_) => Stream.value([pokemon]));
      final stream = pokemonRepository.getAllPokemon();
      stream.listen(
        expectAsync1(
          (result) {
            expect(result.isRight(), isTrue);
          },
        ),
      );
    });

    test('should return error', () async {
      when(() => pokedexLocalDataSource.getAllPokemon()).thenThrow(Exception());
      final stream = pokemonRepository.getAllPokemon();
      stream.listen(
        expectAsync1(
          (result) {
            expect(result.isLeft(), isTrue);
          },
        ),
      );
    });
  });

  group('.savePokemon', () {
    test('should return pokemon data', () async {
      when(() => pokedexLocalDataSource.savePokemon(any()))
          .thenAnswer((_) => Future.value());
      final result = await pokemonRepository.savePokemon(pokemon);
      expect(result.isRight(), isTrue);
    });

    test('should return error', () async {
      when(() => pokedexLocalDataSource.savePokemon(any()))
          .thenThrow(Exception());
      final result = await pokemonRepository.savePokemon(pokemon);
      expect(result.isLeft(), isTrue);
    });
  });

  group('.deletePokemon', () {
    test('should return pokemon data', () async {
      when(() => pokedexLocalDataSource.deletePokemon(any()))
          .thenAnswer((_) => Future.value());
      final result = await pokemonRepository.deletePokemon(0);
      expect(result.isRight(), isTrue);
    });

    test('should return error', () async {
      when(() => pokedexLocalDataSource.deletePokemon(any()))
          .thenThrow(Exception());
      final result = await pokemonRepository.deletePokemon(0);
      expect(result.isLeft(), isTrue);
    });
  });
}

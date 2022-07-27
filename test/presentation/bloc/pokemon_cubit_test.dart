import 'package:pokedex/core/error/failure.dart';
import 'package:pokedex/core/utils/either.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/pokemon_cubit.dart';
import 'package:pokedex/repository/pokemon_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late PokemonCubit pokemonCubit;
  late PokemonRepository pokemonRepository;
  late Pokemon pokemon;
  setUp(() {
    pokemonRepository = MockPokemonRepository();
    pokemonCubit = PokemonCubit(
      pokemonRepository: pokemonRepository,
    );
    pokemon = Pokemon.empty();
    registerFallbackValue(pokemon);
  });
  group('.getAllPokemon', () {
    blocTest<PokemonCubit, PokemonState>(
      'should emit loaded state and return pokemon data',
      setUp: () {
        when(() => pokemonRepository.getAllPokemon(any())).thenAnswer(
          (_) async => Right([Pokemon.empty()]),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemonList(),
      expect: () => [
        PokemonState.initial().copyWith(
          status: PokemonStatus.loading,
        ),
        PokemonState.initial().copyWith(
          status: PokemonStatus.loaded,
          pokemonList: [Pokemon.empty()],
        ),
      ],
    );

    blocTest<PokemonCubit, PokemonState>(
      'should emit error state and return error',
      setUp: () {
        when(() => pokemonRepository.getAllPokemon(any())).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemonList(),
      expect: () => [
        PokemonState.initial().copyWith(
          status: PokemonStatus.loading,
        ),
        PokemonState.initial().copyWith(
          status: PokemonStatus.error,
          error: ServerFailure().message,
        ),
      ],
    );
  });

  group('.getNextPokemonList', () {
    blocTest<PokemonCubit, PokemonState>(
      'should emit loaded state and return next page of pokemon data',
      setUp: () {
        when(() => pokemonRepository.getAllPokemon(any())).thenAnswer(
          (_) async => Right([Pokemon.empty()]),
        );
      },
      build: () => pokemonCubit,
      seed: () => PokemonState.initial().copyWith(
        status: PokemonStatus.loaded,
        pokemonList: [Pokemon.empty()],
      ),
      act: (bloc) => bloc.getNextPokemonList(),
      expect: () => [
        PokemonState.initial().copyWith(
          status: PokemonStatus.loading,
          pokemonList: [Pokemon.empty()],
        ),
        PokemonState.initial().copyWith(
          status: PokemonStatus.loaded,
          pokemonList: [Pokemon.empty(), Pokemon.empty()],
        ),
      ],
    );
  });

  group('.getPokemon', () {
    blocTest<PokemonCubit, PokemonState>(
      'should emit loaded state and return pokemon data',
      setUp: () {
        when(() => pokemonRepository.getPokemon(any())).thenAnswer(
          (_) async => Right(Pokemon.empty()),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemon(1),
      expect: () => [
        PokemonState.initial().copyWith(
          status: PokemonStatus.loading,
        ),
        PokemonState.initial().copyWith(
          status: PokemonStatus.loaded,
          pokemon: Pokemon.empty(),
        ),
      ],
    );

    blocTest<PokemonCubit, PokemonState>(
      'should emit error state and return error',
      setUp: () {
        when(() => pokemonRepository.getPokemon(any())).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemon(1),
      expect: () => [
        PokemonState.initial().copyWith(
          status: PokemonStatus.loading,
        ),
        PokemonState.initial().copyWith(
          status: PokemonStatus.error,
          error: ServerFailure().message,
        ),
      ],
    );
  });
}

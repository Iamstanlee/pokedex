import 'package:pokedex/core/error/failure.dart';
import 'package:pokedex/core/utils/either.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/pokemon_cubit.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/repository/pokemon_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/pokemon.dart';

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
    pokemon = mockPokemon;
    registerFallbackValue(pokemon);
  });
  group('.getPokemons', () {
    blocTest<PokemonCubit, BlocState<List<Pokemon>>>(
      'should emit ready state and return pokemon data',
      setUp: () {
        when(() => pokemonRepository.getAllPokemon(any())).thenAnswer(
          (_) async => Right([mockPokemon]),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemons(),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.loading,
        ),
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.ready,
          data: [mockPokemon],
        ),
      ],
    );

    blocTest<PokemonCubit, BlocState<List<Pokemon>>>(
      'should emit error state and return error',
      setUp: () {
        when(() => pokemonRepository.getAllPokemon(any())).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemons(),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.loading,
        ),
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.error,
          error: ServerFailure().message,
        ),
      ],
    );
  });

  group('.getNextPokemonList', () {
    blocTest<PokemonCubit, BlocState<List<Pokemon>>>(
      'should emit ready state and return next page of pokemon data',
      setUp: () {
        when(() => pokemonRepository.getAllPokemon(any())).thenAnswer(
          (_) async => Right([mockPokemon]),
        );
      },
      build: () => pokemonCubit,
      seed: () => BlocState.initial(const <Pokemon>[]).copyWith(
        status: PageStatusType.ready,
        data: [mockPokemon],
      ),
      act: (bloc) => bloc.getMorePokemons(),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.loadingMore,
          data: [mockPokemon],
        ),
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.ready,
          data: [mockPokemon, mockPokemon],
        ),
      ],
    );
  });

  group('.getPokemon', () {
    final testPokemon = mockPokemon.copyWith(id: 1);
    blocTest<PokemonCubit, BlocState<List<Pokemon>>>(
      'should emit ready state and return additional data for pokemon',
      setUp: () {
        when(() => pokemonRepository.getPokemon(any())).thenAnswer(
          (_) async => Right(mockPokemon.copyWith(height: 10, weight: 20)),
        );
      },
      build: () => pokemonCubit,
      seed: () => BlocState.initial(const <Pokemon>[]).copyWith(
        status: PageStatusType.ready,
        data: [testPokemon],
      ),
      act: (bloc) => bloc.getPokemon(testPokemon.id),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.loading,
          data: [testPokemon],
        ),
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.ready,
          data: [testPokemon],
        ),
      ],
      verify: (bloc) => bloc.state.data[0].hasAdditionalInfo,
    );

    blocTest<PokemonCubit, BlocState<List<Pokemon>>>(
      'should emit error state and return error',
      setUp: () {
        when(() => pokemonRepository.getPokemon(any())).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      build: () => pokemonCubit,
      act: (bloc) => bloc.getPokemon(1),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.loading,
        ),
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.error,
          error: ServerFailure().message,
        ),
      ],
    );
  });
}

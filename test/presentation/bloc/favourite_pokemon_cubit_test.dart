import 'package:pokedex/core/error/failure.dart';
import 'package:pokedex/core/utils/either.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/repository/favourite_pokemon_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/pokemon.dart';

class MockFavouritePokemonRepository extends Mock
    implements FavouritePokemonRepository {}

void main() {
  late FavouritePokemonCubit favouritePokemonCubit;
  late FavouritePokemonRepository favouritePokemonRepository;
  late Pokemon pokemon;
  setUp(() {
    favouritePokemonRepository = MockFavouritePokemonRepository();
    favouritePokemonCubit = FavouritePokemonCubit(
      pokemonRepository: favouritePokemonRepository,
    );
    pokemon = mockPokemon;
    registerFallbackValue(pokemon);
  });
  group('.getFavouritePokemonList', () {
    blocTest<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
      'should emit ready state and return pokemon data',
      setUp: () {
        when(() => favouritePokemonRepository.getAllPokemon()).thenAnswer(
          (_) => Stream.value(Right([mockPokemon])),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.getFavouritePokemons(),
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

    blocTest<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
      'should emit error state and return error',
      setUp: () {
        when(() => favouritePokemonRepository.getAllPokemon()).thenAnswer(
          (_) => Stream.value(Left(CacheFailure())),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.getFavouritePokemons(),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.loading,
        ),
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.error,
          error: CacheFailure().message,
        ),
      ],
    );
  });

  group('.addPokemon', () {
    blocTest<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
        'verify that pokemon is added to favourite list',
        setUp: () {
          when(() => favouritePokemonRepository.savePokemon(any())).thenAnswer(
            // ignore: void_checks
            (_) async => Right(Future.value()),
          );
        },
        build: () => favouritePokemonCubit,
        act: (bloc) => bloc.addPokemon(pokemon),
        verify: (_) {
          verify(
            () => favouritePokemonRepository.savePokemon(any()),
          ).called(1);
        });

    blocTest<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
      'should emit error state and return error when cache failure occur',
      setUp: () {
        when(() => favouritePokemonRepository.savePokemon(any())).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.addPokemon(pokemon),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.error,
          error: CacheFailure().message,
        ),
      ],
    );
  });

  group('.removePokemon', () {
    blocTest<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
        'verify that pokemon is removed from favourite list',
        setUp: () {
          when(() => favouritePokemonRepository.deletePokemon(any()))
              .thenAnswer(
            // ignore: void_checks
            (_) async => Right(Future.value()),
          );
        },
        build: () => favouritePokemonCubit,
        act: (bloc) => bloc.removePokemon(pokemon.id),
        verify: (_) {
          verify(
            () => favouritePokemonRepository.deletePokemon(any()),
          ).called(1);
        });

    blocTest<FavouritePokemonCubit, BlocState<List<Pokemon>>>(
      'should emit error state and return error when cache failure occur',
      setUp: () {
        when(() => favouritePokemonRepository.deletePokemon(any())).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.removePokemon(pokemon.id),
      expect: () => [
        BlocState.initial(const <Pokemon>[]).copyWith(
          status: PageStatusType.error,
          error: CacheFailure().message,
        ),
      ],
    );
  });
}

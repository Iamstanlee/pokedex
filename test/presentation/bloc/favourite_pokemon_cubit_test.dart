import 'package:bayzat_pokedex/core/error/failure.dart';
import 'package:bayzat_pokedex/core/utils/either.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/presentation/bloc/favourite_pokemom_cubit.dart';
import 'package:bayzat_pokedex/repository/favourite_pokemon_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
    pokemon = Pokemon.empty();
    registerFallbackValue(pokemon);
  });
  group('.getFavouritePokemonList', () {
    blocTest<FavouritePokemonCubit, FavouritePokemonState>(
      'should emit loaded state and return pokemon data',
      setUp: () {
        when(() => favouritePokemonRepository.getAllPokemon()).thenAnswer(
          (_) => Stream.value(Right([Pokemon.empty()])),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.getFavouritePokemonList(),
      expect: () => [
        const FavouritePokemonState(status: FavouritePokemonStatus.loading),
        FavouritePokemonState(
          status: FavouritePokemonStatus.loaded,
          favouritePokemonList: [Pokemon.empty()],
        ),
      ],
    );

    blocTest<FavouritePokemonCubit, FavouritePokemonState>(
      'should emit error state and return error',
      setUp: () {
        when(() => favouritePokemonRepository.getAllPokemon()).thenAnswer(
          (_) => Stream.value(Left(CacheFailure())),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.getFavouritePokemonList(),
      expect: () => [
        const FavouritePokemonState(status: FavouritePokemonStatus.loading),
        FavouritePokemonState(
          status: FavouritePokemonStatus.error,
          error: CacheFailure().message,
        ),
      ],
    );
  });

  group('.addPokemon', () {
    blocTest<FavouritePokemonCubit, FavouritePokemonState>(
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

    blocTest<FavouritePokemonCubit, FavouritePokemonState>(
      'should emit error state and return error when cache failure occur',
      setUp: () {
        when(() => favouritePokemonRepository.savePokemon(any())).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.addPokemon(pokemon),
      expect: () => [
        FavouritePokemonState(
          status: FavouritePokemonStatus.error,
          error: CacheFailure().message,
        ),
      ],
    );
  });

  group('.removePokemon', () {
    blocTest<FavouritePokemonCubit, FavouritePokemonState>(
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

    blocTest<FavouritePokemonCubit, FavouritePokemonState>(
      'should emit error state and return error when cache failure occur',
      setUp: () {
        when(() => favouritePokemonRepository.deletePokemon(any())).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      build: () => favouritePokemonCubit,
      act: (bloc) => bloc.removePokemon(pokemon.id),
      expect: () => [
        FavouritePokemonState(
          status: FavouritePokemonStatus.error,
          error: CacheFailure().message,
        ),
      ],
    );
  });
}

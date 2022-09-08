import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/repository/favourite_pokemon_repository.dart';
import 'package:pokedex/data/model/pokemon.dart';

class FavouritePokemonCubit extends Cubit<BlocState<List<Pokemon>>> {
  final FavouritePokemonRepository pokemonRepository;

  FavouritePokemonCubit({required this.pokemonRepository})
      : super(BlocState.initial(const []));

  void getFavouritePokemons() async {
    emit(state.copyWith(status: PageStatusType.loading));
    pokemonRepository.getAllPokemon().listen(
      (failureOrPokemons) {
        failureOrPokemons.fold(
          (failure) => emit(
            state.copyWith(
              status: PageStatusType.error,
              error: failure.message,
            ),
          ),
          (pokemons) {
            emit(
              state.copyWith(
                status: PageStatusType.ready,
                data: pokemons,
              ),
            );
          },
        );
      },
    );
  }

  void addPokemon(Pokemon pokemon) async {
    final failureOrSuccess = await pokemonRepository.savePokemon(pokemon);
    if (failureOrSuccess.isLeft()) {
      emit(
        state.copyWith(
          status: PageStatusType.error,
          error: failureOrSuccess.getLeft().message,
        ),
      );
    }
  }

  void removePokemon(int id) async {
    final failureOrSuccess = await pokemonRepository.deletePokemon(id);
    if (failureOrSuccess.isLeft()) {
      emit(
        state.copyWith(
          status: PageStatusType.error,
          error: failureOrSuccess.getLeft().message,
        ),
      );
    }
  }
}

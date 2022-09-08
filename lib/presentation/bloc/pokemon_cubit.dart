import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/presentation/bloc/state.dart';
import 'package:pokedex/repository/pokemon_repository.dart';

class PokemonCubit extends Cubit<BlocState<List<Pokemon>>> {
  final PokemonRepository pokemonRepository;
  PokemonCubit({required this.pokemonRepository})
      : super(BlocState.initial(const []));

  int _offset = 0;

  void getPokemons(
      {PageStatusType bootstrapStatus = PageStatusType.loading}) async {
    emit(state.copyWith(status: bootstrapStatus));
    final failureOrPokemons = await pokemonRepository.getAllPokemon(_offset);
    failureOrPokemons.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          status: PageStatusType.error,
        ),
      ),
      (pokemons) {
        emit(
          state.copyWith(
            data: state.data.followedBy(pokemons).toList(),
            status: PageStatusType.ready,
          ),
        );
      },
    );
  }

  void getMorePokemons() async {
    if (!state.isLoading) {
      _offset += 24;
      getPokemons(bootstrapStatus: PageStatusType.loadingMore);
    }
  }

  void getPokemon(int id) async {
    emit(
      state.copyWith(status: PageStatusType.loading),
    );
    final failureOrPokemons = await pokemonRepository.getPokemon(id);
    failureOrPokemons.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          status: PageStatusType.error,
        ),
      ),
      (pokemon) {
        emit(
          state.copyWith(
            status: PageStatusType.ready,
            // update the pokemon in the list with latest data
            data: state.data
                .map((e) => e.id == pokemon.id ? pokemon : e)
                .toList(),
          ),
        );
      },
    );
  }
}

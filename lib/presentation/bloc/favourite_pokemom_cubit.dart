import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/repository/favourite_pokemon_repository.dart';
import 'package:pokedex/data/model/pokemon.dart';

class FavouritePokemonCubit extends Cubit<FavouritePokemonState> {
  final FavouritePokemonRepository pokemonRepository;

  FavouritePokemonCubit({required this.pokemonRepository})
      : super(const FavouritePokemonState());

  void getFavouritePokemonList() async {
    emit(state.copyWith(status: FavouritePokemonStatus.loading));

    pokemonRepository.getAllPokemon().listen((failureOrPokemonList) {
      failureOrPokemonList.fold(
          (failure) => emit(
                state.copyWith(
                  status: FavouritePokemonStatus.error,
                  error: failure.message,
                ),
              ), (pokemonList) {
        emit(state.copyWith(
          status: FavouritePokemonStatus.loaded,
          favouritePokemonList: pokemonList,
        ));
      });
    });
  }

  void addPokemon(Pokemon pokemon) async {
    final failureOrSuccess = await pokemonRepository.savePokemon(pokemon);
    if (failureOrSuccess.isLeft()) {
      emit(
        state.copyWith(
            status: FavouritePokemonStatus.error,
            error: failureOrSuccess.getLeft().message),
      );
    }
  }

  void removePokemon(int id) async {
    final failureOrSuccess = await pokemonRepository.deletePokemon(id);
    if (failureOrSuccess.isLeft()) {
      emit(
        state.copyWith(
            status: FavouritePokemonStatus.error,
            error: failureOrSuccess.getLeft().message),
      );
    }
  }
}

enum FavouritePokemonStatus {
  initial,
  loading,
  loaded,
  error,
}

extension FavouritePokemonStatusExtension on FavouritePokemonStatus {
  bool get isInitial => this == FavouritePokemonStatus.initial;
  bool get isLoading => this == FavouritePokemonStatus.loading;
  bool get isLoaded => this == FavouritePokemonStatus.loaded;
  bool get isError => this == FavouritePokemonStatus.error;
}

class FavouritePokemonState extends Equatable {
  final List<Pokemon> favouritePokemonList;
  final String? error;
  final FavouritePokemonStatus status;

  const FavouritePokemonState({
    this.error,
    this.status = FavouritePokemonStatus.initial,
    this.favouritePokemonList = const [],
  });

  FavouritePokemonState copyWith({
    Pokemon? pokemon,
    String? error,
    FavouritePokemonStatus? status,
    List<Pokemon>? favouritePokemonList,
  }) {
    return FavouritePokemonState(
      error: error ?? this.error,
      status: status ?? this.status,
      favouritePokemonList: favouritePokemonList ?? this.favouritePokemonList,
    );
  }

  @override
  List<Object?> get props => [
        favouritePokemonList,
        status,
        error,
      ];
}

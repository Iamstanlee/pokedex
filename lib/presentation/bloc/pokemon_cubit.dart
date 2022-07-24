import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/repository/pokemon_repository.dart';

class PokemonCubit extends Cubit<PokemonState> {
  final PokemonRepository pokemonRepository;
  PokemonCubit({required this.pokemonRepository})
      : super(PokemonState.initial());

  int _offset = 0;

  void getPokemonList() async {
    emit(state.copyWith(status: PokemonStatus.loading));
    final failureOrPokemonList = await pokemonRepository.getAllPokemon(_offset);
    failureOrPokemonList.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          status: PokemonStatus.error,
        ),
      ),
      (pokemonList) {
        emit(
          state.copyWith(
            pokemonList: state.pokemonList.followedBy(pokemonList).toList(),
            status: PokemonStatus.loaded,
          ),
        );
      },
    );
  }

  void getNextPokemonList() async {
    if (!state.status.isLoading) {
      _offset += state.pokemonList.length;
      getPokemonList();
    }
  }

  void getPokemon(int id) async {
    emit(
      state.copyWith(
        status: PokemonStatus.loading,
        pokemon: Pokemon.empty(),
      ),
    );
    final failureOrPokemonList = await pokemonRepository.getPokemon(id);
    failureOrPokemonList.fold(
      (failure) => emit(
        state.copyWith(
          error: failure.message,
          status: PokemonStatus.error,
        ),
      ),
      (pokemon) {
        emit(
          state.copyWith(
            pokemon: pokemon,
            status: PokemonStatus.loaded,
          ),
        );
      },
    );
  }
}

enum PokemonStatus {
  initial,
  loading,
  loaded,
  error,
}

extension PokemonStatusExtension on PokemonStatus {
  bool get isInitial => this == PokemonStatus.initial;
  bool get isLoading => this == PokemonStatus.loading;
  bool get isLoaded => this == PokemonStatus.loaded;
  bool get isError => this == PokemonStatus.error;
}

class PokemonState extends Equatable {
  final Pokemon pokemon;
  final List<Pokemon> pokemonList;
  final String error;
  final PokemonStatus status;
  const PokemonState({
    required this.pokemon,
    required this.pokemonList,
    required this.status,
    this.error = "",
  });

  factory PokemonState.initial() => PokemonState(
        status: PokemonStatus.initial,
        pokemon: Pokemon.empty(),
        pokemonList: const [],
      );

  PokemonState copyWith({
    Pokemon? pokemon,
    String? error,
    PokemonStatus? status,
    List<Pokemon>? pokemonList,
  }) {
    return PokemonState(
      pokemon: pokemon ?? this.pokemon,
      error: error ?? this.error,
      status: status ?? this.status,
      pokemonList: pokemonList ?? this.pokemonList,
    );
  }

  @override
  List<Object?> get props => [
        pokemonList,
        pokemon,
        status,
        error,
      ];
}

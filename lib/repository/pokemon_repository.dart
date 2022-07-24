import 'package:bayzat_pokedex/core/error/failure.dart';
import 'package:bayzat_pokedex/core/utils/either.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:bayzat_pokedex/data/pokemon_remote_datasource.dart';

class PokemonRepository {
  final IPokedexRemoteDataSource pokemonRemoteDataSource;
  PokemonRepository(this.pokemonRemoteDataSource);

  Future<Either<Failure, List<Pokemon>>> getAllPokemon(int offset) =>
      runGuard(() async {
        final pokemonList = await pokemonRemoteDataSource.getAllPokemon(offset);
        // we might want to cache some data here
        return pokemonList;
      });

  Future<Either<Failure, Pokemon>> getPokemon(int id) => runGuard(() async {
        final pokemon = await pokemonRemoteDataSource.getPokemon(id);
        return pokemon;
      });
}

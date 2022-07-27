import 'package:pokedex/core/error/failure.dart';
import 'package:pokedex/core/utils/either.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:pokedex/data/pokemon_local_datasource.dart';

class FavouritePokemonRepository {
  final IPokedexLocalDataSource pokedexLocalDataSource;
  FavouritePokemonRepository(this.pokedexLocalDataSource);

  Stream<Either<Failure, List<Pokemon>>> getAllPokemon() async* {
    yield* runSGuard(() => pokedexLocalDataSource.getAllPokemon());
  }

  Future<Either<Failure, void>> savePokemon(Pokemon pokemon) =>
      runGuard(() async {
        await pokedexLocalDataSource.savePokemon(pokemon);
        return;
      });

  Future<Either<Failure, void>> deletePokemon(int id) => runGuard(() async {
        await pokedexLocalDataSource.deletePokemon(id);
        return;
      });
}

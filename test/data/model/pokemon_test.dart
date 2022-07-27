import 'package:pokedex/data/model/pokemon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Pokemon.empty()", () {
    final pokemon = Pokemon.empty();
    expect(pokemon.bmi, 0);
    expect(pokemon.averagePower, 0);
    expect(pokemon.pokedexId, "#000");
    expect(pokemon.baseType, "");
  });

  test("Pokemon", () {
    const pokemon = Pokemon(
      id: 1,
      name: "Bulbasaur",
      weight: 69,
      height: 10,
      stats: [
        PokemonStat(
            stat: PokemonNameAndUrlDatum("attack", ""),
            baseStat: 50,
            effort: 0),
        PokemonStat(
          stat: PokemonNameAndUrlDatum("defense", ""),
          baseStat: 50,
          effort: 0,
        ),
      ],
      types: [
        PokemonType(
          type: PokemonNameAndUrlDatum("grass", ""),
          slot: 1,
        ),
        PokemonType(
          type: PokemonNameAndUrlDatum("poison", ""),
          slot: 2,
        ),
      ],
    );
    expect(pokemon.bmi, 0.69);
    expect(pokemon.averagePower, 50);
    expect(pokemon.pokedexId, "#001");
    expect(pokemon.baseType, "grass");
  });
}

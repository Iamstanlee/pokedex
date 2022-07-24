import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'pokemon.g.dart';

@HiveType(typeId: 0)
class Pokemon extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(3)
  final num weight;

  @HiveField(4)
  final num height;

  @HiveField(5)
  final List<PokemonStat> stats;

  @HiveField(6)
  final List<PokemonType> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.stats,
    required this.types,
  });

  factory Pokemon.empty() => const Pokemon(
        name: "",
        id: 0,
        weight: 0,
        height: 0,
        stats: [],
        types: [],
      );

  bool get isEmpty => this == Pokemon.empty();

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  String get pokedexId => "#${id.toString().padLeft(3, '0')}";

  String get baseType {
    return types.isNotEmpty ? types[0].type.name : "";
  }

  double get bmi {
    if (height == 0 || weight == 0) return 0;
    return (weight / (height * height));
  }

  double get averagePower {
    if (stats.isEmpty) return 0;
    return stats.map((stat) => stat.baseStat).reduce((a, b) => a + b) /
        stats.length;
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'] ?? 0,
      weight: map['weight'] ?? 0,
      height: map['height'] ?? 0,
      name: map['name'] ?? "",
      stats: map['stats'] != null
          ? (map['stats'] as List)
              .map((stat) => PokemonStat.fromMap(stat))
              .toList()
          : [],
      types: map['types'] != null
          ? (map['types'] as List)
              .map((type) => PokemonType.fromMap(type))
              .toList()
          : [],
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      weight,
      height,
      stats,
      types,
    ];
  }

  Pokemon copyWith({
    int? id,
    String? name,
    double? weight,
    double? height,
    List<PokemonStat>? stats,
    List<PokemonType>? types,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      stats: stats ?? this.stats,
      types: types ?? this.types,
    );
  }
}

@HiveType(typeId: 1)
class PokemonNameAndUrlDatum extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  const PokemonNameAndUrlDatum(this.name, this.url);

  PokemonNameAndUrlDatum.fromMap(Map<String, dynamic> map)
      : name = map['name'] ?? "",
        url = map['url'] ?? "";

  @override
  List<Object> get props => [name, url];
}

@HiveType(typeId: 2)
class PokemonStat extends Equatable {
  @HiveField(0)
  final PokemonNameAndUrlDatum stat;

  @HiveField(1)
  final int baseStat;

  @HiveField(2)
  final int effort;
  const PokemonStat({
    required this.stat,
    required this.baseStat,
    required this.effort,
  });

  factory PokemonStat.fromMap(Map<String, dynamic> map) {
    return PokemonStat(
      stat: PokemonNameAndUrlDatum.fromMap(map['stat'] ?? {}),
      baseStat: map['base_stat'] ?? 0,
      effort: map['effort'] ?? 0,
    );
  }

  @override
  List<Object> get props => [stat, baseStat, effort];
}

@HiveType(typeId: 3)
class PokemonType extends Equatable {
  @HiveField(0)
  final PokemonNameAndUrlDatum type;

  @HiveField(1)
  final int slot;
  const PokemonType({
    required this.type,
    required this.slot,
  });

  factory PokemonType.fromMap(Map<String, dynamic> map) {
    return PokemonType(
      type: PokemonNameAndUrlDatum.fromMap(map['type'] ?? {}),
      slot: map['slot'] ?? 0,
    );
  }

  @override
  List<Object> get props => [type, slot];
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
part of 'pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonAdapter extends TypeAdapter<Pokemon> {
  @override
  final int typeId = 0;

  @override
  Pokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pokemon(
      id: fields[0] as int,
      name: fields[1] as String,
      weight: fields[3] as num,
      height: fields[4] as num,
      stats: (fields[5] as List).cast<PokemonStat>(),
      types: (fields[6] as List).cast<PokemonType>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pokemon obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.stats)
      ..writeByte(6)
      ..write(obj.types);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonNameAndUrlDatumAdapter
    extends TypeAdapter<PokemonNameAndUrlDatum> {
  @override
  final int typeId = 1;

  @override
  PokemonNameAndUrlDatum read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonNameAndUrlDatum(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonNameAndUrlDatum obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonNameAndUrlDatumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonStatAdapter extends TypeAdapter<PokemonStat> {
  @override
  final int typeId = 2;

  @override
  PokemonStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonStat(
      stat: fields[0] as PokemonNameAndUrlDatum,
      baseStat: fields[1] as int,
      effort: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonStat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.stat)
      ..writeByte(1)
      ..write(obj.baseStat)
      ..writeByte(2)
      ..write(obj.effort);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonTypeAdapter extends TypeAdapter<PokemonType> {
  @override
  final int typeId = 3;

  @override
  PokemonType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonType(
      type: fields[0] as PokemonNameAndUrlDatum,
      slot: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.slot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'package:pokedex/config/constants.dart';
import 'package:pokedex/config/theme.dart';
import 'package:pokedex/core/widgets/gap.dart';
import 'package:pokedex/data/model/pokemon.dart';
import 'package:flutter/material.dart';

class PokemonInfoHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Pokemon pokemon;

  PokemonInfoHeaderDelegate({required this.pokemon});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.sm),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.scaffoldColor,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          _PokemonDataItemTile("Height", "${pokemon.height}"),
          _PokemonDataItemTile("Weight", "${pokemon.weight}"),
          _PokemonDataItemTile("BMI", pokemon.bmi.toStringAsFixed(2)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 78;

  @override
  double get minExtent => 78;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      this != oldDelegate;
}

class _PokemonDataItemTile extends StatelessWidget {
  final String title;
  final String value;
  const _PokemonDataItemTile(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textBodyColor,
            ),
          ),
          const VGap(Insets.xs),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

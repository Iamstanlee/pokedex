import 'package:bayzat_pokedex/config/constants.dart';
import 'package:bayzat_pokedex/config/theme.dart';
import 'package:bayzat_pokedex/core/utils/extension/num.dart';
import 'package:bayzat_pokedex/core/utils/extension/string.dart';
import 'package:bayzat_pokedex/core/widgets/gap.dart';
import 'package:bayzat_pokedex/data/model/pokemon.dart';
import 'package:flutter/material.dart';

class PokemonStatItem extends StatefulWidget {
  final PokemonStat stat;
  const PokemonStatItem(this.stat, {Key? key}) : super(key: key);

  @override
  State<PokemonStatItem> createState() => _PokemonStatItemState();
}

class _PokemonStatItemState extends State<PokemonStatItem>
    with SingleTickerProviderStateMixin<PokemonStatItem> {
  late AnimationController controller;
  late Animation<double> animation;
  late PokemonStat stat;
  late double value;

  @override
  void initState() {
    super.initState();
    stat = widget.stat;
    value = stat.baseStat.interpolate(0, 100, upperBound: 1);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();
    animation = Tween<double>(begin: 0, end: value).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Insets.md),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                stat.stat.name.replaceAll("-", " ").toTitleCase(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textBodyColor,
                ),
              ),
              const HGap(Insets.sm),
              Text(
                stat.baseStat.toString(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const VGap(Insets.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(Insets.xs),
            child: LinearProgressIndicator(
              value: animation.value,
              backgroundColor: const Color(0xffE8E8E8),
              valueColor: AlwaysStoppedAnimation<Color>(
                getColor(animation.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getColor(double value) {
  if (value > 0.7) {
    return Colors.green;
  } else if (value > 0.3) {
    return const Color(0xffEEC218);
  } else {
    return const Color(0xffCD2873);
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: meal.strMealThumb != null
                    ? CachedNetworkImage(imageUrl: meal.strMealThumb!, fit: BoxFit.cover, placeholder: (_, __) => const Center(child: CircularProgressIndicator()),)
                    : const Icon(Icons.fastfood, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(meal.strMeal, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}

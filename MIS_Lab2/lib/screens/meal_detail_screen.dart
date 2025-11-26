import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  Meal? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final m = await api.lookupMealById(widget.mealId);
      setState(() {
        meal = m;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  void _openYoutube() async {
    if (meal?.strYoutube == null) return;
    final uri = Uri.parse(meal!.strYoutube!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal?.strMeal ?? 'Recipe'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : meal == null
          ? const Center(child: Text('Meal not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (meal!.strMealThumb != null)
              Image.network(meal!.strMealThumb!),
            const SizedBox(height: 8),
            Text(meal!.strMeal, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (meal!.strCategory != null)
              Text('Category: ${meal!.strCategory}'),
            if (meal!.strArea != null)
              Text('Area: ${meal!.strArea}'),
            const SizedBox(height: 12),
            Text('Ingredients', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...meal!.ingredients.map((map) {
              final k = map.keys.first;
              final v = map.values.first;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text('- $k ${v.isNotEmpty ? ' — $v' : ''}'),
              );
            }).toList(),
            const SizedBox(height: 12),
            Text('Instructions', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(meal!.strInstructions ?? ''),
            const SizedBox(height: 12),
            if (meal!.strYoutube != null && meal!.strYoutube!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: _openYoutube,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Open YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}

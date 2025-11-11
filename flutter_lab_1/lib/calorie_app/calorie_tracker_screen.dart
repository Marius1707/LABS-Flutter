import 'calorie_app_theme.dart';
import 'package:flutter/material.dart';

class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({Key? key}) : super(key: key);

  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  final List<_FoodEntry> _entries = <_FoodEntry>[];
  int _totalCalories = 0;

  @override
  void dispose() {
    _foodController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  //1
  void _addEntry() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final String name = _foodController.text.trim();
    final int calories = int.parse(_calorieController.text.trim());
    setState(() {
      _entries.add(_FoodEntry(name: name, calories: calories));

      //3.1
      _totalCalories += calories;
    });
    _foodController.clear();
    _calorieController.clear();
  }
  //1

  void _removeEntryAt(int index) {
    setState(() {
      //3.2
      _totalCalories -= _entries[index].calories;
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: FitnessAppTheme.darkerText,
          title: const Text('Daily Calorie Tracker'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TotalCalories(total: _totalCalories),
                const SizedBox(height: 12),
                _InputForm(
                  formKey: _formKey,
                  foodController: _foodController,
                  calorieController: _calorieController,
                  onAdd: _addEntry,
                ),
                const SizedBox(height: 12),

                //2
                Expanded(
                  child: _entries.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          itemCount: _entries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (BuildContext context, int index) {
                            final _FoodEntry entry = _entries[index];
                            return Dismissible(
                              key: ValueKey(
                                '${entry.name}_${entry.calories}_$index',
                              ),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) => _removeEntryAt(index),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    entry.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: FitnessAppTheme.darkerText,
                                    ),
                                  ),
                                  subtitle: const Text('Calories'),
                                  trailing: Text(
                                    entry.calories.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: FitnessAppTheme.nearlyDarkBlue,
                                    ),
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor:
                                        FitnessAppTheme.nearlyDarkBlue,
                                    child: Icon(
                                      Icons.fastfood,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onLongPress: () => _removeEntryAt(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputForm extends StatelessWidget {
  const _InputForm({
    Key? key,
    required this.formKey,
    required this.foodController,
    required this.calorieController,
    required this.onAdd,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController foodController;
  final TextEditingController calorieController;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: foodController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Food name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a food name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: calorieController,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter calories';
                    }
                    final int? parsed = int.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a positive number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCalories extends StatelessWidget {
  const _TotalCalories({Key? key, required this.total}) : super(key: key);

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FitnessAppTheme.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FitnessAppTheme.grey.withOpacity(0.2),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Total calories',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: FitnessAppTheme.darkerText,
            ),
          ),
          Text(
            total.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: FitnessAppTheme.nearlyDarkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodEntry {
  _FoodEntry({required this.name, required this.calories});

  final String name;
  final int calories;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Icon(Icons.fastfood, size: 48, color: FitnessAppTheme.grey),
          SizedBox(height: 8),
          Text(
            'No foods added yet',
            style: TextStyle(color: FitnessAppTheme.grey),
          ),
        ],
      ),
    );
  }
}

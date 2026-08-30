import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final void Function(Expense) onAdd;

  const AddExpenseScreen({super.key, required this.onAdd});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _paidByController = TextEditingController();
  final _participantsController = TextEditingController(); // comma-separated
  String _category = 'Food';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _paidByController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final participants = _participantsController.text
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    final expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      paidBy: _paidByController.text.trim(),
      participants: participants,
      category: _category,
    );

    widget.onAdd(expense);
    Navigator.of(context).pop();
  }

  static const Map<String, IconData> _categoryVisuals = {
    'Food': Icons.restaurant_rounded,
    'Ride': Icons.directions_car_rounded,
    'Subscription': Icons.subscriptions_rounded,
    'Printout': Icons.print_rounded,
    'Other': Icons.receipt_long_rounded,
  };

  static const Map<String, Color> _categoryColors = {
    'Food': Color(0xFFE4572E),
    'Ride': Color(0xFF2D5D5A),
    'Subscription': Color(0xFF6A4C93),
    'Printout': Color(0xFF1D6FA5),
    'Other': Color(0xFF757575),
  };

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add expense', style: TextStyle(fontWeight: FontWeight.w700))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _sectionLabel('What was it for'),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'e.g. Auto ride to campus'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 20),

              _sectionLabel('Category'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categoryVisuals.keys.map((cat) {
                  final selected = _category == cat;
                  final color = _categoryColors[cat]!;
                  return ChoiceChip(
                    selected: selected,
                    onSelected: (_) => setState(() => _category = cat),
                    label: Text(cat),
                    avatar: Icon(_categoryVisuals[cat], size: 18, color: selected ? Colors.white : color),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: color,
                    backgroundColor: color.withValues(alpha: 0.08),
                    side: BorderSide(color: color.withValues(alpha: selected ? 0 : 0.25)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              _sectionLabel('Amount'),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(prefixText: '₹  ', hintText: '0.00'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Amount cannot be empty';
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null) return 'Enter a valid number';
                  if (parsed <= 0) return 'Amount must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _sectionLabel('Paid by'),
              TextFormField(
                controller: _paidByController,
                decoration: const InputDecoration(hintText: 'Who fronted the money?'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Payer cannot be empty' : null,
              ),
              const SizedBox(height: 20),

              _sectionLabel('Split between'),
              TextFormField(
                controller: _participantsController,
                decoration: const InputDecoration(hintText: 'e.g. Asha, Ravi, Meera'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Add at least one participant';
                  }
                  final count = value.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).length;
                  if (count < 1) return 'Group size cannot be empty';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save expense', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
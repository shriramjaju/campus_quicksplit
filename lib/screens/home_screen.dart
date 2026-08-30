import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../logic/split_calculator.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  void _addExpense(Expense e) {
    setState(() => _expenses.add(e));
  }

  IconData _iconFor(String category) {
    switch (Expense.categoryIcons[category]) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'subscriptions':
        return Icons.subscriptions_rounded;
      case 'print':
        return Icons.print_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final balances = SplitCalculator.calculateNetBalances(_expenses);
    final total = SplitCalculator.totalSpent(_expenses);
    final sortedExpenses = [..._expenses]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus QuickSplit', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddExpenseScreen(onAdd: _addExpense)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: sortedExpenses.isEmpty
          ? _EmptyState(primary: primary)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _BalanceCard(total: total, balances: balances),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Activity log',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 10),
                ...sortedExpenses.map((e) => _ExpenseTile(expense: e, icon: _iconFor(e.category))),
                const SizedBox(height: 80),
              ],
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color primary;
  const _EmptyState({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.receipt_long_rounded, size: 48, color: primary),
            ),
            const SizedBox(height: 20),
            const Text('No expenses yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Tap "Add expense" to log a shared cost and split it with your group.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withValues(alpha: 0.55)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double total;
  final Map<String, double> balances;
  const _BalanceCard({required this.total, required this.balances});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TOTAL SPENT',
                style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.5))),
            const SizedBox(height: 4),
            Text('₹${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: balances.entries.map((e) {
                final owed = e.value >= 0;
                final color = owed ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${e.key} ${owed ? '+' : '-'}₹${e.value.abs().toStringAsFixed(2)}',
                    style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  final IconData icon;
  const _ExpenseTile({required this.expense, required this.icon});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: primary, size: 22),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${expense.paidBy} paid · ${DateFormat('MMM d, h:mm a').format(expense.timestamp)}',
          style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${expense.participants.length} people',
                style: TextStyle(color: Colors.black.withValues(alpha: 0.45), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
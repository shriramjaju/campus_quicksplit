/// Represents a single shared expense entry.
class Expense {
  final String id;
  final String title;
  final double amount;
  final String paidBy;
  final List<String> participants;
  final String category; // e.g. "Food", "Ride", "Subscription", "Printout"
  final DateTime timestamp;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.participants,
    required this.category,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Icon name string per category — mapped to actual Icon widgets in the UI.
  static const Map<String, String> categoryIcons = {
    'Food': 'restaurant',
    'Ride': 'directions_car',
    'Subscription': 'subscriptions',
    'Printout': 'print',
    'Other': 'receipt_long',
  };
}
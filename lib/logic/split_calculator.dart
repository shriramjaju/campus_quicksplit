import '../models/expense.dart';

/// Pure logic class — no Flutter/UI imports here on purpose.
/// This is what satisfies the "Logic Separation" requirement.
class SplitCalculator {
  /// Splits [amount] evenly across [participantCount] people
  /// with no rounding leaks
  /// Example: splitEqually(100.0, 3) -> [33.34, 33.33, 33.33]
  /// (leftover cents go to the first participant(s) rather than vanishing this makes it ).

  static List<double> splitEqually(double amount, int participantCount) {
    if (participantCount <= 0) {
      throw ArgumentError('participantCount must be greater than 0');
    }
    if (amount < 0) {
      throw ArgumentError('amount cannot be negative');
    }
    /// Because there could be errors in decimal numbers 
    /// so, first we will convert all our rupees to cents
    /// after all the calculations atlast we will again convert it into cents
    final totalCents = (amount * 100).round();
    final baseCents = totalCents ~/ participantCount;
    final remainder = totalCents % participantCount;

    /// let say remainder is 1, then this can't be evenly distributed if there are 3 peoples 
    return List<double>.generate(participantCount, (i) {
      final cents = baseCents + (i < remainder ? 1 : 0);
      return cents / 100;
    });
  }
    /// For each of the 3 people (index i = 0, 1, 2):
    /// Person 0: i (0) < remainder (1) → true → gets 3333 + 1 = 3334 cents → 33.34 rupees
    /// Person 1: i (1) < remainder (1) → false → gets 3333 + 0 = 3333 cents → 33.33 rupees
    /// Person 2: i (2) < remainder (1) → false → gets 3333 cents → 33.33 rupees

  /// Given a list of expenses, returns each person's net balance.
  /// Positive = they are owed money. Negative = they owe money.
  
  static Map<String, double> calculateNetBalances(List<Expense> expenses) {
    final balances = <String, double>{};

    for (final expense in expenses) {
      final shares = splitEqually(expense.amount, expense.participants.length);

      // The payer is credited the full amount they fronted.
      balances[expense.paidBy] = (balances[expense.paidBy] ?? 0) + expense.amount;

      // Each participant (including the payer, if they're also a participant)
      // is debited their individual share.
      for (var i = 0; i < expense.participants.length; i++) {
        final person = expense.participants[i];
        balances[person] = (balances[person] ?? 0) - shares[i];
      }
    }

    // Round to avoid floating point dust like 0.00000000001
    return balances.map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(2))));
  }

  /// Total amount spent across all expenses — for the dashboard summary.
  static double totalSpent(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }
}
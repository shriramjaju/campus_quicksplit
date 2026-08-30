# Campus QuickSplit — Frictionless Local-First Peer Expense Tracker

A Flutter app that lets students split shared expenses — auto rides, food bills,
group subscriptions, printout costs — quickly and without any signup friction.
Built for GDG App Dev Recruitment, Phase 1.

## Problem Statement

Students frequently manage shared group expenses where amounts are split unevenly
among varying group members. Existing expense-splitting platforms introduce
excessive friction through mandatory phone number signups, slow cloud sync,
network dependency, and complex onboarding for transient, ad-hoc transactions.

## Tech Stack

- **Framework:** Flutter (Dart)
- **Packages:** `intl` (date formatting)
- **State management:** `setState`
- **Platform tested on:** Web (Chrome)

## Features (Phase 1)

- **Standard Equal Distribution** — splits any amount evenly across participants,
  using integer-cents arithmetic so totals always reconcile exactly (no floating
  point rounding loss).
- **Aggregated Balance View** — a live dashboard showing total spend and each
  person's net balance (owed / owes / settled up).
- **Activity Log** — a reverse-chronological list of every expense with a
  category icon and timestamp.
- **Input Sanitization** — form validators block empty fields, non-numeric or
  negative amounts, and empty participant groups.
- **Logic Separation** — all split/balance math lives in `SplitCalculator`
  (`lib/logic/split_calculator.dart`), a pure Dart class with zero Flutter
  imports, kept separate from the UI layer.

## Project Structure

```
lib/
  main.dart                        # App entry point + theme
  models/
    expense.dart                   # Expense data model
  logic/
    split_calculator.dart          # Pure split & balance logic
  screens/
    home_screen.dart               # Balance dashboard + activity log
    add_expense_screen.dart        # Add-expense form with validation
```

## How to Run

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and
   make sure `flutter doctor` runs cleanly.
2. Clone this repo and navigate into it:
   ```
   git clone https://github.com/<your-username>/campus_quicksplit.git
   cd campus_quicksplit
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app in Chrome:
   ```
   flutter run -d chrome
   ```

## Screenshots

_(add screenshots here)_

## Demo Video

_(add Google Drive link here)_
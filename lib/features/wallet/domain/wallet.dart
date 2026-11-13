import 'package:equatable/equatable.dart';

enum PaymentMethodKind { debit, credit }

class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.kind,
    required this.number,
    required this.detail,
    this.isDefault = false,
  });

  final PaymentMethodKind kind;
  final String number;
  final String detail;
  final bool isDefault;

  @override
  List<Object?> get props => [kind, number, detail, isDefault];
}

class MonthStats extends Equatable {
  const MonthStats({
    required this.spent,
    required this.refunds,
    required this.cashback,
  });

  final double spent;
  final double refunds;
  final double cashback;

  @override
  List<Object?> get props => [spent, refunds, cashback];
}

enum TransactionDay { today, yesterday }

enum TransactionKind { shipping, topUp, refund, cashback, parcel }

class Transaction extends Equatable {
  const Transaction({
    required this.day,
    required this.kind,
    required this.title,
    required this.detail,
    required this.amount,
  });

  final TransactionDay day;
  final TransactionKind kind;
  final String title;
  final String detail;
  final double amount;

  bool get isIncome => amount > 0;

  @override
  List<Object?> get props => [day, kind, title, detail, amount];
}

class DayTransactions extends Equatable {
  const DayTransactions(this.day, this.items);

  final TransactionDay day;
  final List<Transaction> items;

  @override
  List<Object?> get props => [day, items];
}

/// Agrupa por día respetando el orden de aparición.
List<DayTransactions> groupByDay(List<Transaction> all) {
  final order = <TransactionDay>[];
  final map = <TransactionDay, List<Transaction>>{};
  for (final t in all) {
    if (!map.containsKey(t.day)) order.add(t.day);
    map.putIfAbsent(t.day, () => []).add(t);
  }
  return [for (final d in order) DayTransactions(d, map[d]!)];
}

class WalletSummary extends Equatable {
  const WalletSummary({
    required this.balance,
    required this.todayDelta,
    required this.updatedAt,
    required this.methods,
    required this.month,
    required this.transactions,
  });

  final double balance;
  final double todayDelta;
  final String updatedAt;
  final List<PaymentMethod> methods;
  final MonthStats month;
  final List<Transaction> transactions;

  List<DayTransactions> get groups => groupByDay(transactions);

  @override
  List<Object?> get props => [
    balance,
    todayDelta,
    updatedAt,
    methods,
    month,
    transactions,
  ];
}

abstract class WalletRepository {
  Future<WalletSummary> loadSummary();
}

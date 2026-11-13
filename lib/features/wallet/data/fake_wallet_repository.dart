import '../domain/wallet.dart';

class FakeWalletRepository implements WalletRepository {
  @override
  Future<WalletSummary> loadSummary() async {
    return const WalletSummary(
      balance: 1280.87,
      todayDelta: 100,
      updatedAt: '2:32',
      methods: [
        PaymentMethod(
          kind: PaymentMethodKind.debit,
          number: '•••• 4417',
          detail: 'Débito · Vence 08/28',
          isDefault: true,
        ),
        PaymentMethod(
          kind: PaymentMethodKind.credit,
          number: 'Crédito Zybolt',
          detail: '\$45.00 disponibles',
        ),
      ],
      month: MonthStats(spent: 186.40, refunds: 24, cashback: 6.20),
      transactions: [
        Transaction(
          day: TransactionDay.today,
          kind: TransactionKind.shipping,
          title: 'Costo de envío',
          detail: 'AB-889641 · 10:24',
          amount: -18.50,
        ),
        Transaction(
          day: TransactionDay.today,
          kind: TransactionKind.topUp,
          title: 'Recarga',
          detail: 'Tarjeta de débito •••• 4417 · 09:02',
          amount: 100,
        ),
        Transaction(
          day: TransactionDay.yesterday,
          kind: TransactionKind.parcel,
          title: 'Costo de envío',
          detail: 'PE-586340 · 18:40',
          amount: -24.90,
        ),
        Transaction(
          day: TransactionDay.yesterday,
          kind: TransactionKind.refund,
          title: 'Reembolso',
          detail: 'AR-229481 · 12:15',
          amount: 12,
        ),
        Transaction(
          day: TransactionDay.yesterday,
          kind: TransactionKind.cashback,
          title: 'Cashback',
          detail: 'Premio semanal · 08:00',
          amount: 2.10,
        ),
      ],
    );
  }
}

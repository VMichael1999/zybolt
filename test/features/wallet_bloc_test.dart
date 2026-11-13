import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zybolt/features/wallet/data/fake_wallet_repository.dart';
import 'package:zybolt/features/wallet/domain/wallet.dart';
import 'package:zybolt/features/wallet/presentation/wallet_bloc.dart';

void main() {
  blocTest<WalletBloc, WalletState>(
    'oculta y vuelve a mostrar el saldo',
    build: () => WalletBloc(FakeWalletRepository()),
    act:
        (b) =>
            b
              ..add(const BalanceVisibilityToggled())
              ..add(const BalanceVisibilityToggled()),
    expect: () => [const WalletState(balanceHidden: true), const WalletState()],
  );

  blocTest<WalletBloc, WalletState>(
    'carga el resumen de la billetera',
    build: () => WalletBloc(FakeWalletRepository()),
    act: (b) => b.add(const WalletStarted()),
    verify: (b) {
      expect(b.state.status, WalletStatus.success);
      expect(b.state.summary!.balance, 1280.87);
    },
  );

  test('agrupa las transacciones por día respetando el orden', () async {
    final summary = await FakeWalletRepository().loadSummary();
    final groups = summary.groups;
    expect(groups.map((g) => g.day), [
      TransactionDay.today,
      TransactionDay.yesterday,
    ]);
    expect(groups[0].items.length, 2);
    expect(groups[1].items.length, 3);
  });
}

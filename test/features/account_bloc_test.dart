import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zybolt/features/account/data/fake_account_repository.dart';
import 'package:zybolt/features/account/domain/account.dart';
import 'package:zybolt/features/account/presentation/account_bloc.dart';
import 'package:zybolt/features/auth/data/fake_auth_repository.dart';
import 'package:zybolt/features/auth/domain/auth.dart';

class _FailingAccount extends FakeAccountRepository {
  @override
  Future<void> savePreference(PreferenceKey key, bool value) async {
    throw Exception('sin red');
  }
}

class _MockAuth extends Mock implements AuthRepository {}

void main() {
  final auth = FakeAuthRepository(delay: Duration.zero);

  blocTest<AccountBloc, AccountState>(
    'el cambio es optimista y se guarda',
    build: () => AccountBloc(FakeAccountRepository(), auth),
    act: (b) => b.add(const PreferenceToggled(PreferenceKey.darkMode)),
    expect:
        () => [const AccountState(preferences: Preferences(darkMode: true))],
  );

  blocTest<AccountBloc, AccountState>(
    'si el repositorio falla, revierte el cambio',
    build: () => AccountBloc(_FailingAccount(), auth),
    act:
        (b) =>
            b.add(const PreferenceToggled(PreferenceKey.deliveryNotifications)),
    expect:
        () => [
          const AccountState(
            preferences: Preferences(deliveryNotifications: false),
          ),
          const AccountState(),
        ],
  );

  blocTest<AccountBloc, AccountState>(
    'carga el perfil de Michael Dev',
    build: () => AccountBloc(FakeAccountRepository(), auth),
    act: (b) => b.add(const AccountStarted()),
    verify: (b) {
      expect(b.state.profile!.name, 'Michael Dev');
      expect(b.state.profile!.email, 'michaeldev@gmail.com');
      expect(b.state.membership!.progress, 0.72);
    },
  );

  blocTest<AccountBloc, AccountState>(
    'cerrar sesión limpia la sesión y marca loggedOut',
    build: () {
      final mock = _MockAuth();
      when(mock.signOut).thenAnswer((_) async {});
      return AccountBloc(FakeAccountRepository(), mock);
    },
    act: (b) => b.add(const LogoutRequested()),
    expect: () => [const AccountState(loggedOut: true)],
  );
}

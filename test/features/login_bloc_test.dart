import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zybolt/features/auth/domain/auth.dart';
import 'package:zybolt/features/auth/presentation/login_bloc.dart';

class _MockAuth extends Mock implements AuthRepository {}

void main() {
  late _MockAuth auth;
  const user = User(name: 'Michael Dev', email: 'michaeldev@gmail.com');

  setUp(() {
    auth = _MockAuth();
  });

  LoginBloc build() => LoginBloc(SignInUseCase(auth));

  blocTest<LoginBloc, LoginState>(
    'éxito: loading y luego success',
    build: () {
      when(
        () => auth.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
          keepSignedIn: any(named: 'keepSignedIn'),
        ),
      ).thenAnswer((_) async => user);
      return build();
    },
    act: (b) => b.add(const LoginSubmitted()),
    expect:
        () => [
          const LoginState(status: LoginStatus.loading),
          const LoginState(status: LoginStatus.success),
        ],
  );

  blocTest<LoginBloc, LoginState>(
    'fallo: loading y luego failure con mensaje',
    build: () {
      when(
        () => auth.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
          keepSignedIn: any(named: 'keepSignedIn'),
        ),
      ).thenThrow(Exception('boom'));
      return build();
    },
    act: (b) => b.add(const LoginSubmitted()),
    expect:
        () => [
          const LoginState(status: LoginStatus.loading),
          isA<LoginState>()
              .having((s) => s.status, 'status', LoginStatus.failure)
              .having((s) => s.error, 'error', isNotNull),
        ],
  );

  blocTest<LoginBloc, LoginState>(
    'alterna visibilidad de contraseña y «mantener sesión»',
    build: build,
    act:
        (b) =>
            b
              ..add(const PasswordVisibilityToggled())
              ..add(const KeepSignedInToggled())
              ..add(const PasswordVisibilityToggled()),
    expect:
        () => [
          const LoginState(obscure: false),
          const LoginState(obscure: false, keepSignedIn: false),
          const LoginState(keepSignedIn: false),
        ],
  );

  blocTest<LoginBloc, LoginState>(
    'guarda correo y contraseña',
    build: build,
    act:
        (b) =>
            b
              ..add(const EmailChanged('a@b.com'))
              ..add(const PasswordChanged('123')),
    expect:
        () => [
          const LoginState(email: 'a@b.com'),
          const LoginState(email: 'a@b.com', password: '123'),
        ],
  );
}

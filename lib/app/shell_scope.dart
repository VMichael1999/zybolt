import 'package:flutter/widgets.dart';

/// Permite a las pantallas de la barra inferior mostrar el overlay de
/// búsqueda por encima de la barra flotante.
class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.searching, required super.child});

  final ValueNotifier<bool> searching;

  static ShellScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShellScope>();
    assert(scope != null, 'ShellScope no encontrado');
    return scope!;
  }

  @override
  bool updateShouldNotify(ShellScope old) => searching != old.searching;
}

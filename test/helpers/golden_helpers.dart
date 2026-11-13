import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zybolt/core/theme/app_colors.dart';
import 'package:zybolt/core/theme/app_theme.dart';

/// Carga Plus Jakarta Sans para que los golden usen la fuente real.
Future<void> loadFonts() async {
  final loader = FontLoader('PlusJakartaSans');
  for (final w in [400, 500, 600, 700, 800]) {
    final bytes = File('assets/fonts/PlusJakartaSans-$w.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

/// Envuelve un widget con tema, fondo blanco y tamaño de pantalla 440 × 956.
Widget screenHost(Widget child, {double textScale = 1}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    builder:
        (context, c) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: true,
          ),
          child: c!,
        ),
    home: Material(color: AppColors.white, child: child),
  );
}

/// Caja de componente: ancho fijo sobre blanco.
Widget componentHost(Widget child, {double width = 396}) {
  return screenHost(
    Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

Future<void> setScreenSize(WidgetTester tester) async {
  tester.view.physicalSize = const Size(440, 956);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

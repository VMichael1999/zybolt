import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'app/app.dart';
import 'app/di.dart';
import 'core/config/maps_config.dart';
import 'core/utils/precache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  await setupDi();
  await MapsConfig.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  unawaited(precacheIllustrations().catchError((Object _) {}));
  runApp(
    LiquidGlassWidgets.wrap(
      child: const ZyboltApp(),
      brightnessResolver: Theme.maybeBrightnessOf,
    ),
  );
}

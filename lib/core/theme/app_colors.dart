import 'package:flutter/material.dart';

/// Tokens de color. Ningún widget escribe un `Color(0x…)` suelto.
abstract final class AppColors {
  // --- marca ---
  static const Color primary = Color(0xFFF26A1D);
  static const Color primaryDark = Color(0xFFE85A10);
  static const Color headerOrange = Color(0xFFFCB066);
  static const Color peach = Color(0xFFFDEDE4);
  static const Color primarySoft = Color(0xFFFDE3D6);

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFF47A2A), Color(0xFFEC5A12)],
  );

  /// 160° en CSS equivale a un degradado que baja y gira un poco a la derecha.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment(-0.34, -0.94),
    end: Alignment(0.34, 0.94),
    colors: [Color(0xFFFFF1EA), Color(0xFFFEDFCB), Color(0xFFFDC9A5)],
    stops: [0, 0.45, 1],
  );

  static const LinearGradient shippingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDD3B4), Color(0xFFFEE8D9), Color(0xFFFFFFFF)],
    stops: [0, 0.55, 1],
  );

  /// Cabecera pegajosa de Mis envíos (se vuelve casi opaca).
  static const LinearGradient shippingStickyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFDD3B4), Color(0xFFFEE3D1), Color(0xF2FEEBDE)],
    stops: [0, 0.7, 1],
  );

  // --- texto ---
  static const Color ink = Color(0xFF16171B);
  static const Color ink2 = Color(0xFF6B6E76);
  static const Color ink3 = Color(0xFFA0A3AA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // --- superficies ---
  static const Color dark = Color(0xFF141416);
  static const Color pillDark = Color(0xFF1C1C1E);
  static const Color field = Color(0xFFF2F2F5);
  static const Color tile = Color(0xFFF1F3F5);
  static const Color card = Color(0xFFF5F6F8);
  static const Color line = Color(0xFFECEDF0);
  static const Color lineSoft = Color(0xFFF0F1F3);
  static const Color lineMap = Color(0xFFE6E7EA);
  static const Color cardBorder = Color(0xFFEFEFF2);
  static const Color countBg = Color(0xFFF1F2F4);
  static const Color countBgDark = Color(0xFF3A3A3E);
  static const Color countFg = Color(0xFF55585F);

  // --- estados ---
  static const Color transitBg = Color(0xFFFDE3D6);
  static const Color transitFg = Color(0xFFE8743B);
  static const Color green = Color(0xFF22A35A);
  static const Color greenSoft = Color(0xFFE2F5EA);
  static const Color greenTrend = Color(0xFF2BA160);
  static const Color ribbonTransit = Color(0xFFEF6A20);
  static const Color ribbonProcess = Color(0xFF1C1C1E);
  static const Color ribbonDelivered = Color(0xFF26A85C);
  static const Color error = Color(0xFFD93A2B);

  // --- login ---
  static const Color fieldIcon = Color(0xFF7A7D85);
  static const Color fieldHint = Color(0xFF9EA0A7);
  static const Color focusBorder = Color(0xFFF2A06D);
  static const Color focusFill = Color(0xFFFFF6F1);
  static const Color checkOff = Color(0xFFC9CBD0);
  static const Color orText = Color(0xFF8D9097);
  static const Color signupText = Color(0xFF7D8088);
  static const Color guest = Color(0xFFE87A3C);
  static const Color keepText = Color(0xFF6B6E76);
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRing = Color(0xFFE3E4E8);
  static const Color appleBg = Color(0xFF1F1F1F);

  // --- splash ---
  static const Color splashInk = Color(0xFF1A1A1A);
  static const Color splashTagline = Color(0xFF9A9CA3);

  // --- home ---
  static const Color headerSub = Color(0xFF4A3A2E);
  static const Color headerSub2 = Color(0xFF3E3229);
  static const Color progressDot = Color(0xFF2B2B2B);
  static const Color searchIcon = Color(0xFF6A6D74);
  static const Color searchText = Color(0xFF8E9097);
  static const Color metaGrey = Color(0xFF8A8D94);
  static const Color metaWarm = Color(0xFF8A7A70);
  static const Color barBase = Color(0xFFF7B27A);
  static const Color barMuted = Color(0xFFE4D7CE);
  static const Color timelineLine = Color(0xFFE3E4E8);
  static const Color timelineHint = Color(0xFF9A9CA3);
  static const Color timelineDotRing = Color(0xFFB9BBC1);
  static const Color liveBorder = Color(0xFFF6B48A);
  static const Color liveFill = Color(0xFFFFF9F5);
  static const Color liveChipBorder = Color(0xFFF6C8AB);
  static const Color iconBoxFg = Color(0xFF55585F);
  static const Color closedGrey = Color(0xFFB7B9BF);
  static const Color chevronGrey = Color(0xFF9A9CA3);
  static const Color mapChipShadow = Color(0x4D000000);

  // --- barra flotante ---
  static const Color navIdle = Color(0xFF2A2B2F);
  static const Color glass = Color(0xB8FFFFFF);
  static const Color glassBorder = Color(0xB3FFFFFF);
  static const Color glassLensTint = Color(0x26FFFFFF);
  static const Color glassOutline = Color(0x0D000000);
  static const Color primaryFill = Color(0x2EF26A1D);

  // --- seguimiento ---
  static const Color mapBeige = Color(0xFFEFE8D6);
  static const Color routeGrey = Color(0xFF9A9EA6);
  static const Color grabber = Color(0xFFD9DADF);
  static const Color avatarBg = Color(0xFFF2F2F4);
  static const Color packedBg = Color(0xFFF0F0F2);
  static const Color packedFg = Color(0xFF2A2B2F);
  static const Color packedData = Color(0xFF6B6E76);
  static const Color transitBannerBg = Color(0xFFFDE7DA);
  static const Color transitBannerFg = Color(0xFFE0631E);
  static const Color stepTodo = Color(0xFFC4C6CB);
  static const Color stepLineTodo = Color(0xFFC9CBD0);
  static const Color sheetBorder = Color(0xFFF0F0F2);
  static const Color pinStroke = Color(0xFFE2E2E2);
  static const Color bubbleStroke = Color(0xFFEDEDED);
  static const Color mapLabel = Color(0xFF6C6252);
  static const Color mapLabelGreen = Color(0xFF8A8C70);
  static const Color mapBadgeStroke = Color(0xFF9CC27C);
  static const Color mapBadgeText = Color(0xFF5E8A3C);
  static const Color mapBadgeStroke2 = Color(0xFFBBBBBB);
  static const Color mapBadgeText2 = Color(0xFF555555);

  // --- billetera / cuenta ---
  static const Color balanceSub = Color(0xFF3E3229);
  static const Color eyeButton = Color(0xA6FFFFFF);
  static const Color circleDecoration = Color(0x2EFFFFFF);
  static const Color cardChipA = Color(0xFFF7C48B);
  static const Color cardChipB = Color(0xFFE89A4C);
  static const Color darkCardSub = Color(0xFFA3A5AC);
  static const Color addBorder = Color(0xFFE3E4E8);
  static const Color groupLabel = Color(0xFF9A9CA3);
  static const Color chevronSoft = Color(0xFFB5B7BD);
  static const Color switchOff = Color(0xFFD9DADF);
  static const Color outlineFill = Color(0xFFFFF6F1);
  static const Color outlineBorder = Color(0xFFF6C8AB);
  static const Color topStrip = Color(0xFFFDD3B4);
  static const Color statDivider = Color(0xFFE6E7EA);
  static const Color levelSub = Color(0xFF8A7A70);
  static const Color switchShadow = Color(0x33000000);
  static const Color emptyText = Color(0xFF8A8D94);
  static const Color searchRing = Color(0x08000000);
  static const Color progressDotLight = Color(0x592B2B2B);
  static const Color progressRing = Color(0x662B2B2B);
  static const Color dotHalo = Color(0x0F000000);
  static const Color topStripFade = Color(0x00FDD3B4);
  static const Color transparent = Color(0x00000000);
}

/// Acceso temático: `context.palette.primary`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette();

  Color get primary => AppColors.primary;
  Color get primaryDark => AppColors.primaryDark;
  Color get headerOrange => AppColors.headerOrange;
  Color get peach => AppColors.peach;
  Color get ink => AppColors.ink;
  Color get ink2 => AppColors.ink2;
  Color get ink3 => AppColors.ink3;
  Color get dark => AppColors.dark;
  Color get field => AppColors.field;
  Color get tile => AppColors.tile;
  Color get card => AppColors.card;
  Color get line => AppColors.line;
  Color get green => AppColors.green;
  Color get greenSoft => AppColors.greenSoft;
  Color get mapBeige => AppColors.mapBeige;

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) => this;
}

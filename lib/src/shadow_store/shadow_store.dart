import 'package:flutter/material.dart';

/// Provides reusable shadow definitions for the Tenet design system.
///
/// The shadows are organized into two categories:
///
/// - [ShadowStore.shadowV1] — standard elevation-style shadows.
/// - [ShadowStore.shadowV2] — layered soft shadows.
///
/// Use [ShadowStore.shadowV3] when a shadow needs to be generated
/// dynamically from a specific color.
abstract final class ShadowStore {
  ShadowStore._();

  // ---------------------------------------------------------------------------
  // Static shadow definitions
  // ---------------------------------------------------------------------------

  static const BoxShadow _boxShadowV1 = BoxShadow(
    color: Color(0x40000000),
    offset: Offset(0, 20),
    blurRadius: 25,
    spreadRadius: -5,
  );

  static const BoxShadow _boxShadowV2 = BoxShadow(
    color: Color(0x19000000),
    offset: Offset(0, 8),
    blurRadius: 10,
    spreadRadius: -6,
  );

  static const BoxShadow _boxShadowV3 = BoxShadow(
    color: Color(0x0A398DFA),
    offset: Offset.zero,
    blurRadius: 0,
    spreadRadius: 1,
  );

  static const BoxShadow _boxShadowV4 = BoxShadow(
    color: Color(0x0A2A3345),
    offset: Offset(0, 1),
    blurRadius: 1,
    spreadRadius: -0.5,
  );

  static const BoxShadow _boxShadowV5 = BoxShadow(
    color: Color(0x0A2A3346),
    offset: Offset(0, 3),
    blurRadius: 3,
    spreadRadius: -1.5,
  );

  static const BoxShadow _boxShadowV6 = BoxShadow(
    color: Color(0x0A2A3346),
    offset: Offset(0, 6),
    blurRadius: 6,
    spreadRadius: -3,
  );

  static const BoxShadow _boxShadowV7 = BoxShadow(
    color: Color(0x0A0E3F7E),
    offset: Offset(0, 12),
    blurRadius: 12,
    spreadRadius: -6,
  );

  static const BoxShadow _boxShadowV8 = BoxShadow(
    color: Color(0x0A0E3F7E),
    offset: Offset(0, 24),
    blurRadius: 24,
    spreadRadius: -12,
  );

  // ---------------------------------------------------------------------------
  // Shadow presets
  // ---------------------------------------------------------------------------

  /// A standard elevated shadow composed of two layers.
  static const List<BoxShadow> shadowV1 = [_boxShadowV1, _boxShadowV2];

  /// A soft, layered shadow composed of multiple elevation levels.
  static const List<BoxShadow> shadowV2 = [
    _boxShadowV2,
    _boxShadowV3,
    _boxShadowV4,
    _boxShadowV5,
    _boxShadowV6,
    _boxShadowV7,
    _boxShadowV8,
  ];

  /// Creates a dynamic colored glow shadow.
  ///
  /// [color] determines the glow color.
  ///
  /// [offset] controls the position of the primary shadow and defaults
  /// to `(0, 10)`.
  static List<BoxShadow> shadowV3(
    Color color, {
    Offset offset = const Offset(0, 10),
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.25),
        blurRadius: 30,
        spreadRadius: 4,
        offset: offset,
      ),
      BoxShadow(
        color: color.withOpacity(0.08),
        blurRadius: 60,
        offset: const Offset(0, 20),
      ),
    ];
  }
}

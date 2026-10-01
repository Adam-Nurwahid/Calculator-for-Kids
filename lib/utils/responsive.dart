import 'package:flutter/material.dart';

/// Helper utility for responsive design breakpoints and scaling calculations.
class Responsive {
  final BuildContext context;
  final BoxConstraints? constraints;

  Responsive.of(this.context, [this.constraints]);

  static double widthOf(BuildContext context, [BoxConstraints? constraints]) {
    return constraints?.maxWidth ?? MediaQuery.sizeOf(context).width;
  }

  static double heightOf(BuildContext context, [BoxConstraints? constraints]) {
    return constraints?.maxHeight ?? MediaQuery.sizeOf(context).height;
  }

  double get screenWidth => widthOf(context, constraints);
  double get screenHeight => heightOf(context, constraints);

  static bool isMobileWidth(double width) => width < 600;
  static bool isTabletWidth(double width) => width >= 600 && width < 1024;
  static bool isDesktopWidth(double width) => width >= 1024;

  bool get isMobile => isMobileWidth(screenWidth);
  bool get isTablet => isTabletWidth(screenWidth);
  bool get isDesktop => isDesktopWidth(screenWidth);

  static Orientation orientationOf(BuildContext context) {
    return MediaQuery.orientationOf(context);
  }

  bool get isLandscape =>
      MediaQuery.orientationOf(context) == Orientation.landscape ||
      (screenWidth > screenHeight && screenHeight < 600);

  /// Standard reference width (390 logical pixels).
  /// Returns a normalized scale factor bounded between 0.85 and 1.40.
  double get scaleFactor {
    final width = isDesktop ? 480.0 : (isTablet ? 600.0 : screenWidth);
    final scale = width / 390.0;
    return scale.clamp(0.85, 1.40);
  }

  /// Returns recommended maximum container width for wide screens.
  static double maxContainerWidth(double screenWidth) {
    if (screenWidth >= 1024) return 480;
    if (screenWidth >= 600) return 560;
    return double.infinity;
  }
}

/// Extension on BuildContext for quick access to responsive properties.
extension ResponsiveContext on BuildContext {
  double get screenWidth => Responsive.widthOf(this);
  double get screenHeight => Responsive.heightOf(this);
  bool get isMobile => Responsive.isMobileWidth(screenWidth);
  bool get isTablet => Responsive.isTabletWidth(screenWidth);
  bool get isDesktop => Responsive.isDesktopWidth(screenWidth);
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape ||
      (screenWidth > screenHeight && screenHeight < 600);
  double get scaleFactor => Responsive.of(this).scaleFactor;
}

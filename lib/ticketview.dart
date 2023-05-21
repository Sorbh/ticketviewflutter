import 'package:flutter/material.dart';
import 'dart:math' as math;

class TicketView extends StatelessWidget {
  const TicketView({
    Key? key,
    this.corderRadius = 3,
    this.drawTriangle = true,
    this.drawArc = false,
    this.triangleAxis = Axis.horizontal,
    this.triangleSize = const Size(20, 10),
    this.trianglePos = .7,
    this.contentBackgroundColor = Colors.white,
    this.backgroundColor = Colors.red,
    this.contentPadding = const EdgeInsets.all(0),
    this.backgroundPadding =
        const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
    this.drawDivider = true,
    this.circleDash = false,
    this.dividerPadding = 20,
    this.dividerColor = Colors.grey,
    this.dividerStrokeWidth = 2,
    this.drawBorder = true,
    this.borderRadius = 4,
    this.drawShadow = true,
    this.dashWidth = 5,
    this.shadowColor = Colors.grey,
    this.shadowOffset = 15,
    this.child,
  }) : super(key: key);
  final bool drawTriangle;
  final bool drawArc;

  final Axis triangleAxis;
  final Size triangleSize;
  final double trianglePos;

  final Color contentBackgroundColor;
  final Color backgroundColor;

  final EdgeInsets contentPadding;
  final EdgeInsets backgroundPadding;

  final double corderRadius;

  final bool drawDivider;
  final bool circleDash;
  final double dividerPadding;
  final Color dividerColor;
  final double dividerStrokeWidth;
  final double dashWidth;

  final bool drawBorder;
  final double borderRadius;

  final bool drawShadow;
  final Color shadowColor;
  final double shadowOffset;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TicketViewPainter(
        corderRadius,
        drawTriangle,
        drawArc,
        triangleAxis,
        triangleSize,
        trianglePos,
        contentBackgroundColor,
        backgroundColor,
        contentPadding,
        backgroundPadding,
        drawDivider,
        circleDash,
        dividerPadding,
        dividerColor,
        dividerStrokeWidth,
        drawBorder,
        borderRadius,
        drawShadow,
        shadowColor,
        shadowOffset,
        dashWidth,
      ),
      child: Container(
        padding: contentPadding,
        child: ClipPath(
          clipper: TicketViewClipper(
            drawTriangle,
            drawArc,
            triangleAxis,
            triangleSize,
            trianglePos,
            drawDivider,
            borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}

class TicketViewPainter extends CustomPainter {
  TicketViewPainter(
    this.corderRadius,
    this.drawTriangle,
    this.drawArc,
    this.triangleAxis,
    this.triangleSize,
    this.trianglePos,
    this.contentBackgroundColor,
    this.backgroundColor,
    this.contentPadding,
    this.backgroundPadding,
    this.drawDivider,
    this.circleDash,
    this.dividerPadding,
    this.dividerColor,
    this.dividerStrokeWidth,
    this.drawBorder,
    this.borderRadius,
    this.drawShadow,
    this.shadowColor,
    this.shadowOffset,
    this.dashWidth,
  );
  final bool drawTriangle;
  final bool drawArc;

  final Axis triangleAxis;
  final Size triangleSize;
  final double trianglePos;

  final Color contentBackgroundColor;
  final Color backgroundColor;

  final EdgeInsets contentPadding;
  final EdgeInsets backgroundPadding;

  final double corderRadius;

  final bool drawDivider;
  final bool circleDash;
  final double dashWidth;
  final double dividerPadding;
  final Color dividerColor;
  final double dividerStrokeWidth;

  final bool drawBorder;
  final double borderRadius;

  final bool drawShadow;
  final Color shadowColor;
  final double shadowOffset;

  Offset? dashStart, dashEnd;

  //IMPORTANT:  When you are clipping, all the polygon will be treated
  // TicketViewPainter, Clip method will close them each and then clip.
  // Let if you have 3 polygon in your path, and you try to clip it, it will
  // close then individually and clip, if you tried to draw then will work fine.

  @override
  void paint(Canvas canvas, Size size) {
    //Get Background Rect
    final Paint paint = Paint();
    paint.color = backgroundColor;
    paint.style = PaintingStyle.fill;

    final RRect backgroundRect = RRect.fromLTRBR(
      0 + backgroundPadding.left,
      0 + backgroundPadding.top,
      size.width - backgroundPadding.right,
      size.height - backgroundPadding.bottom,
      const Radius.circular(4),
    );

    final Path backgroundRectPath = Path();

    backgroundRectPath.addPolygon(
      <Offset>[
        Offset(backgroundRect.left, backgroundRect.top),
        Offset(backgroundRect.right, backgroundRect.top),
        Offset(backgroundRect.right, backgroundRect.bottom),
        Offset(backgroundRect.left, backgroundRect.bottom),
      ],
      true,
    );

    canvas.drawRRect(backgroundRect, paint);

    //Get foreground Rect
    paint.color = contentBackgroundColor;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2;

    final Rect foregroundRect = Rect.fromLTRB(
      contentPadding.left,
      contentPadding.top,
      size.width - contentPadding.right,
      size.height - contentPadding.bottom,
    );

    //Clip the triangle or Arc
    final Path path = Path();

    path.moveTo(foregroundRect.left, foregroundRect.top);

    _drawLayout(foregroundRect, path);

    if (drawShadow) {
      canvas.drawShadow(path, Colors.grey, 2, true);
    }

    canvas.clipPath(path);

    canvas.drawRect(foregroundRect, paint);

    if (drawDivider) {
      drawDashedLine(canvas, dashStart!, dashEnd!);
    }
  }

  void _drawLayout(Rect foregroundRect, Path path) {
    path.drawTicket(
      foregroundRect: foregroundRect,
      triangleAxis: triangleAxis,
      trianglePos: trianglePos,
      triangleSize: triangleSize,
      drawTriangle: drawTriangle,
      drawArc: drawArc,
      drawBorder: drawBorder,
      borderRadius: borderRadius,
      setDashPoints: _setDashPoints,
      dividerPadding: dividerPadding,
    );
  }

  void _setDashPoints(Offset offset) {
    if (dashStart == null) {
      dashStart = offset;
      return;
    }
    dashEnd = offset;
  }

  void drawDashedLine(Canvas canvas, Offset start, Offset end) {
    Offset a, b;
    if (start.dy == end.dy) {
      a = start.dx < end.dx ? start : end;
      b = start.dx > end.dx ? start : end;
    } else {
      a = start;
      b = end;
    }

    final Path path = getDashedPath(a: a, b: b, gap: dashWidth);

    final Paint dashLinePaint = Paint();
    dashLinePaint.color = dividerColor;
    dashLinePaint.style =
        circleDash ? PaintingStyle.fill : PaintingStyle.stroke;
    dashLinePaint.strokeWidth = dividerStrokeWidth;
    dashLinePaint.strokeCap = StrokeCap.round;

    canvas.drawPath(path, dashLinePaint);
  }

  Path getDashedPath({
    required Offset a,
    required Offset b,
    required double gap,
  }) {
    final Size size = Size(b.dx - a.dx, b.dy - a.dy);
    final Path path = Path();
    path.moveTo(a.dx, a.dy);
    bool shouldDraw = true;
    final bool isHorizontal = a.dx == b.dx;
    math.Point<double> currentPoint = math.Point<double>(a.dx, a.dy);

    final double radians = math.atan(size.height / size.width);

    final double dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    final double dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;
    while (currentPoint.x <= b.dx && currentPoint.y <= b.dy) {
      shouldDraw
          ? circleDash
              ? path.addOval(
                  Rect.fromCircle(
                    center: Offset(
                      currentPoint.x + (isHorizontal ? 0 : gap),
                      currentPoint.y + (isHorizontal ? gap : 0),
                    ),
                    radius: dashWidth,
                  ),
                )
              : path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);

      shouldDraw = !shouldDraw;
      currentPoint = math.Point<double>(
        currentPoint.x + dx + (isHorizontal ? 0 : gap / 2),
        currentPoint.y + dy + (isHorizontal ? gap / 2 : 0),
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TicketViewClipper extends CustomClipper<Path> {
  const TicketViewClipper(
    this.drawTriangle,
    this.drawArc,
    this.triangleAxis,
    this.triangleSize,
    this.trianglePos,
    this.drawBorder,
    this.borderRadius,
  );
  final bool drawTriangle;
  final bool drawArc;

  final Axis triangleAxis;
  final Size triangleSize;
  final double trianglePos;

  final bool drawBorder;
  final double borderRadius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final Rect foregroundRect = Rect.fromLTRB(0, 0, size.width, size.height);

    path.moveTo(foregroundRect.left, foregroundRect.top);

    path.drawTicket(
      foregroundRect: foregroundRect,
      triangleAxis: triangleAxis,
      trianglePos: trianglePos,
      triangleSize: triangleSize,
      drawTriangle: drawTriangle,
      drawArc: drawArc,
      drawBorder: drawBorder,
      borderRadius: borderRadius,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FlagPainter extends CustomPainter {
  const FlagPainter({
    required this.title,
    required this.backgroundColor,
    required this.titleStyle,
  });

  final Color backgroundColor;
  final String title;
  final TextStyle titleStyle;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()..color = backgroundColor;
    final Path path = Path();
    path.addPolygon(
      <Offset>[
        Offset.zero,
        Offset(
          size.width,
          0,
        ),
        Offset(
          size.width - 20,
          size.height / 2,
        ),
        Offset(
          size.width,
          size.height,
        ),
        Offset(
          0,
          size.height,
        ),
      ],
      true,
    );

    canvas.drawPath(path, p);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: titleStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width - 20,
    );

    final double yCenter = (size.height - textPainter.height) / 2;
    final Offset offset = Offset(10, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension PathExt on Path {
  void drawTicket({
    required Rect foregroundRect,
    Axis triangleAxis = Axis.horizontal,
    double trianglePos = 0.7,
    required Size triangleSize,
    bool drawTriangle = true,
    bool drawBorder = true,
    bool drawArc = true,
    double borderRadius = 4,
    Function(Offset offset)? setDashPoints,
    double dividerPadding = 0,
  }) {
    if (triangleAxis == Axis.horizontal) {
      _addTrianglePointToPath(
        size: foregroundRect,
        start: Offset(foregroundRect.left, foregroundRect.top),
        end: Offset(foregroundRect.right, foregroundRect.top),
        trianglePos: trianglePos,
        triangleSize: triangleSize,
        isTriangle: drawTriangle,
        isArc: drawArc,
        setDashPoints: setDashPoints,
        dividerPadding: dividerPadding,
      );

      if (drawBorder) {
        _addArcPointToPath(
          foregroundRect,
          Offset(foregroundRect.right, foregroundRect.top),
          Offset(foregroundRect.right, foregroundRect.bottom),
          borderRadius,
        );
      } else {
        lineTo(foregroundRect.right, foregroundRect.bottom);
      }

      _addTrianglePointToPath(
        size: foregroundRect,
        start: Offset(foregroundRect.right, foregroundRect.bottom),
        end: Offset(foregroundRect.left, foregroundRect.bottom),
        trianglePos: trianglePos,
        triangleSize: triangleSize,
        isTriangle: drawTriangle,
        isArc: drawArc,
        setDashPoints: setDashPoints,
        dividerPadding: dividerPadding,
      );

      if (drawBorder) {
        _addArcPointToPath(
          foregroundRect,
          Offset(foregroundRect.left, foregroundRect.bottom),
          Offset(foregroundRect.left, foregroundRect.top),
          borderRadius,
        );
      } else {
        lineTo(foregroundRect.left, foregroundRect.top);
      }
    } else {
      if (drawBorder) {
        _addArcPointToPath(
          foregroundRect,
          Offset(foregroundRect.left, foregroundRect.top),
          Offset(foregroundRect.right, foregroundRect.top),
          borderRadius,
        );
      } else {
        lineTo(foregroundRect.right, foregroundRect.bottom);
      }

      _addTrianglePointToPath(
        size: foregroundRect,
        start: Offset(foregroundRect.right, foregroundRect.top),
        end: Offset(foregroundRect.right, foregroundRect.bottom),
        trianglePos: trianglePos,
        triangleSize: triangleSize,
        isTriangle: drawTriangle,
        isArc: drawArc,
        setDashPoints: setDashPoints,
        dividerPadding: dividerPadding,
      );

      if (drawBorder) {
        _addArcPointToPath(
          foregroundRect,
          Offset(foregroundRect.right, foregroundRect.bottom),
          Offset(foregroundRect.left, foregroundRect.bottom),
          borderRadius,
        );
      } else {
        lineTo(foregroundRect.left, foregroundRect.top);
      }

      _addTrianglePointToPath(
        size: foregroundRect,
        start: Offset(foregroundRect.left, foregroundRect.bottom),
        end: Offset(foregroundRect.left, foregroundRect.top),
        trianglePos: trianglePos,
        triangleSize: triangleSize,
        isTriangle: drawTriangle,
        isArc: drawArc,
        setDashPoints: setDashPoints,
        dividerPadding: dividerPadding,
      );
    }
  }

  void _addTrianglePointToPath({
    required Rect size,
    required Offset start,
    required Offset end,
    required double trianglePos,
    required Size triangleSize,
    Function(Offset offset)? setDashPoints,
    bool isTriangle = false,
    bool isArc = false,
    double dividerPadding = 0,
  }) {
    if (start.dy == end.dy) {
      //Draw Horizontal Triangle
      if (end.dx > start.dx) {
        if (isArc) {
          lineTo(start.dx, start.dy);
          lineTo(start.dx + (size.width * trianglePos) - triangleSize.width / 2,
              start.dy);
          arcToPoint(
              Offset(
                  start.dx +
                      (size.width * trianglePos) +
                      triangleSize.width / 2,
                  start.dy),
              radius: Radius.circular(triangleSize.width / 2),
              clockwise: false);
          lineTo(end.dx, end.dy);

          if (setDashPoints != null) {
            setDashPoints(Offset(start.dx + (size.width * trianglePos),
                start.dy + triangleSize.width / 2 + dividerPadding));
          }

          return;
        }

        lineTo(start.dx, start.dy);
        lineTo(start.dx + (size.width * trianglePos) - triangleSize.width / 2,
            start.dy);
        if (isTriangle) {
          lineTo(start.dx + (size.width * trianglePos),
              start.dy + triangleSize.height);
        }

        lineTo(start.dx + (size.width * trianglePos) + triangleSize.width / 2,
            start.dy);
        lineTo(end.dx, end.dy);

        if (setDashPoints != null) {
          setDashPoints(Offset(start.dx + (size.width * trianglePos),
              start.dy + triangleSize.height + dividerPadding));
        }
      } else {
        if (isArc) {
          lineTo(start.dx, start.dy);
          lineTo(end.dx + (size.width * trianglePos) + triangleSize.width / 2,
              end.dy);
          arcToPoint(
              Offset(
                  end.dx + (size.width * trianglePos) - triangleSize.width / 2,
                  end.dy),
              radius: Radius.circular(triangleSize.width / 2),
              clockwise: false);
          lineTo(end.dx, end.dy);
          if (setDashPoints != null) {
            setDashPoints(Offset(end.dx + (size.width * trianglePos),
                end.dy - triangleSize.height - dividerPadding));
          }
          return;
        }

        lineTo(start.dx, start.dy);
        lineTo(end.dx + (size.width * trianglePos) + triangleSize.width / 2,
            end.dy);
        if (isTriangle) {
          lineTo(end.dx + (size.width * trianglePos),
              end.dy - triangleSize.height);
        }

        lineTo(end.dx + (size.width * trianglePos) - triangleSize.width / 2,
            end.dy);
        lineTo(end.dx, end.dy);

        if (setDashPoints != null) {
          setDashPoints(Offset(
            end.dx + (size.width * trianglePos),
            end.dy - triangleSize.height - dividerPadding,
          ));
        }
      }
    } else if (start.dx == end.dx) {
      //Draw Vertical Triangle
      if (end.dy > start.dy) {
        if (isArc) {
          lineTo(start.dx, start.dy);
          lineTo(start.dx,
              start.dy + (size.height * trianglePos) - triangleSize.width / 2);
          arcToPoint(
              Offset(
                  start.dx,
                  start.dy +
                      (size.height * trianglePos) +
                      triangleSize.width / 2),
              radius: Radius.circular(triangleSize.width / 2),
              clockwise: false);
          lineTo(end.dx, end.dy);

          if (setDashPoints != null) {
            setDashPoints(Offset(start.dx - triangleSize.height,
                start.dy + (size.height * trianglePos)));
          }
          return;
        }

        lineTo(start.dx, start.dy);
        lineTo(start.dx,
            start.dy + (size.height * trianglePos) - (triangleSize.width / 2));
        if (isTriangle) {
          lineTo(start.dx - triangleSize.height,
              start.dy + (size.height * trianglePos));
        }

        lineTo(start.dx,
            start.dy + (size.height * trianglePos) + (triangleSize.width / 2));
        lineTo(end.dx, end.dy);

        if (setDashPoints != null) {
          setDashPoints(Offset(start.dx - triangleSize.height,
              start.dy + (size.height * trianglePos)));
        }
      } else {
        if (isArc) {
          lineTo(start.dx, start.dy);
          lineTo(end.dx,
              end.dy + (size.height * trianglePos) + triangleSize.width / 2);
          arcToPoint(
              Offset(
                  end.dx,
                  end.dy +
                      (size.height * trianglePos) -
                      triangleSize.width / 2),
              radius: Radius.circular(triangleSize.width / 2),
              clockwise: false);
          lineTo(end.dx, end.dy);

          if (setDashPoints != null) {
            setDashPoints(Offset(end.dx + triangleSize.height,
                end.dy + (size.height * trianglePos)));
          }

          return;
        }

        lineTo(start.dx, start.dy);
        lineTo(end.dx,
            end.dy + (size.height * trianglePos) + triangleSize.width / 2);
        if (isTriangle) {
          lineTo(end.dx + triangleSize.height,
              end.dy + (size.height * trianglePos));
        }

        lineTo(end.dx,
            end.dy + (size.height * trianglePos) - triangleSize.width / 2);
        lineTo(end.dx, end.dy);

        if (setDashPoints != null) {
          setDashPoints(Offset(end.dx + triangleSize.height,
              end.dy + (size.height * trianglePos)));
        }
      }
    }
  }

  void _addArcPointToPath(Rect size, Offset start, Offset end, double radius) {
    if (start.dx == end.dx) {
      //Draw vertical lines

      final double height = size.height.abs();
      final double offsetBothSide = (height % (radius * 3)) / 2;
      final int numOfArc = (height / (radius * 3)).truncate();

      if (end.dy > start.dy) {
        relativeLineTo(0, offsetBothSide);
        for (int i = 0; numOfArc > i; i++) {
          relativeLineTo(0, radius * .5);
          relativeArcToPoint(Offset(0, radius * 2),
              radius: Radius.circular(radius), clockwise: false);
          relativeLineTo(0, radius * .5);
        }
        relativeLineTo(0, offsetBothSide);
      } else {
        relativeLineTo(0, -offsetBothSide);
        for (int i = 0; numOfArc > i; i++) {
          relativeLineTo(0, -(radius * .5));
          relativeArcToPoint(Offset(0, -(radius * 2)),
              radius: Radius.circular(radius), clockwise: false);
          relativeLineTo(0, -(radius * .5));
        }
        relativeLineTo(0, -offsetBothSide);
      }
    } else if (start.dy == end.dy) {
      final double width = size.width.abs();
      final double offsetBothSide = (width % (radius * 3)) / 2;
      final int numOfArc = (width / (radius * 3)).truncate();

      if (end.dx > start.dx) {
        relativeLineTo(offsetBothSide, 0);
        for (int i = 0; numOfArc > i; i++) {
          relativeLineTo(radius * .5, 0);
          relativeArcToPoint(Offset(radius * 2, 0),
              radius: Radius.circular(radius), clockwise: false);
          relativeLineTo(radius * .5, 0);
        }
        relativeLineTo(offsetBothSide, 0);
      } else {
        relativeLineTo(-offsetBothSide, 0);
        for (int i = 0; numOfArc > i; i++) {
          relativeLineTo(-(radius * .5), 0);
          relativeArcToPoint(Offset(-(radius * 2), 0),
              radius: Radius.circular(radius), clockwise: false);
          relativeLineTo(-(radius * .5), 0);
        }
        relativeLineTo(-offsetBothSide, 0);
      }
    }
  }
}

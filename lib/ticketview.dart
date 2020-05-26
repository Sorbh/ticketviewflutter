import 'package:flutter/material.dart';

// class TicketView extends StatefulWidget {
//   final double radius;
//   final bool horizontal;
//   final bool vertical;
//   final bool drawTriangle;
//   final bool drawline;
//   final Size triangleSize;
//   final double trianglePos;

//   final Color cardColor;
//   final Color backgroundColor;

//   final EdgeInsets cardPadding;
//   final EdgeInsets backgroundPadding;

//   final Widget child;

//   TicketView({
//     this.radius = 3,
//     this.horizontal = false,
//     this.vertical = false,
//     this.drawTriangle = false,
//     this.triangleSize = const Size(30, 10),
//     this.trianglePos = .5,
//     this.cardColor =  Colors.white,
//     this.backgroundColor =  Colors.red,
//     this.cardPadding = const EdgeInsets.all(25),
//     this.backgroundPadding = const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 40),
//     this.child,
//     this.drawline = false,
//   });

//   @override
//   State<StatefulWidget> createState() {
//     return TicketViewState(radius, horizontal, vertical, drawTriangle, triangleSize, trianglePos, cardColor,
//         backgroundColor, cardPadding, backgroundPadding, child, drawline);
//   }
// }

class TicketView extends StatelessWidget {
  final double radius;
  final bool horizontal;
  final bool vertical;
  final bool drawTriangle;
  final bool drawline;

  final Size triangleSize;
  final double trianglePos;

  final Color cardColor;
  final Color backgroundColor;

  final EdgeInsets foregroundPadding;
  final EdgeInsets backgroundPadding;

  final Widget child;

  final EdgeInsets padding;

  TicketView({
    this.padding = EdgeInsets.zero,
    this.radius = 3,
    this.horizontal = false,
    this.vertical = false,
    this.drawTriangle = false,
    this.triangleSize = const Size(30, 10),
    this.trianglePos = .5,
    this.cardColor = Colors.white,
    this.backgroundColor = Colors.red,
    this.foregroundPadding = const EdgeInsets.all(25),
    this.backgroundPadding =
        const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 40),
    this.child,
    this.drawline = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
//      foregroundPainter: TicketClipper(radius, horizontal, vertical, triangleSize, trianglePos),
      painter: TicketClipper(
          radius,
          horizontal,
          vertical,
          drawTriangle,
          triangleSize,
          trianglePos,
          cardColor,
          backgroundColor,
          foregroundPadding,
          backgroundPadding,
          drawline),

      child: Container(
        padding: padding,
        child: Container(
//          color: Colors.yellow,
          child: child,
        ),
      ),
    );
  }
}

class TicketClipper extends CustomPainter {
  final double radius;
  final bool horizontal;
  final bool vertical;
  final bool drawTriangle;
  final bool drawline;
  final Size triangleSize;
  final double trianglePos;

  final Color cardColor;
  final Color backgroundColor;

  final EdgeInsets foregroundPadding;
  final EdgeInsets backgroundPadding;

  double xOffset = 0;
  double modifiedRadius = 0;

  Rect innerCardRect;

  Offset dashStart, dashEnd;

  TicketClipper(
      this.radius,
      this.horizontal,
      this.vertical,
      this.drawTriangle,
      this.triangleSize,
      this.trianglePos,
      this.cardColor,
      this.backgroundColor,
      this.foregroundPadding,
      this.backgroundPadding,
      this.drawline);

//   Path getClip(Size size) {
//     Path path = Path();
//     path.moveTo(innerCardRect.left, innerCardRect.top);

//     path.lineTo(innerCardRect.left, innerCardRect.bottom);
//     path.lineTo(innerCardRect.right, innerCardRect.bottom);
//     path.lineTo(innerCardRect.right, innerCardRect.top);
//     path.lineTo(innerCardRect.left, innerCardRect.top);

//     if (horizontal) {
//       modifiedRadius =
//           getLumSumRadiusHorizontal(innerCardRect.width, this.radius);

//       xOffset = innerCardRect.left;
//       while (true) {
//         xOffset += (modifiedRadius *
//             1.5); //.5 radius to left side gap and 1 radius to get offset to center
//         path.addOval(Rect.fromCircle(
//             center: Offset(xOffset, innerCardRect.top - modifiedRadius / 4),
//             radius: modifiedRadius));
//         xOffset += (modifiedRadius * 1.5);
//         if (xOffset > innerCardRect.right) {
//           break;
//         }
//       }

//       xOffset = innerCardRect.left;
//       while (true) {
//         xOffset += (modifiedRadius * 1.5);
//         path.addOval(Rect.fromCircle(
//             center: Offset(xOffset, innerCardRect.bottom + modifiedRadius / 4),
//             radius: modifiedRadius));
//         xOffset += (modifiedRadius * 1.5);
//         if (xOffset > innerCardRect.right) {
//           break;
//         }
//       }

//       //we are going ot draw triangle on cross axis
//       if (!vertical && drawTriangle) {
// //        path.moveTo(0.0, trianglePos * size.height);
//         path.addPolygon([
//           Offset(
//               innerCardRect.left,
//               innerCardRect.top +
//                   (trianglePos * size.height) -
//                   triangleSize.width / 2),
//           Offset(innerCardRect.left + triangleSize.height,
//               innerCardRect.top + (trianglePos * size.height)),
//           Offset(
//               innerCardRect.left,
//               innerCardRect.top +
//                   (trianglePos * size.height) +
//                   triangleSize.width / 2)
//         ], false);
//         path.moveTo(size.width, trianglePos * size.height);
// //
//         path.addPolygon([
//           Offset(
//               innerCardRect.right,
//               innerCardRect.top +
//                   (trianglePos * size.height) +
//                   triangleSize.width / 2),
//           Offset(innerCardRect.right - triangleSize.height,
//               innerCardRect.top + (trianglePos * size.height)),
//           Offset(
//               innerCardRect.right,
//               innerCardRect.top +
//                   (trianglePos * size.height) -
//                   triangleSize.width / 2),
//         ], false);
//       }
//     }
//     if (vertical) {
//       modifiedRadius =
//           getLumSumRadiusVertical(innerCardRect.height, this.radius);

//       xOffset = innerCardRect.top;
//       while (true) {
//         xOffset += (modifiedRadius *
//             1.5); //.5 radius to left side gap and 1 radius to get offset to center
//         path.addOval(Rect.fromCircle(
//             center: Offset(innerCardRect.left - modifiedRadius / 4, xOffset),
//             radius: modifiedRadius));
//         xOffset += (modifiedRadius * 1.5);
//         if (xOffset > innerCardRect.bottom) {
//           break;
//         }
//       }

//       xOffset = innerCardRect.top;
//       while (true) {
//         xOffset += (modifiedRadius * 1.5);
//         path.addOval(Rect.fromCircle(
//             center: Offset(innerCardRect.right + modifiedRadius / 4, xOffset),
//             radius: modifiedRadius));
//         xOffset += (modifiedRadius * 1.5);
//         if (xOffset > innerCardRect.bottom) {
//           break;
//         }
//       }

//       if (!horizontal && drawTriangle) {
//         dashStart = Offset(innerCardRect.left + (trianglePos * size.width),
//             innerCardRect.bottom - triangleSize.height);
//         path.addPolygon([
//           Offset(
//               innerCardRect.left +
//                   (trianglePos * size.width) -
//                   triangleSize.width / 2,
//               innerCardRect.bottom),
//           Offset(innerCardRect.left + (trianglePos * size.width),
//               innerCardRect.bottom - triangleSize.height),
//           Offset(
//               innerCardRect.left +
//                   (trianglePos * size.width) +
//                   triangleSize.width / 2,
//               innerCardRect.bottom),
//         ], false);
// //
//         dashEnd = Offset(innerCardRect.left + (trianglePos * size.width),
//             innerCardRect.top + triangleSize.height);
//         path.addPolygon([
//           Offset(
//               innerCardRect.left +
//                   (trianglePos * size.width) +
//                   triangleSize.width / 2,
//               innerCardRect.top),
//           Offset(innerCardRect.left + (trianglePos * size.width),
//               innerCardRect.top + triangleSize.height),
//           Offset(
//               innerCardRect.left +
//                   (trianglePos * size.width) -
//                   triangleSize.width / 2,
//               innerCardRect.top),
//         ], false);
//       }
//     }
//     return path;
//   }

  // double getLumSumRadiusHorizontal(double width, double radius) {
  //   //on Complete Curve take 3 radius space. .5 left gap, 2 radius circle space, .5 right space
  //   double count = width / (3 * radius);
  //   double modifiedRadius = width / (3 * count.round());
  //   return modifiedRadius;
  // }

  // double getLumSumRadiusVertical(double height, double radius) {
  //   //on Complete Curve take 3 radius space. .5 left gap, 2 radius circle space, .5 right space
  //   double count = height / (radius);
  //   double modifiedRadius = height / (count.round());
  //   return modifiedRadius;
  // }

  @override
  void paint(Canvas canvas, Size size) {
    //Get Background Rect
    Paint paint = Paint();
    paint.color = backgroundColor;
    paint.style = PaintingStyle.fill;
    RRect backgroundRect = RRect.fromLTRBR(
        0 + backgroundPadding.left,
        0 + backgroundPadding.top,
        size.width - backgroundPadding.right,
        size.height - backgroundPadding.bottom,
        Radius.circular(2));

    canvas.drawRRect(backgroundRect, paint);

    //Get foreground Rect
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;

    Rect foregroundRect = Rect.fromLTRB(
        0 + foregroundPadding.left,
        0 + foregroundPadding.top,
        size.width - foregroundPadding.right,
        size.height - foregroundPadding.bottom);

    //Clip the triangle or Arc
    Path path = Path();

    path.moveTo(foregroundRect.left, foregroundRect.top);

    _addTrianglePointToPath(
        foregroundRect,
        path,
        Offset(foregroundRect.left, foregroundRect.top),
        Offset(foregroundRect.right, foregroundRect.top),
        trianglePos,
        triangleSize);

    _addArcPointToPath(
        foregroundRect,
        path,
        Offset(foregroundRect.right, foregroundRect.top),
        Offset(foregroundRect.right, foregroundRect.bottom),
        4);

    _addTrianglePointToPath(
        foregroundRect,
        path,
        Offset(foregroundRect.right, foregroundRect.bottom),
        Offset(foregroundRect.left, foregroundRect.bottom),
        trianglePos,
        triangleSize);

    _addArcPointToPath(
        foregroundRect,
        path,
        Offset(foregroundRect.left, foregroundRect.bottom),
        Offset(foregroundRect.left, foregroundRect.top),
        4);

    canvas.clipPath(path);

    path.reset();

    path.moveTo(foregroundRect.left, foregroundRect.top);
    path.lineTo(foregroundRect.right, foregroundRect.top);
    path.lineTo(foregroundRect.right, foregroundRect.bottom);
    path.lineTo(foregroundRect.left, foregroundRect.bottom);

    paint.color = Colors.indigo;
    // canvas.drawPath(path, paint);
    canvas.drawRect(foregroundRect, paint);
  }

  void _addTrianglePointToPath(Rect size, Path path, Offset start, Offset end,
      double trianglePos, Size triangleSize) {
    if (start.dy == end.dy) {
      //Draw Horizontal Triangle

      if (end.dx > start.dx) {
        path.addPolygon([
          start,
          Offset((size.width * trianglePos) - triangleSize.width / 2, size.top),
          Offset((size.width * trianglePos), size.top + triangleSize.height),
          Offset((size.width * trianglePos) + triangleSize.width / 2, size.top),
          end,
        ], false);
      } else {
        path.addPolygon([
          start,
          Offset(
              (size.width * trianglePos) + triangleSize.width / 2, size.bottom),
          Offset((size.width * trianglePos), size.bottom - triangleSize.height),
          Offset(
              (size.width * trianglePos) - triangleSize.width / 2, size.bottom),
          end,
        ], false);
      }
    }
  }

  void _addArcPointToPath(
      Rect size, Path path, Offset start, Offset end, double radius) {
    if (start.dx == end.dx) {
      //Draw vertical lines

      double height = (end.dy - start.dy).abs();
      double offsetBothSide = (height % (radius * 2.5)) / 2;
      int numOfArc = (height / (radius * 2.5)).truncate();

      if (end.dy > start.dy) {
        path.relativeLineTo(0, offsetBothSide);
        for (int i = 0; numOfArc > i; i++) {
          path.relativeLineTo(0, radius * .25);
          // path.relativeLineTo(0, radius * 2);
          path.relativeArcToPoint(Offset(0, radius * 2),
              radius: Radius.circular(radius), clockwise: false);
          path.relativeLineTo(0, radius * .25);
        }
        path.relativeLineTo(0, offsetBothSide);
      } else {
        path.relativeLineTo(0, -offsetBothSide);
        for (int i = 0; numOfArc > i; i++) {
          path.relativeLineTo(0, -(radius * .25));
          path.relativeArcToPoint(Offset(0, -(radius * 2)),
              radius: Radius.circular(radius), clockwise: false);
          path.relativeLineTo(0, -(radius * .25));
        }
        path.relativeLineTo(0, -offsetBothSide);
      }
    }
  }

  // void drawDashedLine(Canvas canvas, Offset start, Offset end) {
  //   if (start.dx == end.dx) {
  //     Offset tempStar, tempEnd;
  //     if (start.dy > end.dy) {
  //       tempStar = end;
  //       tempEnd = start;
  //     } else {
  //       tempStar = start;
  //       tempEnd = end;
  //     }
  //     Paint dashLinePaint = Paint();
  //     dashLinePaint.color = Colors.black87;
  //     dashLinePaint.strokeWidth = .3;

  //     var dashWidth = 4;
  //     var dashSpace = 4;
  //     double startY = tempStar.dy;
  //     var maxY = tempEnd.dy;

  //     while (maxY >= 0) {
  //       canvas.drawLine(Offset(tempStar.dx, startY),
  //           Offset(tempEnd.dx, startY + dashWidth), dashLinePaint);
  //       final space = (dashSpace + dashWidth);
  //       startY += space;
  //       maxY -= space;
  //       // print('${maxY}');
  //     }
  //   }
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

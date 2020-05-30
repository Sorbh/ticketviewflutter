
# TicketViewFlutter
TicketViewFlutter is a simple and customizable Ticket/Receipt View for Flutter.
The source code is **100% Dart**.

[![pub package](https://img.shields.io/pub/v/ticketview.svg?style=flat-square)](https://pub.dartlang.org/packages/ticketviewflutter) ![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg?style=flat-square)


# Motivation

I need some clean Ticket/Receipt View view for my Flutter application.

# Getting started

## Installing
Add this to your package's pubspec.yaml file:

This library is posted in pub.dev

#### pubspec.yaml
```dart
dependencies:  
	ticketview: ^1.0.0
```

# Usage

After Importing this library, you can directly use this view in your Widget tree

```dart
import 'package:ticketview/ticketview.dart';
```

Default Ticket View
```dart
TicketView(
        child: Container(),
    )
```

Customized Receipt View

```Dart
TicketView(
      backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      backgroundColor: Color(0xFF8F1299),
      contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
      drawArc: false,
      triangleAxis: Axis.vertical,
      borderRadius: 6,
      drawDivider: true,
      trianglePos: .5,
      child: Container(),
    )
```


# Customization
  Depending on your view you may want to tweak the UI. For now you can these custom attributes

  | Property | Type | Description |
  |----------|------|-------------|
  | `backgroundColor` | Color | Background card color for TicketView |
  | `contentBackgroundColor` | Color | Content card color for TicketView |



# Screenshots
| Default View | Receipt View |
|----------|------|
| ![alt text](https://github.com/sorbh/ticketviewflutter/blob/master/raw/1.jpg) | ![alt text](https://github.com/sorbh/ticketviewflutter/blob/master/raw/2.jpg) |


 


# Author
  * **Saurabh K Sharma - [GIT](https://github.com/Sorbh)**
  
      I am very new to open source community. All suggestion and improvement are most welcomed. 
  
 
## Contributing

1. Fork it (<https://github.com/sorbh/ticketviewflutter/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

